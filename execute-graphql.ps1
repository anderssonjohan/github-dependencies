<#
Requires gh CLI + extension to merge multi-paged responses for now:
gh extension install heaths/gh-merge-json

https://github.com/cli/cli/issues/1268#issuecomment-1457240042
#>
param(
    [parameter(mandatory=$true)]
    [string] $query,
    [string] $cache = "10m"
)

$json = gh api --cache $cache -H 'Accept: application/vnd.github.hawkgirl-preview+json' --paginate graphql -F query=$query | gh merge-json

try {
    $result = $json | convertfrom-json
} catch {
    Write-Error "Invalid JSON response"
    $json
    exit 1
}
$data = $result | % data
$errors = $result | % errors
if($errors) {
    Write-Error "Errors calling GitHub GraphQL"
} else {
    $data
}