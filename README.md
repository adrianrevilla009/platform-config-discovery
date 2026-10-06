# platform-config-discovery

Six small labs showing how platform teams distribute configuration, discover services, toggle feature flags and describe ownership, all around the same tiny Orders domain.

## What is inside

| Folder | What it shows | Run |
| --- | --- | --- |
| [`spring-cloud-config-git`](./spring-cloud-config-git) | Spring Cloud Config server reading a git repo, with a `prod` profile overlay | `./run.sh` |
| [`consul-kv-discovery`](./consul-kv-discovery) | Consul key/value storage and service registration through the HTTP API | `./run.sh` |
| [`etcd`](./etcd) | etcd put/get, watch and a lease that expires a key | `./run.sh` |
| [`aws-appconfig`](./aws-appconfig) | AWS AppConfig application, environment, profile and hosted version against LocalStack | `docker compose up -d` then `./run.sh` |
| [`unleash-flagd`](./unleash-flagd) | A targeted feature flag evaluated by OpenFeature flagd | `./run.sh` |
| [`backstage-catalog`](./backstage-catalog) | Backstage catalog descriptors for Orders, validated offline | `python3 validate.py` |

## Prerequisites

- Docker with the Compose plugin (all folders except `backstage-catalog`)
- curl, git and python3 (3.9 or newer)
- PyYAML for `backstage-catalog`
- aws CLI v2 for `aws-appconfig`

## How to read it

Start with `backstage-catalog`, which runs without Docker, then read `spring-cloud-config-git` and `consul-kv-discovery`. Each folder is standalone and has its own README. Only `backstage-catalog` has been run end to end; the Docker-based scripts are written but have not been executed, as each folder README states.
