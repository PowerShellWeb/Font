param(
[PSObject]$value
)

if ($value -is [string] -and $value.Length -le 2) {
    $this.SVG | 
        Select-Xml -Namespace @{s='http://www.w3.org/2000/svg'} -XPath "//s:glyph[@unicode='$($value -replace "'", "''")']" |
        Select-Object -ExpandProperty Node
}
