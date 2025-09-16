function Export-Font {
    <#
    .SYNOPSIS
        Exports Fonts
    .DESCRIPTION
        Exports a font in any format supported by FontForge.
    #>
    param(
    # The path to a font file.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]
    $FontPath,

    # The destination path.
    # If this is not provided, all glyphs will be extracted to a local directory with the same name as the font.
    [Alias('Destination')]
    [string]
    $DestinationPath
    )


    begin {
        # Find FontForge
        $fontForgeCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand('fontforge','Application')
    
        # and prepare to write progress
        $progressId = Get-Random
        $outputQueue = [Collections.Queue]::new()
        filter showProgress {
            $output = $_
            Write-Progress -Id $progressId "$line " "$fontPath "
            Write-Verbose $output
            $outputQueue.Enqueue($output)
        }
    }

    process {
        # If there's no font forge, there's not exporting or importing
        if (-not $fontForgeCommand) {
            Write-Error "FontForge is not installed or in the Path"
            return
        }

        $fontFile = Get-Item -Path $FontPath

        if (-not $PSBoundParameters.DestinationPath) {
            $destinationPath = $PSBoundParameters.DestinationPath = "./$($($fontFile | Split-Path -Leaf))"
        }

        # If we are outputting to a file, and it is not a .zip
        if ($DestinationPath -like '*.*' -and 
            $DestinationPath -notlike '*.zip'
        ) {
            # we will try to trust that it is a file FontForge can generate
            $fontForgeArgs = @(                
                '-lang=ff'                                
                '-c'
                @(
                    'Open($1)' 
                    'SelectWorthOutputting()'
                    'Generate($2)'
                ) -join ';'
                $FontPath
                $DestinationPath
            )
            & $fontForgeCommand @fontForgeArgs *>&1 | showProgress

            $exportedFontFile = Get-Item -Path $DestinationPath
            if ($exportedFontFile.Extension -eq '.svg') {
                $exportedFontFile.pstypenames.add('Font.svg')
            }
            $exportedFontFile.pstypenames.add('Font.File')
            $exportedFontFile
        } else {
            $isZip = $DestinationPath -like '*.zip'
            if ($isZip) {
                $DestinationPath = $DestinationPath -replace '\.zip$'
            }
            $exists = Get-Item -Path $DestinationPath -ErrorAction Ignore
            if (-not $exists) {
                $exists = New-Item -ItemType Directory -Path $DestinationPath -Force
            }
            if ($exists -is [IO.FileInfo]) {
                return
            }
            Push-Location $exists.FullName
            $fontForgeArgs = @(
                '-lang=ff'                
                '-c'
                @(
                    'Open($1)' 
                    'SelectWorthOutputting()'
                    'foreach Export("svg")'
                    'endloop'
                ) -join ';'

                $FontPath
            )            
            
            & $fontForgeCommand @fontForgeArgs *>&1  | showProgress

            if ($isZip) {
                Compress-Archive -Path . -DestinationPath ($DestinationPath + '.zip')
                Get-Item -LiteralPath ($DestinationPath + '.zip')
            } else {
                Get-Item -Path .
            }
            
            Pop-Location
        }
    }
    end {
        Write-Progress -id $progressId -Completed
    }
}
