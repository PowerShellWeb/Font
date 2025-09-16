## Font 0.1

* Initial Release of Font Module (#1)
* Core Commands:
  * Get-Font (#2)
  * Export-Font (#3)
  * Import-Font (#4)
* Extended Types
  * `Font.File`
    * `get_FamilyName` (#5)
  * `Font.svg`
    * `get_FontFace` (#7)
    * `get_FontStyle` (#8)
    * `get/set_FamilyName` (#9)
    * `get_FontWeight` (#10)
    * `get_BoundingBox` (#11)
    * `get_UnitsPerEm` (#12)
    * `get_Descent` (#13)
    * `get_Ascent` (#14)
    * `GetGlyph()` (#15)
    * `get_XML` (#17)
    * `get/set_ID` (#28)
  * `Font.Glyph`
    * `get_SVG` (#18)
    * `get_PathData` (#19)
    * `get_Outline` (#20)
    * `get_Motion` (#21)
    * `.Save()` (#27)
    * `.ToString()` (#30)
* Docs
  * `README` (#22)
  * `CONTRIBUTING.md` (#23)
  * `CODE_OF_CONDUCT.md` (#24)
  * `SECURITY.md` (#25)
  * `FUNDING.yml` (#29)  
* `Font` GitHub Action (#26)