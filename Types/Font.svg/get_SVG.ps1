if (-not $this.'#SVG') {
    if ($this -is [IO.FileInfo] -and $this.Extension -eq '.svg') {
        $svgXml = (Get-Content -LiteralPath $this.FullName -Raw) -as [xml]
        if ($svgXml) {
            $this | Add-Member NoteProperty '#SVG' $svgXml -Force
        }
    }
}
return $this.'#SVG'