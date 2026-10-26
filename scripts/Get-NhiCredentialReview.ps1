#requires -Version 7.0
<# Read-only credential metadata review. Live output is sensitive; fixture output is synthetic. #>
[CmdletBinding()]
param(
    [string]$FixturePath,
    [ValidateRange(1,3650)][int]$WarningDays = 30,
    [datetimeoffset]$AsOf = [datetimeoffset]::UtcNow
)
$ErrorActionPreference = 'Stop'
function Get-GraphPages([string]$Uri) {
    do {
        $page = Invoke-MgGraphRequest -Method GET -Uri $Uri
        foreach ($item in $page.value) { $item }
        $Uri = $page.'@odata.nextLink'
    } while ($Uri)
}
if ($FixturePath) {
    $objects = @(Get-Content -LiteralPath $FixturePath -Raw | ConvertFrom-Json)
    $source = 'SYNTHETIC'
} else {
    if (-not (Get-Command Invoke-MgGraphRequest -ErrorAction SilentlyContinue)) { throw 'Install/import Microsoft.Graph.Authentication and connect with Application.Read.All first.' }
    $objects = @(
        foreach ($collection in 'applications','servicePrincipals') {
            $type = if ($collection -eq 'applications') { 'Application' } else { 'ServicePrincipal' }
            foreach ($obj in (Get-GraphPages ('https://graph.microsoft.com/v1.0/' + $collection + '?$select=id,appId,displayName,passwordCredentials,keyCredentials'))) {
                $obj['objectType'] = $type
                $obj
            }
        }
    )
    $source = 'LIVE-PRIVATE'
}
foreach ($obj in $objects) {
    $count = 0
    foreach ($property in 'passwordCredentials','keyCredentials') {
        foreach ($cred in $obj.$property) {
            if ($null -eq $cred) { continue }
            $count++
            $days = $null
            $state = 'UnknownExpiry'
            if ($cred.endDateTime) {
                # Newer PowerShell JSON parsing can return DateTime rather than a string.
                $expiry = if ($cred.endDateTime -is [datetime]) {
                    [datetimeoffset]::new($cred.endDateTime)
                } else {
                    [datetimeoffset]::Parse([string]$cred.endDateTime)
                }
                $remaining = ($expiry - $AsOf).TotalDays
                $days = [math]::Floor($remaining)
                $state = if ($remaining -le 0) { 'Expired' } elseif ($remaining -le $WarningDays) { 'ExpiringSoon' } else { 'OutsideWarningWindow' }
            }
            [pscustomobject]@{Source=$source;AsOfUtc=$AsOf.ToUniversalTime().ToString('o');Identity=$obj.displayName;ObjectType=$obj.objectType;ObjectId=$obj.id;ClientId=$obj.appId;CredentialType=$property;CredentialId=$cred.keyId;Expiry=$cred.endDateTime;DaysRemaining=$days;Finding=$state}
        }
    }
    if ($count -eq 0) {
        [pscustomobject]@{Source=$source;AsOfUtc=$AsOf.ToUniversalTime().ToString('o');Identity=$obj.displayName;ObjectType=$obj.objectType;ObjectId=$obj.id;ClientId=$obj.appId;CredentialType='None';CredentialId='';Expiry='';DaysRemaining=$null;Finding='NoCustomerCredentialObserved'}
    }
}
