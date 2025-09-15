if (-not $this.'#XML') {
    if ($this -is [IO.FileInfo] -and $this.Extension -eq '.svg') {
        $svgXml = (Get-Content -LiteralPath $this.FullName -Raw) -as [xml]
        if ($svgXml) {
            $this | Add-Member NoteProperty '#XML' $svgXml -Force
        }
    }
}
return $this.'#XML'