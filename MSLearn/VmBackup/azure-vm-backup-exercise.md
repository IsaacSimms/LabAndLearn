# Exercise: Back Up an Azure Virtual Machine

**100 XP** • *10 minutes*

Your company runs a combination of Windows and Linux workloads. You're asked to prove that Azure Backup is a good fit for both kinds of virtual machines (VMs). By using a combination of the Azure CLI and the Azure portal, you help protect both kinds of virtual machines with Azure Backup.

Azure Backup can be quickly enabled for virtual machines in Azure. You can enable Azure Backup from the portal, from the Azure CLI, or by using PowerShell commands.

In this exercise, you create a virtual machine (VM), set up a backup, and start a backup.

> **Note**  
> This exercise is optional. If you don't have an Azure account, you can read through the instructions so you understand how to back up virtual machines by using Azure Backup. If you want to complete this exercise, but you don't have an Azure subscription or you prefer not to use your own account, create a free account before you begin.

## Customization Notes

- **Location**: Updated to `centralus` (change to your preferred region if needed; ensure consistency across all commands).
- **Resource names**: Kept as illustrative examples (`vmbackups`, `NW-APP01`, `NW-RHEL01`, `NorthwindInternal`, `azure-backup`). Update **all** references consistently when renaming.
- Run commands sequentially in the **same Azure Cloud Shell session** so `$RGROUP` and other variables persist.
- All CLI examples use Bash/Cloud Shell syntax.

---

## Set Up the Environment

1. Sign in to the Azure portal and open **Azure Cloud Shell** (Bash).

2. Create a resource group to contain all the resources for this exercise.

   **Azure CLI**

   ```bash
   RGROUP=$(az group create --name vmbackups --location centralus --output tsv --query name)
   ```

3. Create the `NorthwindInternal` virtual network and the `NorthwindInternal1` subnet.

   **Azure CLI**

   ```bash
   az network vnet create \
       --resource-group $RGROUP \
       --name NorthwindInternal \
       --address-prefixes 10.0.0.0/16 \
       --subnet-name NorthwindInternal1 \
       --subnet-prefixes 10.0.0.0/24
   ```

## Create a Windows Virtual Machine (Azure CLI)

Create the `NW-APP01` virtual machine. Replace `<password>` with a strong password of your choice (enclosed in double quotes).

**Azure CLI**

```bash
az vm create \
    --resource-group $RGROUP \
    --name NW-APP01 \
    --size Standard_DS1_v2 \
    --public-ip-sku Standard \
    --vnet-name NorthwindInternal \
    --subnet NorthwindInternal1 \
    --image Win2016Datacenter \
    --admin-username admin123 \
    --no-wait \
    --admin-password "<password>"
```

## Create a Linux Virtual Machine (Azure CLI)

Create the `NW-RHEL01` virtual machine.

**Azure CLI**

```bash
az vm create \
    --resource-group $RGROUP \
    --name NW-RHEL01 \
    --size Standard_DS1_v2 \
    --image RedHat:RHEL:8-gen2:latest \
    --authentication-type ssh \
    --generate-ssh-keys \
    --vnet-name NorthwindInternal \
    --subnet NorthwindInternal1
```

> **Note**  
> If you receive a `securityProfile.securityType is invalid` error, register the feature and retry:
>
> ```bash
> az feature register --name UseStandardSecurityType --namespace Microsoft.Compute
> az feature show --name UseStandardSecurityType --namespace Microsoft.Compute
> ```

The VM creation commands can take several minutes. Wait for completion before proceeding.

## Enable Backup for a Virtual Machine (Azure Portal)

### For the Linux VM (NW-RHEL01)

1. In the Azure portal, search for and select **Virtual machines**.
2. Select **NW-RHEL01** from the list.
3. In the middle menu, select the **Capabilities** tab, then scroll to and select **Backup**.
4. Choose the **Standard** tier. Accept the defaults:
   - Backup vault name (e.g., `vaultXXX`)
   - Backup policy (e.g., `DailyPolicy-xxxxxxxx` — daily at 12:00 PM UTC, 180-day retention)
5. Select **Enable backup**.
6. After deployment completes, return to the **NW-RHEL01** VM → **Capabilities** tab → **Backup**.
7. In the top menu, select **Backup now** → **OK** to start the initial backup.

## Enable Backup Using the Azure CLI

### Create Recovery Services Vault and Enable Protection (Windows VM)

1. Create the backup vault.

   **Azure CLI**

   ```bash
   az backup vault create \
       --resource-group vmbackups \
       --location centralus \
       --name azure-backup
   ```

2. Enable backup protection for `NW-APP01`.

   **Azure CLI**

   ```bash
   az backup protection enable-for-vm \
       --resource-group vmbackups \
       --vault-name azure-backup \
       --vm NW-APP01 \
       --policy-name EnhancedPolicy
   ```

3. Monitor job progress until `ConfigureBackup` shows `Completed`.

   **Azure CLI**

   ```bash
   az backup job list \
       --resource-group vmbackups \
       --vault-name azure-backup \
       --output table
   ```

   Repeat until the `ConfigureBackup` job for `NW-APP01` is `Completed`. Example output:

   ```text
   Name                                  Operation        Status      Item Name    Start Time UTC                    Duration
   ------------------------------------  ---------------  ----------  -----------  --------------------------------  --------------
   a3df79b4-be4f-4cc9-8b2c-a5ead44a6a12  ConfigureBackup  Completed   NW-APP01     2019-08-01T06:19:12.101048+00:00  0:00:31.305975
   5e1531a9-8b3d-4983-a642-86ee982f7036  Backup           InProgress  NW-RHEL01    2019-08-01T06:18:35.955118+00:00  0:01:22.734182
   860d4dca-9603-4a4e-9f3b-93f242a0a64d  ConfigureBackup  Completed   NW-RHEL01    2019-08-01T06:13:33.860598+00:00  0:00:31.256773
   ```

4. Trigger an on-demand backup for `NW-APP01` (no need to wait for the scheduled run).

   **Azure CLI**

   ```bash
   az backup protection backup-now \
       --resource-group vmbackups \
       --vault-name azure-backup \
       --container-name NW-APP01 \
       --item-name NW-APP01 \
       --retain-until 18-10-2030 \
       --backup-management-type AzureIaasVM
   ```

## Monitor Backups in the Azure Portal

### View Backup Status for a Specific VM

1. From the portal menu or Home, select **All resources**.
2. Search for and select **Virtual machines**.
3. Select **NW-APP01**.
4. Go to **Capabilities** tab → **Backup**.
5. Under **Backup status**, check **Last backup status**.

### View All Backups in the Recovery Services Vault

1. From the portal menu or Home, select **All resources**.
2. Sort by **Type** and select the **azure-backup** Recovery Services vault.
3. On the **Overview** page, select the **Backup** tab (interior) to see backup items, storage usage, and active jobs.

---

**Next:** Restore virtual machine data from backup (separate exercise).