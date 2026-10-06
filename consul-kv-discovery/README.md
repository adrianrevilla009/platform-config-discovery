# consul-kv-discovery

Consul in dev mode (`compose.yaml`) and a `run.sh` that stores a key and registers a service through the HTTP API.

## Goal

Use Consul for key/value config and for service discovery.

## Run it

```
./run.sh
```

Expected: `OK: KV read and service discovered at 10.0.0.5 8080`. The script starts `hashicorp/consul:1.19.2`, waits for a leader and tears the container down on exit. Needs Docker and curl.

Not run end to end: the script has not been executed here, so the expected line comes from the code, not from a captured run.

## What it proves

- `orders/currency` is written with `PUT /v1/kv/...` and read back as `EUR`.
- A service `orders-1` registered at `10.0.0.5:8080` appears in `/v1/catalog/service/orders`.
- The script asserts both and fails if the catalog entry or port differs.

## Trade-offs

- Dev mode is in-memory, single node and without ACLs; real use needs a server quorum and an agent per host.
- The registration has no health check, so Consul would keep returning a dead instance.

## When not to use it

- When Kubernetes DNS and ConfigMaps already cover discovery and config.
- When you only need a strongly consistent key store; etcd is lighter.
