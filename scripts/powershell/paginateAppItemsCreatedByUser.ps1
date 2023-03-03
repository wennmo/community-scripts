## Author: colssonqlik
## Version: v0.0.1
## Description: get all app items created by current user
## Shell: powershell
# Paginate all items created by current user
# Change the flag to filter by something else, use qlik item ls -h to see the options

$user = qlik user me | ConvertFrom-Json
$items = qlik item ls --raw --limit 10 --resourceType app --createdByUserId $user.id | ConvertFrom-Json
$apps = $items.data
TRY { $next_path = [regex]::match($items.links.next.href, 'next=(.*?)(&|$)').Groups.Value[1]; }
CATCH { $next_path = $null }
WHILE ($next_path) {
    $items = qlik item ls --limit 10 --resourceType app --createdByUserId $user.id --next $next_path --raw | ConvertFrom-Json;
    TRY { $next_path = [regex]::match($items.links.next.href, 'next=(.*?)(&|$)').Groups.Value[1]; }
    CATCH { $next_path = $null }
    $apps += $items.data;
}

$out = ConvertTo-Json $apps

Write-Output $out