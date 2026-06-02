#!/usr/bin/env python3
"""audit_preflight.py - Validation GATE before Phase 3 scoring of an SEO audit.

Confirms all required Tier-A raw files exist and are not stubs (mirrors the
blog preflight pattern).

Usage:
    python audit_preflight.py --domain <domain-slug> [--strict] [--json]
"""
from __future__ import annotations

import argparse
import json
import os
import sys

PROJECTS_ROOT = r"D:\code\seo\Projects"
MIN_BYTES = 400

REQUIRED = [
    "technical.md",
    "content.md",
    "schema.md",
    "sitemap.md",
    "geo.md",
    "performance.md",
    "visual.md",
    "sxo.md",
]

OPTIONAL = [
    "google.md",
    "backlinks.md",
    "local.md",
    "maps.md",
    "ecommerce.md",
    "cluster.md",
    "dataforseo.md",
    "flow.md",
]


def parse_frontmatter(path: str) -> dict | None:
    """Tolerant frontmatter parser (duplicated to keep scripts independent)."""
    try:
        with open(path, "r", encoding="utf-8-sig", errors="replace") as f:
            lines = f.read().splitlines()
    except Exception:
        return None

    idx = 0
    while idx < len(lines) and lines[idx].strip() == "":
        idx += 1
    if idx >= len(lines) or lines[idx].strip().lstrip("﻿") != "---":
        return None

    fm_lines = []
    closed = False
    for line in lines[idx + 1 :]:
        if line.strip() == "---":
            closed = True
            break
        fm_lines.append(line)
    if not closed:
        return None

    data: dict = {}
    current_list_key = None
    for raw in fm_lines:
        if raw.strip() == "" or raw.lstrip().startswith("#"):
            continue
        stripped = raw.strip()
        if stripped.startswith("- ") or stripped == "-":
            if current_list_key is not None:
                item = _unquote(stripped[1:].strip())
                if item:
                    data[current_list_key].append(item)
            continue
        if ":" in raw:
            key, _, val = raw.partition(":")
            key = key.strip()
            val = val.strip()
            if val == "":
                data[key] = []
                current_list_key = key
            else:
                data[key] = _coerce(_unquote(val))
                current_list_key = None
    return data


def _unquote(s: str) -> str:
    s = s.strip()
    if len(s) >= 2 and s[0] == s[-1] and s[0] in "\"'":
        return s[1:-1]
    return s


def _coerce(val: str):
    low = val.lower()
    if low in ("null", "none", "~", ""):
        return None
    if low == "true":
        return True
    if low == "false":
        return False
    if val.lstrip("-").isdigit():
        return int(val)
    return val


def check_required(path: str) -> str:
    """Return PASS / MISSING / STUB for a required file."""
    if not os.path.exists(path):
        return "MISSING"
    try:
        size = os.path.getsize(path)
    except Exception:
        return "MISSING"
    if size <= MIN_BYTES:
        return "STUB"
    fm = parse_frontmatter(path)
    if fm is None:
        return "STUB"
    score = fm.get("score")
    if score is None:
        return "STUB"
    return "PASS"


def check_deps() -> list[str]:
    warnings = []
    try:
        import textstat  # noqa: F401
    except Exception:
        warnings.append(
            "textstat not installed - readability scores will be degraded."
        )
    try:
        import bs4  # noqa: F401
    except Exception:
        warnings.append("bs4 not installed - HTML parsing scores will be degraded.")
    return warnings


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="Preflight gate validating required raw audit files."
    )
    parser.add_argument("--domain", required=True, help="Domain slug")
    parser.add_argument("--strict", action="store_true", help="Exit 1 on MISSING/STUB")
    parser.add_argument("--json", action="store_true", help="JSON output")
    args = parser.parse_args(argv)

    raw_dir = os.path.join(PROJECTS_ROOT, args.domain, "raw")

    required_results = {}
    for name in REQUIRED:
        required_results[name] = check_required(os.path.join(raw_dir, name))

    optional_results = {}
    for name in OPTIONAL:
        optional_results[name] = (
            "PRESENT" if os.path.exists(os.path.join(raw_dir, name)) else "ABSENT"
        )

    warnings = check_deps()

    failures = [n for n, r in required_results.items() if r != "PASS"]
    blocked = bool(failures) and args.strict
    passed = not failures

    report = {
        "domain": args.domain,
        "required": required_results,
        "optional": optional_results,
        "warnings": warnings,
        "passed": passed,
        "blocked": blocked,
    }

    if args.json:
        print(json.dumps(report, indent=2, ensure_ascii=False))
    else:
        print(f"Preflight gate for: {args.domain}")
        print("\nRequired (Tier-A):")
        for name in REQUIRED:
            print(f"  [{required_results[name]:>7}] {name}")
        print("\nOptional (Tier-B/C):")
        for name in OPTIONAL:
            print(f"  [{optional_results[name]:>7}] {name}")
        if warnings:
            print("\nWarnings:")
            for w in warnings:
                print(f"  WARNING: {w}")

    if failures:
        miss = [n for n in failures if required_results[n] == "MISSING"]
        stub = [n for n in failures if required_results[n] == "STUB"]
        reasons = []
        if miss:
            reasons.append("missing: " + ", ".join(miss))
        if stub:
            reasons.append("stub: " + ", ".join(stub))
        print(f"PREFLIGHT BLOCKED: {'; '.join(reasons)}")
    else:
        print("PREFLIGHT PASS")

    return 1 if blocked else 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:
        sys.stderr.write(f"FATAL: {type(e).__name__}: {e}\n")
        sys.exit(1)
