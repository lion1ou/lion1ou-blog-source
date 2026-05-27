#!/usr/bin/env python3
"""Validate search source wiring and JSON output contracts."""

from __future__ import annotations

import json
import re
import subprocess
import sys
from pathlib import Path


ROOT = Path(__file__).resolve().parents[1]
CONFIG = ROOT / "scripts" / "config" / "engines.sh"
SOURCES = ROOT / "scripts" / "sources"


def parse_config() -> tuple[list[str], list[str]]:
    text = CONFIG.read_text(encoding="utf-8")
    engines_match = re.search(r"ENGINES=\((.*?)\)", text, re.S)
    enabled_match = re.search(r'ENABLED_ENGINES="([^"]*)"', text)
    if not engines_match or not enabled_match:
        raise AssertionError("Unable to parse engines config")
    engines = re.findall(r'"([^"]+)"', engines_match.group(1))
    enabled = [item.strip() for item in enabled_match.group(1).split(",") if item.strip()]
    return engines, enabled


def run_source(engine: str) -> dict[str, object]:
    script = SOURCES / f"{engine}.sh"
    cmd = ["bash", str(script), "--query", "AI coding agent MCP", "--limit", "2", "--timeout", "8000"]
    completed = subprocess.run(cmd, cwd=ROOT, capture_output=True, timeout=15)
    stdout = completed.stdout.decode("utf-8", "replace").strip()
    stderr = completed.stderr.decode("utf-8", "replace").strip()
    result: dict[str, object] = {
        "engine": engine,
        "exit_code": completed.returncode,
        "stderr": stderr[:300],
    }
    try:
        parsed = json.loads(stdout)
    except json.JSONDecodeError as exc:
        result["error"] = f"stdout is not JSON: {exc}"
        result["stdout"] = stdout[:300]
        return result
    if not isinstance(parsed, list):
        result["error"] = "stdout JSON is not an array"
        result["stdout"] = stdout[:300]
        return result
    result["count"] = len(parsed)
    return result


def main() -> int:
    engines, enabled = parse_config()
    errors: list[str] = []
    if enabled != engines:
        errors.append(f"ENABLED_ENGINES must include all sources in order: expected {engines}, got {enabled}")

    source_results = [run_source(engine) for engine in engines]
    for result in source_results:
        if result["exit_code"] != 0:
            errors.append(f"{result['engine']} exited {result['exit_code']}: {result.get('stderr', '')}")
        if result.get("stderr"):
            errors.append(f"{result['engine']} wrote stderr: {result.get('stderr', '')}")
        if "error" in result:
            errors.append(f"{result['engine']}: {result['error']}")

    report = {
        "engines": engines,
        "enabled": enabled,
        "sources": source_results,
        "errors": errors,
    }
    print(json.dumps(report, ensure_ascii=False, indent=2))
    return 1 if errors else 0


if __name__ == "__main__":
    sys.exit(main())
