function Import-Font {
    param(
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]    
    [Alias('FullName')]
    [string]
    $FontPath
    )   
    
    begin {
        $fontForgeCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand('fontforge','Application')
        $myModuleName = $MyInvocation.MyCommand.ScriptBlock.Module.Name
        if (-not $myModuleName) {
            $myModuleName = @($MyInvocation.MyCommand.Name -split '-')[-1]
        }
        $myFontsDirectory = Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) $myModuleName

        $importQueue = [Collections.Queue]::new()
        $outputQueue = [Collections.Queue]::new()

        $fontForgeScript = @(
            'Open($1)' 
            'SelectWorthOutputting()'
            'Generate($2)'
        )

        $fontForgeArgs = @(
            '-lang=ff'
            
            '-c'

            $fontForgeScript -join ';'
        )
        filter showProgress {
            $output = $_
            Write-Progress -Id $progressId "Importing Fonts $fontPath" "$line " -PercentComplete $percentComplete
            Write-Verbose $output
            $outputQueue.Enqueue($output)            
        }
    }

    process {
        $importQueue.Enqueue($FontPath)
    }

    end {
        $progressId = Get-Random
        $counter = 0 
        $total = $importQueue.Count
        while ($importQueue.Count) {
            $fontPath = $importQueue.Dequeue()                            
            $percentComplete = (
                $counter * 100 / $total
            )
            $counter++            
            
            $fontFileInfo = Get-Item -Path $fontPath -ErrorAction Ignore
            if (! $fontFileInfo) { continue }

            if (-not (Test-Path $myFontsDirectory)) {
                $null = New-Item -ItemType Directory -Path $myFontsDirectory
                if (-not $?) { continue }
            }
        
            $destinationPath = $fontFileInfo.Name.Substring(0, $fontFileInfo.Name.Length - $fontFileInfo.Extension.Length) + '.svg'
            $destinationPath = Join-Path $myFontsDirectory $destinationPath

            $pathArgs = @(            
                $FontPath
                $DestinationPath
            )

            & $fontForgeCommand @fontForgeArgs @pathArgs *>&1 | showProgress
            if ($?) {
                $fontFile = Get-Item -Path $DestinationPath
                $fontFile.pstypenames.add('Font.svg')
                $fontFile
            }
            
        }

        Write-Progress "Importing fonts" "Complete!" -Completed -Id $progressId

    }
}
