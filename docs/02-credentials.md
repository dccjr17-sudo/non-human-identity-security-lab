# Stage 2 — Secrets, certificates, and a real API test

Use PowerShell 7. Install `Microsoft.Graph.Authentication` for the current user if absent. Record the installed version in the journal.

## Application permission

On `NHI-Lab-Inventory`, open **API permissions → Add a permission → Microsoft Graph → Application permissions**. Add `Application.Read.All` and have the authorized lab administrator grant consent. This is tenant-wide application metadata read access, not a narrow per-app boundary. Record the reason and intended removal date. Do not grant `Directory.ReadWrite.All` or `Application.ReadWrite.All` for this lab.

## Temporary secret demonstration

1. Under **Certificates & secrets → Client secrets**, create a temporary lab secret using a short available lifetime. Record expiry and credential ID, never its value in the journal.
2. Store the value temporarily in an approved personal secret store. The value is shown only once. Do not put it in a command literal, screenshot, transcript, repository, or chat.
3. Authenticate from a fresh PowerShell session; the prompt keeps the secret out of command history:

```powershell
Import-Module Microsoft.Graph.Authentication
$tenantId = Read-Host 'Lab tenant ID'
$clientId = Read-Host 'Lab application/client ID'
$secret = Read-Host 'Temporary client secret' -AsSecureString
$credential = [pscredential]::new($clientId, $secret)
Connect-MgGraph -TenantId $tenantId -ClientSecretCredential $credential -ContextScope Process -NoWelcome
Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/applications?$top=1&$select=displayName'
Disconnect-MgGraph
Remove-Variable secret,credential
```

Do not paste response bodies containing real names into public evidence. A successful token acquisition does not prove API authorization; the GET is the authorization test.

## Certificate concept and demonstration

The workload signs an assertion using its private key. Entra validates it using the uploaded public certificate. The private key remains a credential needing access controls, renewal, and recovery planning. This is application authentication, distinct from Entra user certificate-based authentication.

On Windows in the lab account:

```powershell
$cert = New-SelfSignedCertificate -Subject 'CN=NHI-Lab-Inventory' -CertStoreLocation 'Cert:\CurrentUser\My' -KeyAlgorithm RSA -KeyLength 2048 -KeyExportPolicy NonExportable -NotAfter (Get-Date).AddDays(90)
New-Item -ItemType Directory -Path ./private -Force | Out-Null
Export-Certificate -Cert $cert -FilePath ./private/nhi-lab-public.cer | Out-Null
```

Upload only the `.cer` at **Certificates & secrets → Certificates**. Self-signed certificates are suitable here for an isolated demonstration; production certificate issuance and key custody need separate design.

```powershell
Connect-MgGraph -TenantId $tenantId -ClientId $clientId -CertificateThumbprint $cert.Thumbprint -ContextScope Process -NoWelcome
Invoke-MgGraphRequest -Method GET -Uri 'https://graph.microsoft.com/v1.0/applications?$top=1&$select=displayName'
Disconnect-MgGraph
```

After certificate success, remove the temporary secret in the portal. Try a fresh connection with the old secret and confirm a new token request fails. Existing access tokens can remain valid until expiry; secret removal is not universal immediate session revocation. Capture only sanitized outcomes, never tokens. Follow the rotation runbook before replacing any credential with dependencies.
