#!/bin/sh
set -e

# 1. Define variables (assuming these are passed as environment variables to the Code Engine Job)
WORKSPACE_ID="us-south.workspace.clone-test.f1da6c21"
APIKEY="$apikey" # Ensure this variable is correctly injected by Code Engine

# 2. Acquire IAM Access Token using the provided API Key
# This section remains the same as it handles authentication for IBM Cloud services.
TOKEN=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY" \
  -u bx:bx \
  | jq -r .access_token)

echo "IAM token acquired."

# 3. Trigger Schematics DESTROY action
# Change the endpoint from /apply to /destroy
echo "Triggering Schematics DESTROY on workspace $WORKSPACE_ID ... **Caution: This action cannot be reversed.**" [5-7]

curl -s -X PUT \
  "https://private-us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/destroy" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}' \
  -o /tmp/destroy_response.json [8, 9]

echo "Schematics DESTROY triggered. Response saved."

cat /tmp/destroy_response.json
