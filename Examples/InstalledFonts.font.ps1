<#
.SYNOPSIS
    Gets installed fonts
.DESCRIPTION
    Gets the installed fonts
.NOTES
    
#>

Get-Font | 
    Select-Object Name, FamilyName |
    Export-Csv ./GitHubActionFonts.csv

