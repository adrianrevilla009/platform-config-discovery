# aws-appconfig

LocalStack in `compose.yaml` and a `run.sh` that creates an AWS AppConfig application, environment, hosted profile and configuration version.

## Goal

Show the AppConfig resource model and the CLI calls that publish a hosted configuration version, without touching a real AWS account.

## Run it

```
docker compose up -d
./run.sh
docker compose down -v
```

Expected: a line like `created app=<id> env=<id> profile=<id>; deploy with: ... appconfig start-deployment ...`. Requires the aws CLI.

Not run end to end: the script has not been executed here, and AppConfig in LocalStack may need a paid tier.

## What it proves

- `run.sh` creates an application `orders`, an environment `dev` and a hosted profile `flags`, then uploads `{"maxItems":10}` as a JSON version.
- The endpoint is hard-wired to `http://localhost:4566` with dummy credentials, so it cannot reach a real account.
- It stops before `start-deployment`, which is where AppConfig's gradual rollout would begin.

## Trade-offs

- AppConfig offers validators, gradual deployment and rollback, but is AWS-only and clients poll the data API.
- Cost: nothing here. A real account bills per configuration request.
- Destroy: `docker compose down -v` removes the emulator; on a real account you would delete the application, environment and profile yourself.

## When not to use it

- Outside AWS, where a neutral store such as Consul or etcd fits better.
- When config is static and ships with the deployment.
