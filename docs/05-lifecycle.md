# Stage 5 — Inactivity, legacy accounts, and rotation

## Potentially unused service principals

Create an uncredentialed `NHI-Lab-OldDev` app only if a test needs it; record its creation date. In **Monitoring & health → Sign-in logs**, examine **Service principal sign-ins** and **Managed identity sign-ins** separately. Filter to the lab identity and available UTC interval. Record licensing, retention, export coverage, and collection time. A new app without activity is a fixture, not proof of a 90-day inactivity detector.

The Graph `servicePrincipalSignInActivity` API is beta: optional exploration only, subject to change. Confirm current permissions/licensing before using it. Do not silently substitute interactive user sign-ins for workload activity.

Use these review outcomes:

- **Observed use:** timestamp and successful workload authentication evidence present.
- **No use observed within available window:** investigate owner, job schedule, dependencies, and longer retained logs.
- **Unknown:** logs unavailable, insufficient retention, missing permissions, or failed collection.
- **Retirement candidate:** owner and dependency review completed; approved staged disable test and recovery plan documented.

Never automatically delete based on missing logs. A monthly or disaster-recovery job may legitimately be quiet. Disabled workload authentication and cached tokens also need consideration during testing.

## Legacy AD service-account review

On the Project #7 lab DC with the ActiveDirectory module, read only the dedicated service-account OU (replace the DN with your actual lab OU):

```powershell
Get-ADUser -SearchBase 'OU=ServiceAccounts,DC=identitylab,DC=local' -Filter * -Properties Enabled,PasswordNeverExpires,PasswordLastSet,ServicePrincipalName,MemberOf |
  Select-Object SamAccountName,Enabled,PasswordNeverExpires,PasswordLastSet,ServicePrincipalName,MemberOf
```

Do not create a privileged account or weaken password policy for a demonstration. Use fictional `LegacyBackupSvc` in the findings table. Check owner, services/tasks, local and domain privilege, interactive logon restrictions, credential storage, and rotation compatibility. Consider gMSA for supported domain workloads; managed identity applies only where the hosting environment and target support it. SPN presence does not prove active use; missing SPNs do not prove an account is not a service account. `lastLogonTimestamp` is approximate and cannot establish inactivity alone.

## Credential rotation runbook

1. Identify owner, dependent workloads, current credential ID, expiry, maintenance window, and recovery method.
2. Create a replacement secret/certificate; keep a short, explicit overlap window. Store it securely and restrict private-key access.
3. Update one lab workload, acquire a fresh token, and test the intended API operation.
4. Verify workload logs and identity sign-ins where available. Migrate remaining dependencies and observe scheduled runs.
5. Remove the old credential after successful validation. Confirm fresh authentication using the removed credential fails; do not treat cached token success as rotation failure.
6. Re-run metadata audit; capture old/new credential IDs and dates with aliases, never credential values.
7. If the replacement fails before removal, roll back the workload during the overlap. If already removed, use an authorized new credential; deleted secret values cannot be recovered.

For suspected compromise, prioritize containment over normal overlap. Record incident-specific decisions separately. Certificates still expire; monitor them too. Federated credentials remove stored keys for compatible external workloads but introduce trust-policy review requirements.
