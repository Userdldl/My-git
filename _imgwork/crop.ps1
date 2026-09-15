Add-Type -AssemblyName System.Drawing

$dir = "C:\Users\dong\OneDrive\Desktop\git\_imgwork"
$img = [System.Drawing.Image]::FromFile("$dir\src.png")
Write-Output ("size: {0} x {1}" -f $img.Width, $img.Height)

function Crop-Scale {
    param([string]$Name, [int]$X, [int]$Y, [int]$W, [int]$H, [int]$Scale)
    $rect = [System.Drawing.Rectangle]::new($X, $Y, $W, $H)
    $bigW = $W * $Scale
    $bigH = $H * $Scale
    $big = [System.Drawing.Bitmap]::new($bigW, $bigH)
    $g = [System.Drawing.Graphics]::FromImage($big)
    $g.InterpolationMode = [System.Drawing.Drawing2D.InterpolationMode]::HighQualityBicubic
    $dest = [System.Drawing.Rectangle]::new(0, 0, $bigW, $bigH)
    $g.DrawImage($img, $dest, $rect, [System.Drawing.GraphicsUnit]::Pixel)
    $g.Dispose()
    $path = Join-Path $dir ("crop_{0}.png" -f $Name)
    $big.Save($path, [System.Drawing.Imaging.ImageFormat]::Png)
    $big.Dispose()
    Write-Output ("{0}: {1}x{2} -> {3}x{4}" -f $Name, $W, $H, $bigW, $bigH)
}

Crop-Scale -Name "ball"   -X 0   -Y 600  -W 430 -H 470 -Scale 2
Crop-Scale -Name "knot"   -X 380 -Y 920  -W 570 -H 340 -Scale 2
Crop-Scale -Name "tassel" -X 150 -Y 1080 -W 700 -H 320 -Scale 2
Crop-Scale -Name "corner" -X 0   -Y 0    -W 250 -H 190 -Scale 3

$img.Dispose()
Get-ChildItem $dir -Filter "crop_*.png" | Select-Object Name, Length
