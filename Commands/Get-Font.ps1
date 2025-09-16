function Get-Font {
    <#
    .SYNOPSIS
        Gets Fonts
    .DESCRIPTION
        Gets currently installed fonts
    .EXAMPLE
        Get-Font
    #>
    param()

    # Fonts will be in different places, depending on the operating system
    $fontPaths = 
        if ($IsLinux) {
            "/usr/share/fonts"
            "~/.local/share/fonts"
        } elseif ($IsMacOS) {
            "/Library/Fonts"
            "~/Library/Fonts"
        } else {
            "$env:WinDir\Fonts"
            "$($env:AppData | 
                Split-Path | 
                Join-Path -ChildPath 'Local\Microsoft\Windows\Fonts')"
        }

    # If we have fc-list, it will be quicker and more authoritative 
    $fcList = $ExecutionContext.SessionState.invokecommand.GetCommand('fc-list', 'Application')

    # Collect all of the font files
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

    
    # Walk thru each list of collected files
    foreach ($fontFile in $fontFiles) {
        # and as long as they appear to be a font
        if ($fontFile.Extension -notin '.svg', '.ttf', '.otf', '.t1', '.pfb') {
            continue
        }
        # decorate them as a `Font.File`
        $fontFile.pstypenames.add('Font.File')
        # and output the font.
        $fontFile
    }    
}

