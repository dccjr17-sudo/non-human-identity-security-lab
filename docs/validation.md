# Validated results and limitations

Personal lab evidence supplied October 21–26, 2026. The user executed the cloud and AD checks. No employer data was used.

| Exercise | Observed result | Evidence |
|---|---|---|
| Secret authentication | Graph top=1 applications read returned 1 | E03 |
| Certificate authentication | AppOnly / ClientCertificate; authorized Graph read | E04 |
| Secret removal | Old secret authentication failed; certificate read succeeded | E05 |
| Expiry review | 0 secrets, 1 certificate; 89 days remaining at capture | E06 |
| Synthetic detection | Expired, 8-day, exact 30-day, and 90-day cases passed | E06b |
| Permission review | One granted application role: Microsoft Graph Application.Read.All | E07 |
| Workload activity | Successful Graph event; client assertion; user privately matched thumbprint to uploaded certificate | E08 |
| Bounded inactivity | Newly created OldDev: no service-principal events in Last 24 hours | E08b |
| Azure managed identity | No enabled subscription; no deployment | Design-only |
| Legacy AD review | Jordan.Service disabled; password expiration enabled; no SPNs; blank description and LastLogonDate | E12 |
| Dependency search | No matching Windows services/tasks on LAB-DC01 or LAB-SYNC01 | E12c and screenshots supplied in chat |
| Retirement | OldDev deactivated; AccountEnabled true to false | E13 |
| Retirement audit | Successful Update service principal for NHI-Lab-OldDev; AccountEnabled true to false | E14a–c |
| Replacement test | AppOnly / ClientCertificate; Graph read returned 1 | E15 |
| Rotation retest | Original authentication failed; replacement Graph read succeeded | E16 |
| Final state | One certificate, zero secrets, zero federated credentials; expiry Jan 24, 2027 | E17 |

## Interpretation and limits

- top=1 is an authorization test, not a total inventory count.
- Generic old-secret and original-certificate errors did not expose specific AADSTS codes. Negative authentication outcomes were observed; their exact server-side causes were not independently established. Removal was separately reported or shown.
- App-role review does not cover delegated grants, directory roles, Azure RBAC, or every authorization surface. Application.Read.All is tenant-wide read access justified for this lab inventory task.
- The event list includes aggregation. One selected successful event was at 2026-10-21T20:58:40Z. Most command UTC timestamps were not captured. Retirement audit displays Oct 26, 2026, 9:36 AM without a visible timezone.
- No events in a selected window does not prove long-term inactivity. OldDev had no working credentials or integration; retirement verified an administrative control, not a working workload denial.
- Project #7 records Jordan.Service as a disabled inventory fixture with no application integration or stored application secret. Retain disabled. No AD password rotation or gMSA deployment was performed.
- MemberOf excludes primary group and does not establish effective access. Name-based dependency checks covered two hosts and may miss SID-based references, scripts, other hosts, or external systems. Blank LastLogonDate alone cannot establish an inactivity threshold.
- Certificate private keys still require access controls and renewal. Issued tokens may remain valid after credential removal. Rotation tested one lab client, not enterprise availability.

## Script verification

Both repository scripts parsed locally in PowerShell 7.6.5 on October 20, 2026. Offline assertions covered expired, expiring, absent credentials, outside-warning, and exact-expiry cases. A DateTime conversion defect was fixed and retested. User-executed inline live checks do not establish a live run of the complete repository inventory script or live pagination coverage. Expected CSV output remains synthetic.

## Final disposition

NHI-Lab-Inventory retains the replacement certificate and Application.Read.All; original credential and temporary secret removed. NHI-Lab-OldDev is disabled and retained. Jordan.Service remains disabled and excluded from cloud sync. Azure managed identity is design-only.

Review expiry before January 24, 2027 and rotate or retire the lab. No scheduled monitoring has been configured. Evidence not available locally is never recreated or represented as captured.

