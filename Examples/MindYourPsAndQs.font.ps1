<#
.SYNOPSIS
    Mind your 'P's and 'q's 
.DESCRIPTION
    A simple demo to help you mind your 'P's and 'q's
.NOTES
    The phrase "Mind your 'P's and 'q's" originates with typography.

    Uppercase P is typically the tallest letter, and lowercase q is typically the lowest letter.

    This little example imports the Inconsolata font and gets the 'P' and 'q' characters and saves them as an SVG.
#>
param(
[string]
$FontFamily = 'Inconsolata'
)

$importedFont =
    Get-Font |
        Where-Object FamilyName -eq $FontFamily |
        Select-Object -First 1 |
        Import-Font

$importedFont.GetGlyph("P").SVG.Save("$pwd/${FontFamily}_P.svg")
Get-Item "$pwd/${FontFamily}_P.svg"
$importedFont.GetGlyph("q").SVG.Save("$pwd/${FontFamily}_q.svg")
Get-Item "$pwd/${FontFamily}_q.svg"