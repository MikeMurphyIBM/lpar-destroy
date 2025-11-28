#!/bin/sh
set -e

# 1. Define variables
# WORKSPACE_ID should be supplied as an environment variable by the job runner
# Note: The WORKSPACE_ID value is taken from your previous log output.
WORKSPACE_ID="us-south.workspace.clone-test.8c45db95"
# APIKEY is populated via the Code Engine secret binding (e.g., using --env-from-secret)
APIKEY="$apikey"

# 2. Acquire IAM Access Token using the provided API Key
# This section handles authentication for IBM Cloud services.
TOKEN=$(curl -s -X POST \
  "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=$APIKEY" \
  -u bx:bx \
  | jq -r .access_token)

echo "IAM token acquired."

# 3. Trigger Schematics DESTROY action
# Change the endpoint from /apply to /destroy
echo "Triggering Schematics DESTROY on workspace $WORKSPACE_ID ... **Caution: This action cannot be reversed.**"

# Use -f flag to fail immediately if the server returns an HTTP error (4xx/5xx)
curl -s -f -X PUT \
  "https://private-us-south.schematics.cloud.ibm.com/v1/workspaces/${WORKSPACE_ID}/destroy" \
  -H "Authorization: Bearer $TOKEN" \
  -H "Content-Type: application/json" \
  -d '{}' \
  -o /tmp/destroy_response.json

echo "Schematics DESTROY triggered. Response saved."

# Output the API response for debugging/confirmation
cat /tmp/destroy_response.json
