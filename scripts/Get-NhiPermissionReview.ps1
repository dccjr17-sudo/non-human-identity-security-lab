#requires -Version 7.0
<# Requires an existing Graph connection with Application.Read.All. No changes are made. #>
[CmdletBinding()]
param([Parameter(Mandatory)][guid]$ServicePrincipalId)
$ErrorActionPreference = 'Stop'
$uri = "https://graph.microsoft.com/v1.0/servicePrincipals/$ServicePrincipalId/appRoleAssignments"
do {
    $page = Invoke-MgGraphRequest -Method GET -Uri $uri
    foreach ($assignment in $page.value) {
        $resource = Invoke-MgGraphRequest -Method GET -Uri ('https://graph.microsoft.com/v1.0/servicePrincipals/' + $assignment.resourceId + '?$select=displayName,appRoles')
        $role = @($resource.appRoles | Where-Object { $_.id -eq $assignment.appRoleId })
        $name = if ($role.Count) { $role[0].value } else { 'UnresolvedOrDefaultRole-ReviewRequired' }
        [pscustomobject]@{Source='LIVE-PRIVATE';PrincipalId=$ServicePrincipalId;Resource=$resource.displayName;ResourceId=$assignment.resourceId;AppRoleId=$assignment.appRoleId;Permission=$name;Review='Document required operation and scope'}
    }
    $uri = $page.'@odata.nextLink'
} while ($uri)
