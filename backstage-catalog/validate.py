#!/usr/bin/env python3
"""Validates Backstage descriptors: required fields, kind-specific spec, and resolvable references."""
import pathlib, sys, yaml

KINDS = {"Component": ["type", "lifecycle", "owner"], "API": ["type", "lifecycle", "owner", "definition"],
         "System": ["owner"]}
docs = [d for d in yaml.safe_load_all((pathlib.Path(__file__).parent / "catalog-info.yaml").read_text()) if d]
names = {(d["kind"], d["metadata"]["name"]) for d in docs}
errs = []
for d in docs:
    who = f'{d.get("kind")}/{d.get("metadata", {}).get("name")}'
    if not str(d.get("apiVersion", "")).startswith("backstage.io/"): errs.append(f"{who}: bad apiVersion")
    if d.get("kind") not in KINDS: errs.append(f"{who}: unsupported kind"); continue
    errs += [f"{who}: spec.{k} missing" for k in KINDS[d["kind"]] if k not in d.get("spec", {})]
    s = d.get("spec", {})
    if "system" in s and ("System", s["system"]) not in names: errs.append(f"{who}: unknown system {s['system']}")
    for a in s.get("providesApis", []):
        if ("API", a) not in names: errs.append(f"{who}: unknown API {a}")
print("\n".join(errs) or f"OK: {len(docs)} entities valid, references resolve")
sys.exit(1 if errs else 0)
