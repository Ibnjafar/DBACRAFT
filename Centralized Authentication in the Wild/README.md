# Centralized DB Authentication in the Wild

Source files for the DBA Craft blog series.

**Blog:** [dbacraft.com](https://dbacraft.com)

## Series structure

| Part | Title | Folder |
|------|-------|--------|
| Part 1 | Why Local Database Authentication Creates Operational Chaos 
| Part 2 | Building an Enterprise LDAP Directory with OpenLDAP | `part2-openldap/` |
| Part 3 | Integrating PostgreSQL with a Centralized LDAP Directory | coming soon |
| Part 4 | MongoDB Enterprise LDAP Integration | coming soon |
| Part 5 | MySQL Enterprise LDAP Integration | coming soon |
| Part 6 | MariaDB LDAP Authentication using PAM and POSIX Groups | coming soon |
| Part 7 | Why LDAP Is Not Enough - Introducing Kerberos | coming soon |
| Part 8 | Certificate-Based Authentication Across PostgreSQL, MySQL, MariaDB and MongoDB | coming soon |
| Part 9 | Production Best Practices and Cross Platform Comparison | coming soon |

## Demo hosts

| Host | Role |
|------|------|
| `iam.dbacraft.com` | Identity server — OpenLDAP, phpLDAPadmin |
| `db1.dbacraft.com` | Database server — PostgreSQL, MongoDB, MySQL, MariaDB |

## License

MIT
