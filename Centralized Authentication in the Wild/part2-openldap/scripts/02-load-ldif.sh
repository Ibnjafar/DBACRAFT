#!/usr/bin/env bash
# Series : Centralized DB Authentication in the Wild
# Part   : 2 - Building an Enterprise LDAP Directory with OpenLDAP
# Script : 02-load-ldif.sh
# Purpose: Load all LDIF files into the OpenLDAP directory in sequence
# Run on : iam.dbacraft.com
# Usage  : ./02-load-ldif.sh
#
# You will be prompted for the LDAP admin password once per ldapadd call.
# Set LDAP_ADMIN_PASSWORD as an environment variable to avoid repeated prompts:
#   export LDAP_ADMIN_PASSWORD="your_password"
#   ./02-load-ldif.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LDIF_DIR="${SCRIPT_DIR}/../ldif"

LDAP_HOST="localhost"
LDAP_PORT="389"
BIND_DN="cn=admin,dc=dbacraft,dc=com"

# Use environment variable if set, otherwise prompt once and reuse
if [[ -z "${LDAP_ADMIN_PASSWORD:-}" ]]; then
  read -rsp "Enter LDAP admin password: " LDAP_ADMIN_PASSWORD
  echo ""
fi

load_ldif() {
  local file="$1"
  local label="$2"
  echo "==> Loading: ${label}"
  ldapadd -x \
    -H "ldap://${LDAP_HOST}:${LDAP_PORT}" \
    -D "${BIND_DN}" \
    -w "${LDAP_ADMIN_PASSWORD}" \
    -f "${file}" && echo "    OK" || echo "    WARN: some entries may already exist"
}

load_ldif "${LDIF_DIR}/01-ou.ldif"              "Organizational units"
load_ldif "${LDIF_DIR}/02-users-dba.ldif"       "DBA users"
load_ldif "${LDIF_DIR}/03-users-sysadmin.ldif"  "System administrator users"
load_ldif "${LDIF_DIR}/04-users-dev.ldif"       "Developer users"
load_ldif "${LDIF_DIR}/05-users-bi.ldif"        "BI users"
load_ldif "${LDIF_DIR}/06-service-accounts.ldif" "Service accounts"
load_ldif "${LDIF_DIR}/07-bind-account.ldif"    "LDAP bind service account"
load_ldif "${LDIF_DIR}/08-groups.ldif"          "Authorization groups"

echo ""
echo "==> All LDIF files loaded."
echo "    Next step: run 03-verify.sh to confirm the directory contents"
