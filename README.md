# gh cli scripts

Example scripts on how to use the gh cli with pwsh to explore data from the
GitHub APIs.

The helper script in this repository uses --paginate + --cache to handle large
responses and to avoid hitting API call rate limits.

```powershell
# fetch dependency graphs for all repositories named like *project*
$repos = ./get-repositories.ps1 -owner myorg
$dependencies = $repos | ?{ $_.name -like "*project*" } | %{ ./get-dependencies.ps1 -owner myorg -name $_.name }
# list all dependencies grouped by manifest
$dependencies | Format-Table -GroupBy blobPath -AutoSize -Property packageName, requirements, packageManager, owner, name

# Output:
#
#    blobPath: /myorg/my-project/blob/main/poetry.lock
# 
# packageName         requirements packageManager owner name
# -----------         ------------ -------------- ----- ----------
# ansicon             = 1.89.0     PIP            myorg my-project
# arrow               = 1.2.3      PIP            myorg my-project
# attrs               = 22.2.0     PIP            myorg my-project
# binaryornot         = 0.4.4      PIP            myorg my-project
# black               = 22.12.0    PIP            myorg my-project
# bleach              = 6.0.0      PIP            myorg my-project
# blessed             = 1.20.0     PIP            myorg my-project
# 
#    blobPath: /myorg/my-project/blob/main/pyproject.toml
# 
# packageName     requirements     packageManager owner name
# -----------     ------------     -------------- ----- ----------
# black           ^ 22.3.0         PIP            myorg my-project
# click           >= 7.0.0         PIP            myorg my-project
# cookiecutter    >= 1.4.0         PIP            myorg my-project
# cryptography    ^ 38.0.2         PIP            myorg my-project
# flake8          >= 3.7,< 3.8     PIP            myorg my-project
# isort           ^ 5.8.0          PIP            myorg my-project
# jinja2                           PIP            myorg my-project
# 
#    blobPath: /myorg/my-project/blob/main/.github/workflows/pr-ci.yml
# 
# packageName                             requirements packageManager owner name
# -----------                             ------------ -------------- ----- ----------
# abatilo/actions-poetry                  = 2.2.0      ACTIONS        myorg my-project
# actions/cache                           = 3          ACTIONS        myorg my-project
# actions/checkout                        = 3          ACTIONS        myorg my-project
# actions/setup-python                    = 4          ACTIONS        myorg my-project
# xt0rted/block-autosquash-commits-action = 2.2.0      ACTIONS        myorg my-project
# 
# 
#    blobPath: /myorg/my-project/blob/main/.github/workflows/release-and-publish.yml
# 
# packageName                      requirements packageManager owner name
# -----------                      ------------ -------------- ----- ----------
# abatilo/actions-poetry           = 2.2.0      ACTIONS        myorg my-project
# actions/checkout                 = 3          ACTIONS        myorg my-project
# actions/setup-python             = 4          ACTIONS        myorg my-project
# cycjimmy/semantic-release-action = 3          ACTIONS        myorg my-project
# 
#    blobPath: /myorg/my-project/blob/main/frontend/package.json
# 
# packageName                      requirements packageManager owner name
# -----------                      ------------ -------------- ----- ----------
# @limetech/lime-elements          ^ 36.2.0     NPM            myorg my-project
# @stencil/core                    = 2.17.4     NPM            myorg my-project
# @stencil/sass                    ^ 1.4.1      NPM            myorg my-project
# @types/jest                      ^ 27.0.3     NPM            myorg my-project
# @typescript-eslint/eslint-plugin ^ 5.54.0     NPM            myorg my-project
# @typescript-eslint/parser        ^ 5.54.0     NPM            myorg my-project
# cross-env                        ^ 5.2.1      NPM            myorg my-project
# eslint                           ^ 8.35.0     NPM            myorg my-project
```