param([string]$value)
$this | 
    Select-Xml -Namespace @{s='http://www.w3.org/2000/svg'} -XPath "//s:glyph[@unicode='$($value -replace "'", "''")']" |
    Select-Object -ExpandProperty Node