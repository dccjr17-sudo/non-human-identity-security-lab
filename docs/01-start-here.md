# Stage 1 — Establish the identity model

## Prerequisites

Use the personal Entra tenant from Project #7 if still available. Check that it is yours and that any trial has not expired. No Azure subscription is required for stages 1–3. Use an account allowed to register applications; tenant policy may restrict this. Admin consent requires an appropriately authorized administrator and depends on the permission being granted. Do not assume application ownership permits consent.

## First checkpoint

1. Open https://entra.microsoft.com and verify the current directory is the personal lab tenant.
2. Navigate to **Entra ID → App registrations → New registration**.
3. Name: `NHI-Lab-Inventory`. Select **Accounts in this organizational directory only**. Leave redirect URI empty for this background workload.
4. Register. Privately record tenant ID, application/client ID, and application object ID. Use aliases in published evidence.
5. Open **Enterprise applications**, search for `NHI-Lab-Inventory`, and record that object's ID separately. If it is not visible, check filters and tenant selection before creating duplicates.
6. In the app's **API permissions**, inspect the default delegated permission. Remove default `User.Read` if present because this workload will use application authentication.
7. Add a fictional purpose/owner in your journal: “Inventory application credential metadata; owner: Northstar Lab IAM; quarterly review.” Do not add permissions or credentials yet.
8. Capture E01 and E02 from the evidence index.

**Success:** you can explain why the client ID matches across the two objects while the object IDs differ. Registration alone does not grant Graph application access.

Next: stage 2. Leave unused and excessive-permission scenarios simulated until a specific test needs them; do not grant powerful write permissions merely to produce a screenshot.
