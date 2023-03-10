<#
Gets all repositories for an GitHub organization

Returns objects with the properties:
- owner
- name
#>
param(
    [string] $organization,
    [switch] $isFork = $false,
    [string] $cache = "10m"
)

function getRepositoriesQuery($organization, $isFork) {
    @"
query (`$endCursor: String) {
  organization(login: \"$organization\") {
    repositories(first: 100, after: `$endCursor, isFork: $($isFork.ToString().ToLower())) {
      pageInfo {
        hasNextPage
        endCursor
      }
      nodes {
        name
      }
    }
  }
}
"@
}

$query = getRepositoriesQuery $organization $isfork
$result = ./execute-graphql.ps1 -query $query -cache $cache
$repos = $result | % organization | % repositories | % nodes
$repos | select name, @{ name = "owner"; expression = { $organization } }