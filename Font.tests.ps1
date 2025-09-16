describe Font {
    it 'Gets fonts' {
        $installedFonts = Get-Font 
        $installedFonts.Count | Should -BeGreaterThan 1        
    }

    it 'Can import a font' {
        $importedFont = Get-Font | Get-Random | Import-Font
        $importedFont.FontFamily | Should -BeLike '*'
        $importedFont.UnitsPerEm | Should -BeGreaterThan 0
    }    
}
