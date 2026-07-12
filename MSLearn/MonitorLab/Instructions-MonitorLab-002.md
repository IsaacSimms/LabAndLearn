# Create Data Collection Endpoint + Data Collection Rule for Linux Syslog

This guide walks through creating a **Data Collection Endpoint** and a **Data Collection Rule (DCR)** to collect Linux Syslog events and send them to a Log Analytics workspace.

---

## Part 1: Create a Data Collection Endpoint

You must have a data collection endpoint to send log data to.

1. In the Azure Monitor left navigation menu under **Settings**, select **Data Collection Endpoints**.
2. On the **Data Collection Endpoints** page, select **Create**.
3. On the **Create data collection endpoint** page:
   - For **Name**, enter `linux-logs-endpoint`.
   - Select the same **Subscription**, **Resource group**, and **Region** as your VM uses.
4. Select **Review + create**, and when validation passes, select **Create**.

---

## Part 2: Create the Data Collection Rule (DCR)

1. In the Azure Monitor left navigation menu under **Settings**, select **Data Collection Rules**.
2. On the **Data Collection Rules** page, select **Create** to create a new data collection rule.
3. On the **Basics** tab of the **Create Data Collection Rule** screen, provide the following:
   - **Rule name**: `collect-events-linux`
   - **Subscription**, **Resource Group**, and **Region**: Select the same values used for your VM.
   - **Platform Type**: Select **Linux**.
4. Select **Next: Resources** (or the **Resources** tab).
5. On the **Resources** screen, select **Add resources**.
6. On the **Select a scope** screen, select your `monitored-linux-vm`, then select **Apply**.
7. On the **Resources** screen, select **Enable Data Collection Endpoints**.
8. Under **Data collection endpoint** for the VM, select the `linux-logs-endpoint` you created earlier.
9. Select **Next: Collect and deliver** (or the **Collect and deliver** tab).
10. On the **Collect and deliver** tab, select **Add data source**.
11. On the **Add data source** screen:
    - Under **Data source type**, select **Linux Syslog**.
12. Select **Next: Destination** (or the **Destination** tab).
    - Select your **Log Analytics workspace** as the destination (see note below if you don't have one yet).
13. Select **Add data source**.
14. On the **Create Data Collection Rule** screen, select **Review + create**, then **Create** when validation passes.

---

## Part 3: View Log Data

1. On your VM's **Overview** page, select **Logs** from the left navigation menu under **Monitoring**.
   - Log Analytics opens with the scope set to your VM.
   - (You can also reach Logs from the Azure Monitor overview page and set the scope manually.)
2. In the query window, type `Syslog` and select **Run**.
   - This shows all system log events collected by the DCR within the selected time range.
3. Refine the query as needed. Example – show only warnings:

   ```kql
   Syslog
   | where SeverityLevel == "warning"
   ```

---

## Important Note: Log Analytics Workspace Requirement

A **Log Analytics workspace** is the storage and query engine for log data in Azure Monitor. All Data Collection Rules must have at least one Log Analytics workspace as a destination.

If you do not see any workspace when adding the destination (step 12 above), you need to create one first:

### Quick fix – Create a Log Analytics Workspace

1. In the Azure portal, search for **Log Analytics workspaces** and select it.
2. Select **Create**.
3. Fill in:
   - **Subscription**: Same as your VM and DCR.
   - **Resource group**: Same as your VM (or create a new one).
   - **Name**: Something like `law-linux-logs-cus-001`.
   - **Region**: Must match your VM and Data Collection Rule region (Central US in your case).
   - **Pricing tier**: Leave as **Pay-as-you-go** (default).
4. Select **Review + create** → **Create**.

Once the workspace is created, return to the **Add data source** screen in your DCR and select it under **Log Analytics Workspaces**.

After the DCR is created, you can query the `Syslog` table as shown in Part 3.