#!/usr/bin/env python3
"""fetch_cache.py - Fetch a URL exactly once and cache it.

Prevents N parallel audit agents from each re-fetching the same page.
Writes raw HTML, a meta.json sidecar, and a markdown text extraction.

Usage:
    python fetch_cache.py <url> --domain <domain-slug> [--force] [--max-age-hours 24]
"""
from __future__ import annotations

import argparse
import json
import os
import re
import sys
from datetime import datetime, timezone
from urllib.parse import urlparse

# Repo root derived from this file's location (.platform/scripts/) — no hardcoded paths.
PROJECTS_ROOT = os.path.join(
    os.path.dirname(os.path.dirname(os.path.dirname(os.path.abspath(__file__)))),
    "Projects",
)
USER_AGENT = (
    "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 "
    "(KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36"
)
TIMEOUT = 20

try:
    from bs4 import BeautifulSoup  # type: ignore

    HAVE_BS4 = True
except Exception:
    HAVE_BS4 = False

try:
    import requests  # type: ignore

    HAVE_REQUESTS = True
except Exception:
    HAVE_REQUESTS = False


def now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def slug_from_url(url: str) -> str:
    """Derive a filesystem-safe slug from the URL path. Homepage -> 'homepage'."""
    try:
        path = urlparse(url).path or "/"
    except Exception:
        path = "/"
    path = path.strip("/")
    if not path:
        return "homepage"
    slug = re.sub(r"[^a-zA-Z0-9._-]+", "-", path).strip("-").lower()
    return slug or "homepage"


def extract_text(html: str) -> str:
    """Extract visible text from HTML. Uses bs4 if available, else regex fallback."""
    if HAVE_BS4:
        try:
            soup = BeautifulSoup(html, "html.parser")
            for tag in soup(["script", "style", "noscript", "template"]):
                tag.decompose()
            text = soup.get_text(separator="\n")
            lines = [ln.strip() for ln in text.splitlines()]
            return "\n".join(ln for ln in lines if ln)
        except Exception:
            pass  # fall through to regex
    # regex fallback
    cleaned = re.sub(
        r"<(script|style|noscript|template)[^>]*>.*?</\1>",
        " ",
        html,
        flags=re.DOTALL | re.IGNORECASE,
    )
    cleaned = re.sub(r"<[^>]+>", " ", cleaned)
    cleaned = re.sub(r"&nbsp;", " ", cleaned)
    cleaned = re.sub(r"&amp;", "&", cleaned)
    lines = [ln.strip() for ln in cleaned.splitlines()]
    out = "\n".join(ln for ln in lines if ln)
    out = re.sub(r"[ \t]{2,}", " ", out)
    return out


def write_meta(meta_path: str, meta: dict) -> None:
    try:
        with open(meta_path, "w", encoding="utf-8") as f:
            json.dump(meta, f, indent=2, ensure_ascii=False)
    except Exception as e:
        sys.stderr.write(f"WARNING: could not write meta {meta_path}: {e}\n")


def age_hours(iso_ts: str) -> float | None:
    try:
        dt = datetime.fromisoformat(iso_ts)
        if dt.tzinfo is None:
            dt = dt.replace(tzinfo=timezone.utc)
        delta = datetime.now(timezone.utc) - dt
        return delta.total_seconds() / 3600.0
    except Exception:
        return None


def do_fetch(url: str):
    """Fetch URL. Returns (status_code, final_url, content_bytes) or raises."""
    if HAVE_REQUESTS:
        resp = requests.get(
            url, headers={"User-Agent": USER_AGENT}, timeout=TIMEOUT, allow_redirects=True
        )
        return resp.status_code, resp.url, resp.content
    # stdlib fallback
    import urllib.request

    req = urllib.request.Request(url, headers={"User-Agent": USER_AGENT})
    with urllib.request.urlopen(req, timeout=TIMEOUT) as r:
        data = r.read()
        return getattr(r, "status", 200), r.geturl(), data


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="Fetch a URL once and cache HTML + meta + markdown text."
    )
    parser.add_argument("url", help="URL to fetch")
    parser.add_argument("--domain", required=True, help="Domain slug (output folder name)")
    parser.add_argument("--force", action="store_true", help="Ignore cache and re-fetch")
    parser.add_argument(
        "--max-age-hours", type=float, default=24.0, help="Max cache age before refetch"
    )
    args = parser.parse_args(argv)

    cache_dir = os.path.join(PROJECTS_ROOT, args.domain, "cache")
    try:
        os.makedirs(cache_dir, exist_ok=True)
    except Exception as e:
        sys.stderr.write(f"ERROR: cannot create cache dir {cache_dir}: {e}\n")
        return 1

    slug = slug_from_url(args.url)
    html_path = os.path.join(cache_dir, f"{slug}.html")
    meta_path = os.path.join(cache_dir, f"{slug}.meta.json")
    md_path = os.path.join(cache_dir, f"{slug}.md")

    # Cache-hit check
    if not args.force and os.path.exists(meta_path):
        try:
            with open(meta_path, "r", encoding="utf-8") as f:
                existing = json.load(f)
            ts = existing.get("fetched_at")
            ah = age_hours(ts) if ts else None
            if ah is not None and ah < args.max_age_hours and not existing.get("error"):
                print(f"CACHE HIT: {html_path} (age {ah:.1f}h)")
                return 0
        except Exception:
            pass  # treat as miss

    # Fetch
    try:
        status, final_url, content = do_fetch(args.url)
    except Exception as e:
        meta = {
            "url": args.url,
            "fetched_at": now_iso(),
            "status_code": None,
            "content_length": 0,
            "final_url": None,
            "bs4_used": False,
            "error": f"{type(e).__name__}: {e}",
        }
        write_meta(meta_path, meta)
        sys.stderr.write(f"ERROR: fetch failed for {args.url}: {e}\n")
        return 1

    if status is None or status >= 400:
        meta = {
            "url": args.url,
            "fetched_at": now_iso(),
            "status_code": status,
            "content_length": len(content),
            "final_url": final_url,
            "bs4_used": False,
            "error": f"HTTP {status}",
        }
        write_meta(meta_path, meta)
        sys.stderr.write(f"ERROR: HTTP {status} for {args.url}\n")
        return 1

    try:
        html = content.decode("utf-8", errors="replace")
    except Exception:
        html = content.decode("latin-1", errors="replace")

    try:
        with open(html_path, "w", encoding="utf-8") as f:
            f.write(html)
    except Exception as e:
        sys.stderr.write(f"ERROR: cannot write html {html_path}: {e}\n")
        return 1

    text = extract_text(html)
    try:
        with open(md_path, "w", encoding="utf-8") as f:
            f.write(text)
    except Exception as e:
        sys.stderr.write(f"WARNING: cannot write md {md_path}: {e}\n")

    meta = {
        "url": args.url,
        "fetched_at": now_iso(),
        "status_code": status,
        "content_length": len(content),
        "final_url": final_url,
        "bs4_used": HAVE_BS4,
        "error": None,
    }
    write_meta(meta_path, meta)

    print(f"FETCHED: {args.url} (HTTP {status})")
    print(f"  html: {html_path}")
    print(f"  meta: {meta_path}")
    print(f"  md:   {md_path}")
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:  # last-resort guard, never crash caller
        sys.stderr.write(f"FATAL: {type(e).__name__}: {e}\n")
        sys.exit(1)
