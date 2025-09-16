param(
[PSObject]$value
)

filter toGlyph {    
    $_.Node.pstypenames.add('Font.glyph')
    $_.Node
}
if ($value -is [string] -and $value.Length -le 2) {
    $escapedValue = $($value -replace "'","''")
    $this.XML | 
        Select-Xml -Namespace @{s='http://www.w3.org/2000/svg'} -XPath "//s:glyph[@unicode='$escapedValue'] | //s:glyph[@glyph-name='$escapedValue']" | 
        toGlyph
}

if ($null -eq $value) {
    $this.XML | 
        Select-Xml -Namespace @{s='http://www.w3.org/2000/svg'} -XPath "//s:glyph" |
        toGlyph
}
