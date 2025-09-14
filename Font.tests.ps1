describe Font {
    it 'Gets fonts' {
        Get-Font
    }

    it 'Can import a font' {
        $importedFont = Get-Font | Get-Random | Import-Font
        $importedFont.FontFamily | Should -BeLike '*'
        $importedFont.UnitsPerEm | Should -BeGreaterThan 0
    }
}
