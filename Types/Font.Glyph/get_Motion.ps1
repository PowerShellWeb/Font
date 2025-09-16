$fontFace = $this.ParentNode.'font-face'
$descent = $fontFace.descent -as [double]
$bbox = $fontFace.bbox -split '\s' -as [double[]]
$viewbox = "0 $($bbox[-3] - $descent) $($bbox[-2]) $($bbox[-1])"
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

