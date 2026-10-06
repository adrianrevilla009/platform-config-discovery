#!/usr/bin/env bash
# AWS AppConfig sketch. Targets LocalStack only (AppConfig there needs a paid tier, so this is not run in CI).
# Never point it at a real account: the endpoint and dummy credentials below are hard-wired on purpose.
set -euo pipefail
export AWS_ACCESS_KEY_ID=test AWS_SECRET_ACCESS_KEY=test AWS_DEFAULT_REGION=eu-west-1
A="aws --endpoint-url http://localhost:4566"
app=$($A appconfig create-application --name orders --query Id --output text)
env=$($A appconfig create-environment --application-id "$app" --name dev --query Id --output text)
prof=$($A appconfig create-configuration-profile --application-id "$app" --name flags \
  --location-uri hosted --query Id --output text)
$A appconfig create-hosted-configuration-version --application-id "$app" --configuration-profile-id "$prof" \
  --cli-binary-format raw-in-base64-out --content-type application/json --content '{"maxItems":10}' /tmp/pcd-appconfig-version.json >/dev/null
echo "created app=$app env=$env profile=$prof; deploy with: $A appconfig start-deployment ..."
