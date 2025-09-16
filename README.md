# Font

Manage and Manipulate fonts with PowerShell

With the Font module, you can:

* `Get-Font` - Get Installed Fonts
* `Export-Font` - Export a font to various formats
* `Import-Font` - Import a font as SVG

We can always get installed fonts.

To Export and Import fonts, we need to install [FontForge](https://fontforge.org/), and ensure it is loaded in the path.

## Fonts 101

Fonts are fun!

Fonts are a series of symbols, often used to represent text.

Each symbol in a font is called a `Glyph`.

All of the glyphs in a font are called the `Font Face`.

Fonts with similar faces (and often similar designers) are called a `Font Family`.

The Font module is designed to help you work with fonts.  

It allows you to import and export fonts, get specific glyphs, and edit a typeface.


### Installing the Font Module

~~~PowerShell
# Install the Font Module from the PowerShell Gallery
Install-Module Font 
~~~

~~~PowerShell
# Import the font module
Import-Module Font 
~~~

#### Cloning and Importing

You can also clone the repository and import the module

~~~PowerShell

git clone https://github.com/PowerShellWeb/Font
cd ./Font
Import-Module ./ -Force -PassThru

~~~

### Font GitHub Action

The Font module has a GitHub action, and can be run in a workflow.

To use the font action, simply refer to this repository:

~~~yaml
- name: BuildFont
  uses: PowerShellWeb/Font@main
~~~

Any file named `*.font.ps1` will be executed.  

Any outputted files will be checked in.

## Basic Examples

~~~PowerShell
# Import a random font
$importRandomFont = Get-Font | Get-Random | Import-Font

# Get the bounding box
$importRandomFont.BoundingBox

# Get the glyph for 'p' and get it's path data
$importRandomFont.GetGlyph("P").d
# We can change the path by setting 'd'
# Font glyphs are drawn "upside-down", and should fit within the bounding box.
~~~

For more examples, see the [Examples directory](./Examples/)