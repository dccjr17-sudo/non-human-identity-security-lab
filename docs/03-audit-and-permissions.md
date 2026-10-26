# Stage 3 — Read-only risk review

## Credential audit

Start offline from the repository root:

```powershell
./scripts/Get-NhiCredentialReview.ps1 -FixturePath ./samples/credential-fixture.json -AsOf '2026-10-20T00:00:00Z' | Format-Table
```

For live collection, use a fresh delegated connection as the operator, separate from the workload's application connection:

```powershell
Connect-MgGraph -TenantId (Read-Host 'Lab tenant ID') -Scopes Application.Read.All -ContextScope Process -NoWelcome
New-Item -ItemType Directory ./private -Force | Out-Null
./scripts/Get-NhiCredentialReview.ps1 | Export-Csv ./private/credential-review.csv -NoTypeInformation
```

The script follows pagination and reads credential metadata on both application and service principal objects. It does not retrieve secret values, infer owners, inspect federated credentials, or declare permission risk. Managed identities with no customer-managed credential are expected; absence of credentials alone is not proof of security.

## Effective application permissions

```powershell
./scripts/Get-NhiPermissionReview.ps1 -ServicePrincipalId (Read-Host 'Enterprise application object ID') | Format-Table
Disconnect-MgGraph
```

The script resolves **granted app role assignments**, not only permissions requested on the app registration. It uses `Application.Read.All`; errors stop collection rather than producing a misleading clean report. Delegated OAuth grants, Entra directory roles, resource-specific consent, and Azure RBAC require separate reviews.

| Review question | Required decision |
|---|---|
| What exact API operation is required? | Map each operation to its documented least permission |
| Application or delegated? | Background workload uses its own app identity; delegated includes a user |
| Requested versus granted? | Compare registration requests with service principal effective grants |
| Is tenant-wide read justified? | State exposure and evaluate narrower architecture |
| Who owns it? | Named lab owner, purpose, review date, retirement condition |
| How do we prove reduction? | Required request still succeeds; a documented operation requiring a removed permission fails |

Do not assert a denied Graph call proves all unwanted access is gone. Use a small matrix of specific operations, expected outcomes, actual status codes, UTC timestamps, and evidence IDs. Simulate excessive write grants on paper rather than granting them solely for a test.
