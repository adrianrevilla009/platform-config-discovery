# backstage-catalog

Backstage catalog descriptors for the Orders system (`catalog-info.yaml`) and a small offline validator (`validate.py`).

## Goal

Describe a System, a Component and an API in Backstage descriptors and check them without running a Backstage instance.

## Run it

```
pip install pyyaml
python3 validate.py
```

Expected: `OK: 3 entities valid, references resolve`, exit code 0. On a problem it prints one line per error and exits 1.

## What it proves

- `catalog-info.yaml` holds three entities: System `orders-platform`, Component `orders-service` and API `orders-api`.
- `validate.py` requires the right `spec` fields per kind (for example `definition` for an API) and a `backstage.io/` apiVersion.
- References resolve: the component's `system` and `providesApis` point at entities defined in the same file.

## Trade-offs

- Only a subset of the Backstage schema is checked; names, owner entity refs and annotations are not validated.
- Only the `System`, `Component` and `API` kinds are supported; any other kind is reported as unsupported.
- The API definition is an empty OpenAPI stub, which keeps the file short.

## When not to use it

- If you run a real Backstage portal, its own catalog processing is the authority; use this only as a quick pre-commit check.
- If nobody owns services by team, the descriptors add metadata no one reads.
