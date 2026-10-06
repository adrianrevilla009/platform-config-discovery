# etcd

A single etcd node (`compose.yaml`) and a `run.sh` that exercises put/get, watch and leases with `etcdctl`.

## Goal

Show etcd's three core primitives: key/value storage, watches and leases.

## Run it

```
./run.sh
```

Expected: `OK: get, watch saw USD, leased key expired`. The script starts `quay.io/coreos/etcd:v3.5.16`, runs `etcdctl` through `docker compose exec`, and tears down on exit. Needs Docker.

Not run end to end: the script has not been executed here, so the expected line comes from the code.

## What it proves

- `/orders/currency` is stored as `EUR` and read back.
- A watch started on the key records the later update to `USD` in a temp file.
- A key attached to a 2 second lease is gone after 4 seconds, the basis of ephemeral registration and leader election.

## Trade-offs

- It is strongly consistent but meant for small values; keep them tiny.
- High availability needs a 3 or 5 node cluster; this lab runs one node.
- The watch check relies on `sleep` timing, so it can be flaky on a slow machine.

## When not to use it

- As a general database or blob store.
- For plain application feature flags, where a flag service is simpler.
