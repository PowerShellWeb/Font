#requires -Module PSDevOps
Import-BuildStep -SourcePath (
    Join-Path $PSScriptRoot 'GitHub'
) -BuildSystem GitHubAction

$PSScriptRoot | Split-Path | Push-Location

New-GitHubAction -Name "BuildFont" -Description 'Turtles in a PowerShell' -Action FontAction -Icon type -OutputPath .\action.yml

Pop-Location