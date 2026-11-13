# Smoke test for the local WHO ICD-API container
param(
    [string]$Query = "diabetes",
    [int]$Port = 8382,
    [string]$Release = "2026-01"
)

$headers = @{ "API-Version" = "v2"; "Accept-Language" = "en"; "Accept" = "application/json" }
$base = "http://localhost:$Port/icd"

$r = Invoke-RestMethod -Headers $headers -Uri "$base/release/11/$Release/mms/search?q=$([uri]::EscapeDataString($Query))"
"Search '$Query' -> $($r.destinationEntities.Count) results"
$r.destinationEntities | Select-Object -First 5 | ForEach-Object {
    "  {0,-10} {1}" -f $_.theCode, ($_.title -replace '<[^>]+>', '')
}

$c = Invoke-RestMethod -Headers $headers -Uri "$base/release/11/$Release/mms/codeinfo/5A11"
"Code info 5A11 -> $($c.stemId)"
