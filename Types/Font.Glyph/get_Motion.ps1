$fontFace = $this.ParentNode.'font-face'
$descent = $fontFace.descent -as [double]
$viewbox = $fontFace.bbox -split '\s' -as [double[]]
$PathData = $this.PathData
@(
    "<svg xmlns='http://www.w3.org/2000/svg' viewBox='$viewbox' width='100%' height='100%' transform='scale(1 -1)'>"
    "<path stroke='currentColor' fill='transparent' d='$($PathData)'  />"
@"
<circle r="5" fill="currentColor">
    <animateMotion
      dur="10s"
      repeatCount="indefinite"
      path="$($PathData)" />
  </circle>
"@
    "</svg>"
) -as [xml]

