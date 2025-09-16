param([string]$FilePath)

$unresolvedPath = $ExecutionContext.SessionState.Path.GetUnresolvedProviderPathFromPSPath($FilePath)
$createdFile = New-Item -ItemType File -Path $unresolvedPath
$this.SVG.Save($createdFile.FullName)
Get-Item -LiteralPath $createdFile.FullName