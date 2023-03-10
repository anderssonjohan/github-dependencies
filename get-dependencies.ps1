<#
Gets all dependencies found for a given repository using the GitHub dependency graph.

Returns a flat list of objects with the properties:
- packageName (name of dependency)
- requirements (version requirement)
- hasDependencies (true/false has dependencies)
- packageManager (NPM, PIP, ACTIONS, ...)
- dependencyRepository (repository of the dependency)
- blobPath (path to manifest file having the dependency)
- owner (owner of the repository having the dependency)
- name (name of the repository having the dependency)
#>

param(
    [parameter(mandatory, valuefrompipelinebypropertyname)]
    [string] $owner,
    [parameter(mandatory, valuefrompipelinebypropertyname)]
    [string] $name
)

begin {
  function getRepositoryQuery($owner, $name) {
      @"
  {
    repository(owner:"$owner", name:"$name") {
      dependencyGraphManifests {
        totalCount
        nodes {
          filename
        }
        edges {
          node {
            blobPath
            dependencies {
              totalCount
              nodes {
                packageName
                requirements
                hasDependencies
                packageManager
                repository {
                  nameWithOwner
                }
              }
            }
          }
        }
      }
    }
  }
"@
  }
}
process {
  $query = getRepositoryQuery $owner $name
  $result = ./execute-graphql.ps1 $query
  $nonEmpty = $result | % repository | % dependencyGraphManifests | % edges | % node
  $nonEmpty | %{
    $blobPath = $_.blobPath
    $_.dependencies | % nodes | %{
      $_ `
      | select packageName, requirements, hasDependencies, packageManager, `
      @{ name = "dependencyRepository"; expression = { $_.repository.nameWithOwner } }, `
      @{ name = "blobPath"; expression = { $blobPath } }, `
      @{ name = "owner"; expression = { $owner } }, `
      @{ name = "name"; expression = { $name } }
    }
  }
}