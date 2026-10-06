# spring-cloud-config-git

A Spring Cloud Config server container (`compose.yaml`) serving the files in `config-repo/` through a throwaway git repo built by `run.sh`.

## Goal

Serve versioned configuration from a git backend and show how a profile file overlays the default one.

## Run it

```
./run.sh
```

Expected: `OK: prod overrides max-items, inherits currency`. The script copies `config-repo/*.yml` into a temp directory, runs `git init` and a commit there, starts `hyness/spring-cloud-config-server:4.1.3`, queries `localhost:8888/orders/prod` and removes everything on exit. Needs Docker, curl, git and python3.

Not run end to end: the script has not been executed here, so the expected line comes from the code.

## What it proves

- `orders.yml` sets `max-items: 10` and `currency: EUR`; `orders-prod.yml` sets `max-items: 100`.
- The `/orders/prod` response lists both property sources; the script flattens them and asserts `max-items` is 100 and `currency` is `EUR`.
- Config is just files in git, so history gives audit and rollback.

## Trade-offs

- Clients pull config on refresh; nothing is pushed unless you add a bus.
- Secrets need encryption or Vault; they should not sit in the git files.
- A ready-made server image is used instead of building a Spring Boot app, which keeps the folder small.

## When not to use it

- When you need dynamic push or per-request targeting.
- When your clients are not Spring applications and a plain key/value store would do.
