# Azure Naming Conventions

Follows the **Cloud Adoption Framework (CAF)** standard — the industry baseline for enterprise Azure environments.

---

## Pattern

```
<resource-type>-<workload>-<environment>-<region>-<instance>
```

---

## Windows VM Constraint

Windows VM names are capped at **15 characters (NetBIOS limit)**. Design your convention around this so it works universally across both Windows and Linux.

This means dropping the region segment from the VM name itself (it's visible in Portal metadata anyway) and abbreviating aggressively:

```
vm-wapi-prd-001     ← 15 chars, fits Windows limit
```

---

## Resource Type Prefixes

| Resource | Prefix |
|---|---|
| Virtual Machine | `vm` |
| Network Interface | `nic` |
| OS Disk | `osdisk` |
| Data Disk | `datadisk` |
| Public IP | `pip` |
| Network Security Group | `nsg` |
| Virtual Network | `vnet` |
| Subnet | `snet` |
| Key Vault | `kv` |
| Storage Account | `st` |
| Resource Group | `rg` |
| Load Balancer | `lb` |
| Application Gateway | `agw` |

---

## Environment Abbreviations

| Full | Short |
|---|---|
| production | `prd` |
| development | `dev` |
| staging | `stg` |
| test | `tst` |

---

## Region Abbreviations

| Region | Short |
|---|---|
| East US | `eus` |
| East US 2 | `eus2` |
| West US | `wus` |
| West US 2 | `wus2` |
| Central US | `cus` |
| North Central US | `ncus` |
| South Central US | `scus` |
| West Europe | `weu` |
| North Europe | `neu` |

---

## Examples

### VM and Associated Resources

```
vm-wapi-prd-001          ← Virtual Machine
nic-wapi-prd-001         ← NIC
osdisk-wapi-prd-001      ← OS Disk
pip-wapi-prd-001         ← Public IP
nsg-wapi-prd             ← NSG (shared across instances, no number)
```

### Other Resources

```
rg-wapi-prd              ← Resource Group
vnet-prd-eus-001         ← VNet (not scoped to one VM)
snet-web-prd             ← Subnet
kv-wapi-prd-001          ← Key Vault
st-wapiprd001            ← Storage Account (no hyphens allowed, 3-24 chars, lowercase)
```

> Storage accounts have special constraints: lowercase alphanumeric only, 3–24 characters, globally unique. Drop hyphens and abbreviate: `stwapiprd001`.

---

## Rules

- **All lowercase with hyphens** — avoids case sensitivity issues across CLI, ARM templates, and Terraform
- **No PascalCase or camelCase**
- **Hyphens as separators**, not underscores
- **Instance number is zero-padded** (`001`, not `1`) for consistent sorting
- **NSGs and VNets are not per-instance** — omit the instance number when a resource is shared
- **Never use generic names** like `vm-001` or `server1` — provides no context about workload or environment
- **Be consistent** — mixing conventions in the same environment is worse than any single imperfect convention

---

## Enforcement

Apply naming conventions via **Azure Policy** — use a `Deny` effect on resources that don't match a naming pattern. This prevents drift at the platform level rather than relying on human discipline.
