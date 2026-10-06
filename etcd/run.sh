#!/usr/bin/env bash
# etcd: put/get, a watch that sees the change, and a lease that expires a key.
set -euo pipefail
here="$(cd "$(dirname "$0")" && pwd)"
trap 'docker compose -f "$here/compose.yaml" down -v >/dev/null 2>&1' EXIT
docker compose -f "$here/compose.yaml" up -d
E="docker compose -f $here/compose.yaml exec -T etcd etcdctl"
for _ in $(seq 30); do $E endpoint health >/dev/null 2>&1 && break; sleep 1; done
$E put /orders/currency EUR >/dev/null
[ "$($E get /orders/currency --print-value-only)" = "EUR" ]
( timeout 8 $E watch /orders/currency > /tmp/pcd-etcd-watch.txt || true ) &
sleep 2; $E put /orders/currency USD >/dev/null; wait
grep -q USD /tmp/pcd-etcd-watch.txt
lease=$($E lease grant 2 | awk '{print $2}')
$E put --lease="$lease" /orders/leader node-1 >/dev/null
sleep 4
[ -z "$($E get /orders/leader --print-value-only)" ]
echo "OK: get, watch saw USD, leased key expired"
