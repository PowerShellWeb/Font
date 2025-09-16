$fontFace = $this.ParentNode.'font-face'
$descent = $fontFace.descent -as [double]
$bbox = $fontFace.bbox -split '\s' -as [double[]]
$viewbox = "0 $($bbox[-3] - $descent) $($bbox[-2]) $($bbox[-1])"
@("<svg xmlns='http://www.w3.org/2000/svg' viewBox='$viewbox' width='100%' height='100%' transform='scale(1 -1)'>"

"<path stroke='currentColor' fill='transparent' d='$($this.PathData)' />"
"</svg>") -as [xml]