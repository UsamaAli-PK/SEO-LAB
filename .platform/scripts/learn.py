#!/usr/bin/env python3
"""learn.py - Cross-client learning store as append-only JSONL.

Greppable by any agent. Never rewrites the store.

Usage:
    python learn.py add --category <cat> --pattern "<text>" [--confidence 0.0-1.0] [--source <domain>]
    python learn.py search "<query>" [--limit 10]
    python learn.py list [--category <cat>] [--limit 20]
"""
from __future__ import annotations

import argparse
import json
import os
import sys
from datetime import datetime, timezone

STORE_DIR = r"D:\code\seo\Projects\_learnings"
STORE_PATH = os.path.join(STORE_DIR, "learnings.jsonl")


def now_iso() -> str:
    return datetime.now(timezone.utc).isoformat()


def ensure_store() -> bool:
    try:
        os.makedirs(STORE_DIR, exist_ok=True)
        return True
    except Exception as e:
        sys.stderr.write(f"ERROR: cannot create store dir {STORE_DIR}: {e}\n")
        return False


def read_all() -> list[dict]:
    """Read store, skipping malformed lines. Empty/missing -> []."""
    if not os.path.exists(STORE_PATH):
        return []
    entries = []
    try:
        with open(STORE_PATH, "r", encoding="utf-8", errors="replace") as f:
            for line in f:
                line = line.strip()
                if not line:
                    continue
                try:
                    obj = json.loads(line)
                    if isinstance(obj, dict):
                        entries.append(obj)
                except Exception:
                    continue  # skip malformed
    except Exception as e:
        sys.stderr.write(f"WARNING: could not read store: {e}\n")
    return entries


def cmd_add(args) -> int:
    if not ensure_store():
        return 1
    confidence = args.confidence
    if confidence is not None:
        try:
            confidence = max(0.0, min(1.0, float(confidence)))
        except Exception:
            confidence = None
    entry = {
        "date": now_iso(),
        "category": args.category,
        "pattern": args.pattern,
        "confidence": confidence,
        "source": args.source,
    }
    try:
        with open(STORE_PATH, "a", encoding="utf-8") as f:
            f.write(json.dumps(entry, ensure_ascii=False) + "\n")
    except Exception as e:
        sys.stderr.write(f"ERROR: cannot append to store: {e}\n")
        return 1
    print(f"ADDED [{entry['category']}] {entry['pattern']}")
    return 0


def fmt_entry(e: dict) -> str:
    conf = e.get("confidence")
    conf_s = f"{conf:.2f}" if isinstance(conf, (int, float)) else "—"
    src = e.get("source") or "—"
    date = (e.get("date") or "")[:19]
    return (
        f"- [{e.get('category', '?')}] {e.get('pattern', '')}\n"
        f"    confidence={conf_s}  source={src}  date={date}"
    )


def cmd_search(args) -> int:
    entries = read_all()
    if not entries:
        print("no learnings yet")
        return 0
    q = args.query.lower()
    matches = [
        e
        for e in entries
        if q in str(e.get("pattern", "")).lower()
        or q in str(e.get("category", "")).lower()
    ]
    matches.reverse()  # newest-first (file is append-only chronological)
    matches = matches[: args.limit]
    if not matches:
        print(f"no matches for '{args.query}'")
        return 0
    print(f"{len(matches)} match(es) for '{args.query}':")
    for e in matches:
        print(fmt_entry(e))
    return 0


def cmd_list(args) -> int:
    entries = read_all()
    if not entries:
        print("no learnings yet")
        return 0
    if args.category:
        entries = [
            e for e in entries if str(e.get("category", "")).lower() == args.category.lower()
        ]
    entries.reverse()
    entries = entries[: args.limit]
    if not entries:
        print("no learnings yet")
        return 0
    print(f"{len(entries)} entr(ies):")
    for e in entries:
        print(fmt_entry(e))
    return 0


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(description="Append-only cross-client learning store.")
    sub = parser.add_subparsers(dest="command", required=True)

    p_add = sub.add_parser("add", help="Append a learning")
    p_add.add_argument("--category", required=True)
    p_add.add_argument("--pattern", required=True)
    p_add.add_argument("--confidence", default=None)
    p_add.add_argument("--source", default=None)
    p_add.set_defaults(func=cmd_add)

    p_search = sub.add_parser("search", help="Search learnings")
    p_search.add_argument("query")
    p_search.add_argument("--limit", type=int, default=10)
    p_search.set_defaults(func=cmd_search)

    p_list = sub.add_parser("list", help="List recent learnings")
    p_list.add_argument("--category", default=None)
    p_list.add_argument("--limit", type=int, default=20)
    p_list.set_defaults(func=cmd_list)

    args = parser.parse_args(argv)
    return args.func(args)


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:
        sys.stderr.write(f"FATAL: {type(e).__name__}: {e}\n")
        sys.exit(1)
