function Get-Font {
    <#
    .SYNOPSIS
        Gets Fonts
    .DESCRIPTION
        Gets currently installed fonts
    #>
    param()

    $fontPaths = 
        if ($IsLinux) {
            "/usr/share/fonts"
            "$home/.local/share/fonts"
        } elseif ($IsMacOS) {
            "/Library/Fonts"
            "$home/Library/Fonts"
        } else {
            "$env:WinDir\Fonts"
            "$($env:AppData | 
                Split-Path | 
                Join-Path -ChildPath 'Local\Microsoft\Windows\Fonts')"
        }

    $fcList = $ExecutionContext.SessionState.invokecommand.GetCommand('fc-list', 'Application')

    $fontFiles =
        if ($fcList) {        
            & $fcList | 
                ForEach-Object {
                    $o = $_
                    $file, $description = $o -split ':', 2
                    $file -as [IO.FileInfo]
                } | Sort-Object FullName
        } else {    
            $fontPaths | 
                Get-ChildItem -Path { $_ } -ErrorAction Ignore  -File -Recurse |
                Where-Object Extension -in '.svg', '.ttf', '.otf', '.t1', '.pfb'
        }

    
    foreach ($fontFile in $fontFiles) {
        if ($fontFile.Extension -notin '.svg','.ttf','.otf') {
            continue
        }
        $fontFile.pstypenames.add('Font.File')
        $fontFile
    }
    
}

