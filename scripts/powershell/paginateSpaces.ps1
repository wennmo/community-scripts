# Paginate all spaces
# Change the flag to filter, use qlik space ls -h to see the options

$spaces = qlik space ls --raw --limit 10 | ConvertFrom-Json
$arr = $spaces.data
TRY { $next_path = [regex]::match($spaces.links.next.href, 'next=(.*?)(&|$)').Groups.Value[1]; }
CATCH { $next_path = $null }
WHILE ($next_path) {
    $spaces = qlik space ls --raw --limit 10 --next $next_path --raw | ConvertFrom-Json;
    TRY { $next_path = [regex]::match($spaces.links.next.href, 'next=(.*?)(&|$)').Groups.Value[1]; }
    CATCH { $next_path = $null }
    $arr += $spaces.data;
}

$out = ConvertTo-Json $arr

Write-Output $out
