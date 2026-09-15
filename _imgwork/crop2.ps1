Add-Type -AssemblyName System.Drawing

$dir = "C:\Users\dong\OneDrive\Desktop\git\_imgwork"
$img = [System.Drawing.Image]::FromFile("$dir\src.png")

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
    Write-Output ("{0}: {1}x{2}" -f $Name, $bigW, $bigH)
}

# left flank of the ball (looking for a lining / seam / opening)
Crop-Scale -Name "ball_left"  -X 0   -Y 620 -W 230 -H 400 -Scale 4
# right side, where cord attaches and flat paddle strips overlap
Crop-Scale -Name "ball_right" -X 170 -Y 640 -W 270 -H 440 -Scale 4
# where the cord leaves the ball
Crop-Scale -Name "ball_exit"  -X 190 -Y 830 -W 300 -H 260 -Scale 4

$img.Dispose()
