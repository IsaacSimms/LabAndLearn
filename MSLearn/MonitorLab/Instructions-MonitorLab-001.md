# Create a Monitored Linux Virtual Machine in Central US

This guide creates an Ubuntu Linux VM in the **Central US** region with recommended Azure Monitor alert rules and boot diagnostics enabled. It is based on standard Azure Monitor / VM monitoring lab instructions with the region updated.

## Create the Virtual Machine

1. Sign in to the [Azure portal](https://portal.azure.com).
2. In the Search field, enter **virtual machines**.
3. On the Virtual machines page, select **Create** > **Azure virtual machine**.

### Basics Tab

1. **Subscription**: Select the correct subscription if not already selected.
2. **Resource group**:
   - Select **Create new**.
   - Under **Name**, enter `learn-monitor-vm-rg`.
   - Select **OK**.
3. **Virtual machine name**: Enter `monitored-linux-vm`.
4. **Region**: Select **Central US**.
5. **Image**: Select **Ubuntu Server 20.04 LTS - x64 Gen2**.
6. Leave all other settings at their default values (Size, Administrator account, inbound ports, etc.).
7. Select the **Monitoring** tab to continue.

### Monitoring Tab

1. Select the checkbox next to **Enable recommended alert rules**.
2. On the **Set up recommended alert rules** screen:
   - Select all the listed alert rules (adjust thresholds if desired).
   - Under **Notify me by**, select the checkbox next to **Email** and enter an email address to receive notifications.
   - Select **Save**.
3. Under **Diagnostics**:
   - For **Boot diagnostics**, ensure **Enable with managed storage account (recommended)** is selected.
   - **Important**: Do **not** enable **OS guest diagnostics**. The Linux Diagnostics Agent (LAD) is deprecated. Guest OS metrics and client monitoring will be configured later using Data Collection Rules and VM insights.
4. Select **Review + create** at the bottom of the page.

### Review + Create

1. Wait for validation to complete.
2. When validation passes, select **Create**.
3. On the **Generate new key pair** dialog, select **Download private key and create resource**.

VM deployment takes several minutes. When you receive the notification that the VM is created, select **Go to resource**.

## Post-Creation: View Monitoring Data

### View Built-in Platform Metrics

Azure automatically begins collecting basic platform metrics once the VM is running.

1. On the VM **Overview** page, select the **Monitoring** tab.
2. Under **Performance and utilization > Platform metrics**, review the following graphs (select **Show more metrics** if needed):
   - VM Availability
   - CPU (average)
   - Disk bytes (total)
   - Network (total)
   - Disk operations/sec (average)
3. Under **Guest OS metrics**, note that guest metrics are not yet collected. These require VM insights and a Data Collection Rule (DCR) configuration in later steps.

### View the Activity Log

- In the VM's left navigation menu, select **Activity log**.
- You can also query activity logs using Azure CLI or PowerShell.

### View Boot Diagnostics

Boot diagnostics were enabled during creation and can help troubleshoot startup issues.

1. In the left navigation menu, select **Boot diagnostics** (under Help).
2. On the Boot diagnostics page:
   - Select **Screenshot** to view a hypervisor-level startup screenshot.
   - Select **Serial log** to view boot log messages.

## Summary

This VM is now deployed in **Central US** with:
- Recommended alert rules configured and email notifications enabled.
- Boot diagnostics using a managed storage account.
- Automatic collection of platform metrics.

Guest OS metrics, deeper performance counters, and log collection require additional configuration using the Azure Monitor Agent and Data Collection Rules (DCRs).