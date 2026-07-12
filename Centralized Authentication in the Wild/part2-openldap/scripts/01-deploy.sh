#!/usr/bin/env bash
# Series : Centralized DB Authentication in the Wild
# Part   : 2 - Building an Enterprise LDAP Directory with OpenLDAP
# Script : 01-deploy.sh
# Purpose: Start OpenLDAP and phpLDAPadmin containers
# Run on : iam.dbacraft.com
# Usage  : ./01-deploy.sh

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
COMPOSE_FILE="${SCRIPT_DIR}/../ldap/docker-compose.yml"

echo "==> Starting OpenLDAP and phpLDAPadmin..."
docker compose -f "${COMPOSE_FILE}" up -d

echo ""
echo "==> Waiting for OpenLDAP to become ready..."
sleep 5

echo ""
echo "==> Container status:"
docker ps --filter "name=dbacraft_openldap_389" \
          --filter "name=dbacraft_phpldapadmin_8081" \
          --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"

echo ""
echo "==> OpenLDAP is listening on port 389"
echo "==> phpLDAPadmin is accessible at http://$(hostname):8081"
echo ""
echo "    Next step: run 02-load-ldif.sh to populate the directory"
