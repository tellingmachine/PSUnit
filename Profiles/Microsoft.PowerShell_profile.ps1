# PSUnit: Setting the console output window size and color
$a = (Get-Host).UI.RawUI
$b = $a.BufferSize
$b.Width = 205
$b.Height = 80
$a.BufferSize = $b

$b = $a.WindowSize
$b.Width = 205
$b.Height = 80
$a.WindowSize = $b

$a.BackgroundColor = "Black"
$a.ForegroundColor = "DarkGreen"
