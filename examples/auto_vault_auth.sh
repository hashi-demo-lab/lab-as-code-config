#!/bin/zsh
# Automated Vault Auth Demo with Enhanced Debug Logging and Colors
#
# This script:
# - Generates tokens for various Kubernetes service accounts.
# - Randomly selects one for JWT authentication and a secret key to retrieve.
# - Logs detailed information before calling Vault.
# - If the retrieved secret is empty, it logs the full KV JSON response.
# - For the "environment" key, it logs a special note.
# - Sleeps for a random duration between 0.5 and 4 seconds.
#
# ITERATIONS can be configured via the first command-line argument (default 200).
#
# Pre-requisites:
# - kubectl, vault, and jq must be installed.
# - Vault policy "access-all" must allow reading from the KV path:
#   demo-kv/data/envs/development/secrets

# -------------------------------
# ANSI Color Codes
# -------------------------------
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
RESET='\033[0m'

# -------------------------------
# Configurable Iterations
# -------------------------------
ITERATIONS=${1:-200}  # Use command-line argument if provided, default to 200

# -------------------------------
# Counters for success and failure
# -------------------------------
success_count=0
fail_count=0

# -------------------------------
# Pre-check: Ensure required commands are installed.
# -------------------------------
for cmd in kubectl vault jq; do
  if ! command -v $cmd >/dev/null 2>&1; then
    echo -e "${RED}Error: $cmd is not installed. Please install $cmd.${RESET}"
    exit 1
  fi
done

echo -e "${CYAN}Starting randomized Vault auth demo with enhanced debug logging and colors...${RESET}"
echo -e "${CYAN}Total iterations: $ITERATIONS${RESET}"
echo ""

# -------------------------------
# 1. Generate Tokens with kubectl
# -------------------------------
echo -e "${CYAN}Generating tokens via kubectl...${RESET}"
app1_service_a_token=$(kubectl create token app1-service-a --namespace app1)
app1_service_b_token=$(kubectl create token app1-service-b --namespace app1)
app2_service_a_token=$(kubectl create token app2-service-a --namespace app2)
app2_service_b_token=$(kubectl create token app2-service-b --namespace app2)
app3_service_frontend_token=$(kubectl create token app3-service --namespace app3-frontend)
app3_service_backend_token=$(kubectl create token app3-service --namespace app3-backend)
app4_web_service_a_token=$(kubectl create token app4-web-service-a --namespace app4-web)
app4_web_service_b_token=$(kubectl create token app4-web-service-b --namespace app4-web)
app4_api_service_a_token=$(kubectl create token app4-api-service-a --namespace app4-api)
app4_api_service_b_token=$(kubectl create token app4-api-service-b --namespace app4-api)
app4_api_service_c_token=$(kubectl create token app4-api-service-c --namespace app4-api)
app4_db_service_a_token=$(kubectl create token app4-db-service-a --namespace app4-db)
app4_db_service_b_token=$(kubectl create token app4-db-service-b --namespace app4-db)
echo -e "${CYAN}Token generation complete.${RESET}"
echo ""

# -------------------------------
# 2. Build an array of login pairs (role:token)
# -------------------------------
logins=(
  "app1:$app1_service_a_token"
  "app1:$app1_service_b_token"
  "app2:$app2_service_a_token"
  "app2:$app2_service_b_token"
  "app3:$app3_service_frontend_token"
  "app3:$app3_service_backend_token"
  "app4-web:$app4_web_service_a_token"
  "app4-web:$app4_web_service_b_token"
  "app4-api:$app4_api_service_a_token"
  "app4-api:$app4_api_service_b_token"
  "app4-api:$app4_api_service_c_token"
  "app4-db:$app4_db_service_a_token"
  "app4-db:$app4_db_service_b_token"
)

