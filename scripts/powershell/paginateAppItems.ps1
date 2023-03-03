# Paginate all items
# Change the flag to filter by something else, use qlik item ls -h to see the options

$items = qlik item ls --raw --limit 10 --resourceType app | ConvertFrom-Json
$apps = $items.data
TRY { $next_path = [regex]::match($items.links.next.href, 'next=(.*?)(&|$)').Groups.Value[1]; }
CATCH { $next_path = $null }
WHILE ($next_path) {
    $items = qlik item ls --limit 10 --resourceType app --next $next_path --raw | ConvertFrom-Json;
    TRY { $next_path = [regex]::match($items.links.next.href, 'next=(.*?)(&|$)').Groups.Value[1]; }
    CATCH { $next_path = $null }
    $apps += $items.data;
}

$out = ConvertTo-Json $apps

Write-Output $out
