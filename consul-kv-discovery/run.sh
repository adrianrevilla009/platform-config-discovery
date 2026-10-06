#!/usr/bin/env bash
# Consul KV + service registration/discovery through the HTTP API.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
trap 'docker compose -f "$here/compose.yaml" down -v >/dev/null 2>&1' EXIT
docker compose -f "$here/compose.yaml" up -d
for _ in $(seq 30); do curl -sf localhost:8500/v1/status/leader >/dev/null && break; sleep 1; done
C=localhost:8500/v1
curl -sf -X PUT -d 'EUR' $C/kv/orders/currency >/dev/null
[ "$(curl -sf "$C/kv/orders/currency?raw")" = "EUR" ]
curl -sf -X PUT -d '{"Name":"orders","ID":"orders-1","Address":"10.0.0.5","Port":8080}' $C/agent/service/register
curl -sf "$C/catalog/service/orders" | python3 -c '
import json,sys
s = json.load(sys.stdin)
assert len(s) == 1 and s[0]["ServicePort"] == 8080, s
print("OK: KV read and service discovered at", s[0]["ServiceAddress"], s[0]["ServicePort"])'
