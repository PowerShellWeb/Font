function Export-Font {
    param(    
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]
    [Alias('FullName')]
    [string]
    $FontPath,

    [string]
    $DestinationPath
    )


    begin {
        $fontForgeCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand('fontforge','Application')
    
        $progressId = Get-Random
        $outputQueue = [Collections.Queue]::new()
        filter showProgress {
            $output = $_
            Write-Progress -Id $progressId "$line " "$fontPath "
            $outputQueue.Enqueue($output)            
        }
    }

    process {
        $fontFile = Get-Item -Path $FontPath

        if (-not $PSBoundParameters.DestinationPath) {
            $destinationPath = $PSBoundParameters.DestinationPath = "./$($($fontFile | Split-Path -Leaf))"
        }

        if ($DestinationPath -like '*.*' -and 
            $DestinationPath -notlike '*.zip'
        ) {
            
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

            Get-Item -Path $DestinationPath
        } else {
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
            Get-Item -Path .
            Pop-Location
        }
    }
    end {
        Write-Progress -id $progressId -Completed
    }
}
