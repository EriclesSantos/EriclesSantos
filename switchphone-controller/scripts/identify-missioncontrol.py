#!/usr/bin/env python3
"""Identify a copied MissionControl exefs.nsp by its exact official release fingerprint."""
import argparse
import hashlib
import json
from pathlib import Path


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("module", type=Path, help="Local copy of atmosphere/contents/010000000000bd00/exefs.nsp")
    parser.add_argument("--json", action="store_true", help="Print structured metadata")
    args = parser.parse_args()
    reference = Path(__file__).resolve().parents[1] / "docs/missioncontrol-reference.json"
    try:
        catalog = json.loads(reference.read_text(encoding="utf-8"))
        digest = hashlib.sha256()
        size = 0
        with args.module.open("rb") as module:
            for chunk in iter(lambda: module.read(65536), b""):
                size += len(chunk)
                digest.update(chunk)
    except (OSError, ValueError) as error:
        parser.error(str(error))
    fingerprint = digest.hexdigest()
    matches = [r for r in catalog["releases"] if r["module_bytes"] == size and r["module_sha256"] == fingerprint]
    result = {"bytes": size, "sha256": fingerprint, "official_matches": [r["version"] for r in matches]}
    if args.json:
        print(json.dumps(result, ensure_ascii=False))
    else:
        print("SHA-256:", fingerprint)
        print("Bytes:", size)
        print("Correspondência oficial:", ", ".join(result["official_matches"]) if matches else "não identificada; pode ser outra versão/build")
    return 0 if matches else 2


if __name__ == "__main__":
    raise SystemExit(main())
