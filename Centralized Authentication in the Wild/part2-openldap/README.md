# Part 2: Building an Enterprise LDAP Directory with OpenLDAP

**Blog post:** [dbacraft.com](https://dbacraft.com)
**Series:** Centralized DB Authentication in the Wild | Part 2 of 9
**Host:** iam.dbacraft.com

## What this builds

- OpenLDAP 1.5.0 running in Docker on port 389
- phpLDAPadmin 0.9.0 running in Docker on port 8081
- Directory structure: `dc=dbacraft,dc=com`
  - `ou=people` - 31 user and service accounts
  - `ou=groups` - 5 authorization groups

## Directory layout

```
part2-openldap/
├── ldap/
│   └── docker-compose.yml       # OpenLDAP + phpLDAPadmin
├── ldif/
│   ├── 01-ou.ldif               # Organizational units
│   ├── 02-users-dba.ldif        # DBA users
│   ├── 03-users-sysadmin.ldif   # System administrator users
│   ├── 04-users-dev.ldif        # Developer users
│   ├── 05-users-bi.ldif         # BI users
│   ├── 06-service-accounts.ldif # Service accounts
│   ├── 07-bind-account.ldif     # LDAP bind service account
│   └── 08-groups.ldif           # Authorization groups
└── scripts/
    ├── 01-deploy.sh             # Start containers
    ├── 02-load-ldif.sh          # Load all LDIF files
    └── 03-verify.sh             # Verify directory contents
```

## Usage

### Step 1: Start the containers

```bash
cd part2-openldap/scripts
chmod +x *.sh
./01-deploy.sh
```

### Step 2: Load the directory

```bash
./02-load-ldif.sh
```

### Step 3: Verify

```bash
./03-verify.sh
```

## Credentials

All passwords in this lab use a placeholder value.
Replace `CHANGE_ME` with your actual passwords before deploying.

| Account | DN | Purpose |
|---------|-----|---------|
| LDAP admin | `cn=admin,dc=dbacraft,dc=com` | Directory administrator |
| Bind account | `uid=svc_ldap_bind_ro,ou=people,dc=dbacraft,dc=com` | Read-only search account used by database platforms |

## Notes

- TLS is disabled in this lab. Use LDAPS port 636 or StartTLS in production.
- The bind account `svc_ldap_bind_ro` is used in Parts 3 onward when connecting database platforms to this directory.
