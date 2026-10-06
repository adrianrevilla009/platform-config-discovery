# unleash-flagd

An OpenFeature flagd container (`compose.yaml`) loading `flags.json`, and a `run.sh` that evaluates one targeted flag over HTTP.

## Goal

Evaluate a feature flag with a targeting rule. flagd was chosen over Unleash because it needs one container and no database.

## Run it

```
./run.sh
```

Expected: `OK: @example.com gets express-checkout, others do not`. The script starts `ghcr.io/open-feature/flagd:v0.11.5`, calls `ResolveBoolean` for two emails and tears down on exit. Needs Docker, curl and python3.

Not run end to end: the script has not been executed here, so the expected line comes from the code.

## What it proves

- Flags are plain JSON: `flags.json` defines `express-checkout` with variants `on` and `off`, default `off`.
- A targeting rule using `ends_with` on the `email` context value returns `on` only for `@example.com` addresses.
- The script checks that `a@example.com` resolves to true and `a@other.org` does not.

## Trade-offs

- There is no UI, audit trail or per-environment management as in Unleash; you distribute the file yourself.
- The lab calls the HTTP endpoint directly rather than an OpenFeature SDK.

## When not to use it

- When non-engineers need to toggle flags.
- When you need rollout dashboards or usage metrics.