# Filter out invalid login pairs.
valid_logins=()
for pair in "${logins[@]}"; do
  role=${pair%%:*}
  token=${pair#*:}
  if [[ -n "$role" && -n "$token" ]]; then
    valid_logins+=("$pair")
  else
    echo -e "${YELLOW}WARNING: Skipping invalid login pair for role '$role'. Token value: '$token'${RESET}"
  fi
done

if [[ ${#valid_logins[@]} -eq 0 ]]; then
  echo -e "${RED}ERROR: No valid login pairs available. Exiting.${RESET}"
  exit 1
fi

echo -e "${CYAN}Valid login pairs available: ${#valid_logins[@]}${RESET}"
echo ""

# -------------------------------
# 3. Define the secret keys array
# -------------------------------
secret_keys=("api_key" "db_password" "db_username")
echo -e "${CYAN}Secret keys available: ${secret_keys[*]}${RESET}"
echo ""

# -------------------------------
# 4. Function to log in to Vault using a JWT and retrieve one secret field.
# -------------------------------
login_and_get_secret() {
  local role=$1
  local jwt_token=$2
  local secret_field=$3

  echo -e "${YELLOW}----------------------------------------${RESET}"
  echo -e "${YELLOW}Role: ${CYAN}$role${RESET}"
  echo -e "${YELLOW}Selected Secret Key: ${CYAN}$secret_field${RESET}"
  echo -e "${YELLOW}JWT token (first 10 chars): ${CYAN}${jwt_token:0:10}...[truncated]${RESET}"
  
  echo -e "${YELLOW}Attempting JWT login...${RESET}"
  # Perform Vault login using JWT and capture the JSON output.
  response=$(vault write -format=json auth/jwt/login role="$role" jwt="$jwt_token")
  vault_token=$(echo "$response" | jq -r '.auth.client_token')

  if [[ "$vault_token" == "null" || -z "$vault_token" ]]; then
    echo -e "${RED}ERROR: Vault token not obtained for role '$role'.${RESET}"
    echo -e "${RED}Raw response from Vault:${RESET}"
    echo "$response" | jq .
    echo -e "${RED}Skipping this iteration.${RESET}"
    echo -e "${YELLOW}----------------------------------------${RESET}"
    return 1
  fi

  echo -e "${GREEN}Obtained Vault token (first 10 chars): ${vault_token:0:10}...[truncated]${RESET}"
  # Log in to Vault with the obtained token.
  vault login "$vault_token" >/dev/null

  # If the selected key is "environment", log a special note.
  if [[ "$secret_field" == "environment" ]]; then
    echo -e "${CYAN}Note: 'environment' key selected. Expected value is 'development'.${RESET}"
  fi

  # Initialize retry count and max attempts.
  local attempt=1
  local max_attempts=3
  local secret_value=""

  # Retry loop for secret retrieval.
  while [[ $attempt -le $max_attempts ]]; do
    secret_value=$(vault kv get -format=json -mount="demo-kv" "envs/development/secrets" \
      | jq -r --arg key "$secret_field" '.data.data[$key]')
    
    if [[ "$secret_value" != "null" && -n "$secret_value" ]]; then
      echo -e "${GREEN}Retrieved secret field '$secret_field': $secret_value (attempt $attempt)${RESET}"
      break
    else
      echo -e "${RED}WARNING: Attempt $attempt: Secret field '$secret_field' returned empty.${RESET}"
      # Log the full KV response for troubleshooting.
      full_kv=$(vault kv get -format=json -mount="demo-kv" "envs/development/secrets" 2>/dev/null)
      echo -e "${YELLOW}Full KV JSON response:${RESET}"
      echo "$full_kv" | jq .
    fi

    (( attempt++ ))
    sleep 0.5
  done

  if [[ "$secret_value" == "null" || -z "$secret_value" ]]; then
    echo -e "${RED}ERROR: Secret field '$secret_field' not found after $max_attempts attempts.${RESET}"
    echo -e "${YELLOW}----------------------------------------${RESET}"
    return 1
  fi

  echo -e "${YELLOW}----------------------------------------${RESET}"
  echo ""
  return 0
}

# -------------------------------
# 5. Cycle over the specified number of iterations
# -------------------------------
for (( i=1; i<=ITERATIONS; i++ )); do
  echo -e "${CYAN}Iteration $i of $ITERATIONS${RESET}"

  # Randomly select a login pair from valid_logins array.
  login_count=${#valid_logins[@]}
  rand_index=$(( RANDOM % login_count ))
  login_pair=${valid_logins[$rand_index]}

  # Split login_pair into role and jwt_token.
  role=${login_pair%%:*}
  jwt_token=${login_pair#*:}

  # Log the chosen login pair details.
  echo -e "${CYAN}Selected Login Pair: Role='${role}', JWT token (first 10 chars)='${jwt_token:0:10}...'{RESET}"

  # Validate role and token.
  if [[ -z "$role" || -z "$jwt_token" ]]; then
    echo -e "${RED}ERROR: Invalid login pair detected (role: '$role', token: '$jwt_token'). Skipping iteration.${RESET}"
    (( fail_count++ ))
    continue
  fi

  # Randomly select a secret key from secret_keys array.
  key_count=${#secret_keys[@]}
  rand_key_index=$(( RANDOM % key_count ))
  secret_field=${secret_keys[$rand_key_index]}

  if [[ -z "$secret_field" ]]; then
    echo -e "${RED}ERROR: Secret field is empty. Skipping iteration.${RESET}"
    (( fail_count++ ))
    continue
  fi

  echo -e "${CYAN}Selected secret key: '$secret_field' from available: ${secret_keys[*]}${RESET}"

  # Call the function to log in and retrieve the secret.
  login_and_get_secret "$role" "$jwt_token" "$secret_field"
  ret=$?
  if [[ $ret -eq 0 ]]; then
    (( success_count++ ))
  else
    (( fail_count++ ))
  fi

  # Random throttling: Sleep for a random duration between 0.5 and 4 seconds.
  sleep_time=$(echo "scale=2; 0.5 + ($RANDOM/32767)*3.5" | bc -l)
  echo -e "${CYAN}Sleeping for $sleep_time seconds...${RESET}"
  sleep "$sleep_time"
  echo ""
done

echo -e "${CYAN}All $ITERATIONS iterations completed.${RESET}"
echo -e "${GREEN}Successful iterations: $success_count${RESET}"
echo -e "${RED}Failed iterations: $fail_count${RESET}"
echo -e "${CYAN}Verify client count and audit logs in Vault.${RESET}"
