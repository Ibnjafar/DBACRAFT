#!/usr/bin/env bash
# Series : Centralized DB Authentication in the Wild
# Part   : 2 - Building an Enterprise LDAP Directory with OpenLDAP
# Script : 03-verify.sh
# Purpose: Verify the directory structure, user counts and group membership
# Run on : iam.dbacraft.com
# Usage  : ./03-verify.sh

set -euo pipefail

LDAP_HOST="localhost"
LDAP_PORT="389"
BIND_DN="cn=admin,dc=dbacraft,dc=com"
BASE_DN="dc=dbacraft,dc=com"

if [[ -z "${LDAP_ADMIN_PASSWORD:-}" ]]; then
  read -rsp "Enter LDAP admin password: " LDAP_ADMIN_PASSWORD
  echo ""
fi

LDAP_ARGS="-x -LLL -H ldap://${LDAP_HOST}:${LDAP_PORT} -D ${BIND_DN} -w ${LDAP_ADMIN_PASSWORD}"

echo "============================================================"
echo " 1. Full directory tree (DN only)"
echo "============================================================"
ldapsearch ${LDAP_ARGS} -b "${BASE_DN}" dn

echo ""
echo "============================================================"
echo " 2. Organizational units"
echo "============================================================"
ldapsearch ${LDAP_ARGS} -b "${BASE_DN}" "(objectClass=organizationalUnit)" dn

echo ""
echo "============================================================"
echo " 3. User count under ou=people"
echo "============================================================"
COUNT=$(ldapsearch ${LDAP_ARGS} -b "ou=people,${BASE_DN}" "(objectClass=inetOrgPerson)" dn | grep -c "^dn:" || true)
echo "    Total entries: ${COUNT}"

echo ""
echo "============================================================"
echo " 4. Groups and their members"
echo "============================================================"
for group in db-admins server-admins developers bi-users service-accounts; do
  echo ""
  echo "  Group: cn=${group}"
  ldapsearch ${LDAP_ARGS} \
    -b "cn=${group},ou=groups,${BASE_DN}" \
    "(objectClass=groupOfNames)" member \
    | grep "^member:" | sed 's/member: /    - /'
done

echo ""
echo "============================================================"
echo " 5. Bind account"
echo "============================================================"
ldapsearch ${LDAP_ARGS} \
  -b "ou=people,${BASE_DN}" \
  "(uid=svc_ldap_bind_ro)" dn uid mail

echo ""
echo "============================================================"
echo " Verification complete"
echo "============================================================"
