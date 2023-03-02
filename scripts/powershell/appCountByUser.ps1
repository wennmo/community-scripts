
$users = qlik user ls --limit=100 | ConvertFrom-Json

$list = New-Object System.Collections.Generic.List[System.Object]
foreach ($user in $users) {
    $userId = $user.id
    $itemIds = qlik item ls --ownerId=$userId --resourceType=app --limit=10000 -q
    $entry = @{
        name     = $user.name
        appCount = $itemIds.Length
    }
    $list.Add($entry)
}

$out = ConvertTo-Json $list

Write-Output $out
