function Import-Font {
    <#
    .SYNOPSIS
        Imports Fonts
    .DESCRIPTION
        Imports a Font as a SVG font.  This allows us to easily modify the glyphs.
    #>
    param(
    # The path to the font file.
    [Parameter(Mandatory,ValueFromPipelineByPropertyName)]    
    [Alias('FullName')]
    [string]
    $FontPath
    )   
    
    begin {
        # Find font forge
        $fontForgeCommand = $ExecutionContext.SessionState.InvokeCommand.GetCommand('fontforge','Application')
        # and then find where we should put the local fonts
        $myModuleName = $MyInvocation.MyCommand.ScriptBlock.Module.Name
        if (-not $myModuleName) {
            $myModuleName = @($MyInvocation.MyCommand.Name -split '-')[-1]
        }
        $myFontsDirectory = Join-Path ([Environment]::GetFolderPath("LocalApplicationData")) $myModuleName

        # Create a queue to store imports
        $importQueue = [Collections.Queue]::new()
        # and outputs
        $outputQueue = [Collections.Queue]::new()

        # The fontForge script will always be the same
        $fontForgeScript = @(
            'Open($1)' 
            'SelectWorthOutputting()'
            'Generate($2)'
        )

        # And so will the first set of arguments to FontForge
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
        # Add each font path to the queue
        $importQueue.Enqueue($FontPath)
    }

    end {
        # Make sure font forge is installed
        if (-not $fontForgeCommand) {
            Write-Error "FontForge is not installed or in the Path"
            return
        }

        # and that the fonts directory exists
        if (-not (Test-Path $myFontsDirectory)) {
            $null = New-Item -ItemType Directory -Path $myFontsDirectory
            if (-not $?) { return }
        }

        # Write progress as we import fonts.
        $progressId = Get-Random
        $counter = 0 
        $total = $importQueue.Count
        while ($importQueue.Count) {
            $fontPath = $importQueue.Dequeue()                            
            $percentComplete = (
                $counter * 100 / $total
            )
            $counter++            
            
            # Make sure we can get the font file
            $fontFileInfo = Get-Item -Path $fontPath -ErrorAction Ignore
            if (! $fontFileInfo) { continue }            
        
            # Replace it's extension with svg
            $destinationPath = $fontFileInfo.Name.Substring(0, $fontFileInfo.Name.Length - $fontFileInfo.Extension.Length) + '.svg'
            # and determine the absolute destination path
            $destinationPath = Join-Path $myFontsDirectory $destinationPath

            # Create an array with our paths
            $pathArgs = @(            
                $FontPath
                $DestinationPath
            )

            # Call font forge with our script and paths
            & $fontForgeCommand @fontForgeArgs @pathArgs *>&1 | showProgress
            # If that worked
            if ($?) {
                # get the file
                $fontFile = Get-Item -Path $DestinationPath
                # and decorate it as a `Font.svg`
                $fontFile.pstypenames.add('Font.svg')
                $fontFile
            }            
        }

        Write-Progress "Importing fonts" "Complete!" -Completed -Id $progressId
    }
}
