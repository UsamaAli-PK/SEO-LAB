#!/usr/bin/env python3
"""collect_findings.py - Read only the YAML frontmatter from every raw/*.md file.

Gives the orchestrator a compact summary instead of loading full agent bodies
(fixes the Phase 3 context explosion).

Usage:
    python collect_findings.py --domain <domain-slug> [--format json|markdown]
"""
from __future__ import annotations

import argparse
import glob
import json
import os
import sys

PROJECTS_ROOT = r"D:\code\seo\Projects"


def parse_frontmatter(path: str) -> dict | None:
    """Tolerant frontmatter parser. No pyyaml required.

    Handles `key: value` and simple `- item` list entries under `summary:`.
    Returns dict of parsed keys, or None if no frontmatter delimiters present.
    """
    try:
        with open(path, "r", encoding="utf-8-sig", errors="replace") as f:
            lines = f.read().splitlines()
    except Exception:
        return None

    # Find opening --- (allow leading blank lines / BOM)
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
        # list item
        if stripped.startswith("- ") or stripped == "-":
            if current_list_key is not None:
                item = stripped[1:].strip()
                item = _unquote(item)
                if item:
                    data[current_list_key].append(item)
            continue
        # key: value
        if ":" in raw:
            key, _, val = raw.partition(":")
            key = key.strip()
            val = val.strip()
            if val == "":
                # could be a list or block following
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
    try:
        if val.lstrip("-").isdigit():
            return int(val)
    except Exception:
        pass
    return val


def build_record(path: str) -> dict:
    fname = os.path.basename(path)
    fm = parse_frontmatter(path)
    if fm is None:
        return {
            "file": fname,
            "agent": fname,
            "score": None,
            "status": "NO_FRONTMATTER",
            "summary": [],
        }
    summary = fm.get("summary", [])
    if not isinstance(summary, list):
        summary = [str(summary)] if summary else []
    return {
        "file": fname,
        "agent": fm.get("agent") or fname,
        "score": fm.get("score") if isinstance(fm.get("score"), int) else (None if fm.get("score") in (None, "") else fm.get("score")),
        "status": fm.get("status") or "UNKNOWN",
        "summary": summary,
    }


def to_markdown(records: list[dict]) -> str:
    out = ["| File | Agent | Score | Status |", "| --- | --- | --- | --- |"]
    for r in records:
        score = r["score"] if r["score"] is not None else "—"
        out.append(f"| {r['file']} | {r['agent']} | {score} | {r['status']} |")
    out.append("")
    for r in records:
        if r["summary"]:
            out.append(f"### {r['agent']} ({r['file']})")
            for b in r["summary"]:
                out.append(f"- {b}")
            out.append("")
    return "\n".join(out)


def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="Collect frontmatter summaries from raw/*.md in a project."
    )
    parser.add_argument("--domain", required=True, help="Domain slug")
    parser.add_argument(
        "--format", choices=["json", "markdown"], default="json", help="Output format"
    )
    args = parser.parse_args(argv)

    raw_dir = os.path.join(PROJECTS_ROOT, args.domain, "raw")
    files = sorted(glob.glob(os.path.join(raw_dir, "*.md")))

    records = []
    for path in files:
        try:
            records.append(build_record(path))
        except Exception as e:
            records.append(
                {
                    "file": os.path.basename(path),
                    "agent": os.path.basename(path),
                    "score": None,
                    "status": f"PARSE_ERROR: {type(e).__name__}",
                    "summary": [],
                }
            )

    valid = sum(
        1
        for r in records
        if r["status"] not in ("NO_FRONTMATTER",)
        and not r["status"].startswith("PARSE_ERROR")
    )
    total = len(records)

    if args.format == "markdown":
        print(to_markdown(records))
    else:
        print(json.dumps(records, indent=2, ensure_ascii=False))

    print(f"\n{valid} of {total} raw files have valid frontmatter.", file=sys.stderr)
    return 0


if __name__ == "__main__":
    try:
        sys.exit(main())
    except KeyboardInterrupt:
        sys.exit(130)
    except Exception as e:
        sys.stderr.write(f"FATAL: {type(e).__name__}: {e}\n")
        sys.exit(1)
