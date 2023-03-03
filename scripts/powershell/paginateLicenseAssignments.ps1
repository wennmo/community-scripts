# Paginate all license assignments

$assignments = qlik license assignment ls --raw --limit 10 | ConvertFrom-Json
$arr = $assignments.data
TRY {
    $page = [regex]::match($assignments.links.next.href, 'page=(.*?)(&|$)').Groups.Value[1]
}
CATCH { $page = $null }
WHILE ($page) {
    $assignments = qlik raw get v1/licenses/assignments --query page=$page --raw | ConvertFrom-Json;
    TRY {
        $page = [regex]::match($assignments.links.next.href, 'page=(.*?)(&|$)').Groups.Value[1]
    }
    CATCH { $page = $null }
    $arr += $assignments.data;
}

$out = ConvertTo-Json $arr

Write-Output $out
