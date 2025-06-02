#!/usr/bin/env bash
# jwt-demo.sh  –  coloured, talk-track friendly
# ./jwt-demo.sh        ↩ pauses so you can explain
# ./jwt-demo.sh --auto ↩ runs straight through

# ---------- colour helpers ----------
BOLD=$(tput bold) ; RESET=$(tput sgr0)
GRN=$(tput setaf 2) ; BLU=$(tput setaf 4) ; YLW=$(tput setaf 3) ; CYN=$(tput setaf 6)

pause() { [[ "$1" == "--auto" ]] && return; read -p "${YLW}↩  continue…${RESET}" _; }
clear_token() { unset VAULT_TOKEN && rm -f ~/.vault-token; }

do_sa() {
  local role=$1 sa=$2 tfile=$3 auto=$4
  echo -e "${CYN}${BOLD}[${role}]  SA=${sa}${RESET}"

  # STEP 1: issue token (no client count bump)
  clear_token
  echo -e "${GRN}» vault write auth/jwt/login role=${role} jwt=<token>${RESET}"
  login_json=$(vault write -format=json auth/jwt/login role="$role" jwt="$(<"$tfile")")
  client_token=$(jq -r '.auth.client_token' <<<"$login_json")
  echo -e "  ${YLW}issued:${RESET} ${client_token:0:12}…  (counter UNCHANGED)"
  pause "$auto"

  # STEP 2: use the token (client count increments)
  echo -e "${BLU}» vault login ${client_token:0:12}…${RESET}"
  vault login -no-print "$client_token"    # succeeds if token can self-lookup
  echo "  token used – counter should now increment"
  pause "$auto"
  echo
}

# ---------- app sections ----------
section() { echo -e "\n${BOLD}=== $1 =====================================================${RESET}\n"; }

AUTO="$1"   # pass --auto to skip pauses

section "app1  (namespace: app1, role: app1)"
kubectl create token app1-service-a -n app1 > app1-a.jwt
kubectl create token app1-service-b -n app1 > app1-b.jwt
do_sa app1 app1-service-a app1-a.jwt "$AUTO"
do_sa app1 app1-service-b app1-b.jwt "$AUTO"

section "app2  (namespace: app2, role: app2)"
kubectl create token app2-service-a -n app2 > app2-a.jwt
kubectl create token app2-service-b -n app2 > app2-b.jwt
do_sa app2 app2-service-a app2-a.jwt "$AUTO"
do_sa app2 app2-service-b app2-b.jwt "$AUTO"

section "app3  (front-end & back-end share role: app3)"
kubectl create token app3-service -n app3-frontend > app3-front.jwt
kubectl create token app3-service -n app3-backend  > app3-back.jwt
do_sa app3 app3-frontend app3-front.jwt "$AUTO"
do_sa app3 app3-backend  app3-back.jwt  "$AUTO"

section "app4-web  (namespace: app4-web, role: app4-web)"
for sa in a b; do
  kubectl create token "app4-web-service-$sa" -n app4-web > "app4-web-$sa.jwt"
  do_sa app4-web "app4-web-service-$sa" "app4-web-$sa.jwt" "$AUTO"
done

section "app4-api  (namespace: app4-api, role: app4-api)"
for sa in a b c; do
  kubectl create token "app4-api-service-$sa" -n app4-api > "app4-api-$sa.jwt"
  do_sa app4-api "app4-api-service-$sa" "app4-api-$sa.jwt" "$AUTO"
done

section "app4-db  (namespace: app4-db, role: app4-db)"
for sa in a b; do
  kubectl create token "app4-db-service-$sa" -n app4-db > "app4-db-$sa.jwt"
  do_sa app4-db "app4-db-service-$sa" "app4-db-$sa.jwt" "$AUTO"
done