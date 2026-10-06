#!/usr/bin/env bash
# Builds a throwaway git repo from ./config-repo, serves it with Spring Cloud Config, asserts the profile overlay.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
export CONFIG_REPO_DIR="$(mktemp -d)"
cp "$here"/config-repo/*.yml "$CONFIG_REPO_DIR"/
git -C "$CONFIG_REPO_DIR" init -q -b main
git -C "$CONFIG_REPO_DIR" -c user.name=lab -c user.email=lab@example.com add -A
git -C "$CONFIG_REPO_DIR" -c user.name=lab -c user.email=lab@example.com commit -qm "config"
chmod -R a+rX "$CONFIG_REPO_DIR"
trap 'docker compose -f "$here/compose.yaml" down -v >/dev/null 2>&1; rm -rf "$CONFIG_REPO_DIR"' EXIT
docker compose -f "$here/compose.yaml" up -d
for _ in $(seq 60); do curl -sf localhost:8888/orders/prod >/tmp/pcd-scc.json && break; sleep 2; done
python3 - <<'P'
import json
src = json.load(open("/tmp/pcd-scc.json"))["propertySources"]
flat = {}
for s in reversed(src): flat.update(s["source"])
assert flat["orders.max-items"] == 100 and flat["orders.currency"] == "EUR", flat
print("OK: prod overrides max-items, inherits currency")
P
