#!/usr/bin/env bash
# Evaluates a targeted boolean flag over flagd's HTTP (connect) API.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
trap 'docker compose -f "$here/compose.yaml" down -v >/dev/null 2>&1' EXIT
docker compose -f "$here/compose.yaml" up -d
eval_flag() {
  curl -sf -X POST localhost:8013/flagd.evaluation.v1.Service/ResolveBoolean \
    -H 'Content-Type: application/json' \
    -d "{\"flagKey\":\"express-checkout\",\"context\":{\"email\":\"$1\"}}"
}
for _ in $(seq 30); do eval_flag a@example.com >/tmp/pcd-flag-in.json && break; sleep 1; done
eval_flag a@other.org >/tmp/pcd-flag-out.json
python3 - <<'P'
import json
a = json.load(open("/tmp/pcd-flag-in.json")); b = json.load(open("/tmp/pcd-flag-out.json"))
assert a["value"] is True and b.get("value", False) is False, (a, b)
print("OK: @example.com gets express-checkout, others do not")
P
