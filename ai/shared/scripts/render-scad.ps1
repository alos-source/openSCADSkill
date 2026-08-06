param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile,

    [string]$OutputFile,

    [string]$Size = "800x600",

    [int]$Iteration = 0,

    [switch]$Render,

    [switch]$MultiView,

    [switch]$Highlight
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $InputFile)) {
    throw "Input file not found: $InputFile"
}

$windowsCandidates = @(
    "C:\Program Files\OpenSCAD\openscad.com",
    "$env:ProgramFiles\OpenSCAD\openscad.com",
    "C:\Program Files\Tools\openSCAD\openscad.com"
)

foreach ($candidate in $windowsCandidates) {
    if (Test-Path -LiteralPath $candidate) {
        $openscadExe = $candidate
        break
    }
}

if (-not $openscadExe) {
    $openscad = Get-Command openscad -ErrorAction SilentlyContinue
    if ($openscad) {
        $openscadExe = $openscad.Source
    }
}

if (-not $openscadExe) {
    throw "OpenSCAD was not found on PATH or at the default Windows install location."
}

$baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
$dir = Split-Path -Parent $InputFile

if (-not $OutputFile) {
    $OutputFile = Join-Path $dir ("{0}_preview.png" -f $baseName)
}

function Invoke-OpenSCADRender {
    param(
        [string]$Destination,
        [string]$Camera,
        [string]$Projection = "",
        [switch]$AutoCenter,
        [switch]$ViewAll,
        [string]$Mode = "normal"
    )

    $args = @("--imgsize", ($Size -replace "x", ","))
    if ($Camera) {
        $args += @("--camera", $Camera)
    }
    if ($Projection) {
        $args += @("--projection", $Projection)
    }
    if ($AutoCenter) {
        $args += @("--autocenter")
    }
    if ($ViewAll) {
        $args += @("--viewall")
    }
    if ($Render) {
        $args += @("--render")
    }
    $args += @("-o", $Destination, $InputFile)

    Write-Host "Rendering: $InputFile -> $Destination"
    & $openscadExe @args

    if ($Iteration -gt 0) {
        $fileName = Split-Path -Leaf $Destination
        $historyDir = Join-Path $dir ("history\iter_{0}" -f $Iteration)
        if (-not (Test-Path -LiteralPath $historyDir)) {
            New-Item -ItemType Directory -Path $historyDir -Force | Out-Null
        }
        $historyPath = Join-Path $historyDir $fileName
        Copy-Item -LiteralPath $Destination -Destination $historyPath -Force
        Write-Host "Archived iteration ${Iteration} -> $historyPath"
    }
}

if ($Highlight) {
    $highlightInput = [System.IO.Path]::ChangeExtension($InputFile, ".highlight.scad")
    if (-not (Test-Path -LiteralPath $highlightInput)) {
        Write-Host "No highlight file found: $highlightInput"
        return
    }

    if ($MultiView) {
        $isoOutput = Join-Path $dir ("{0}_preview_highlight_iso.png" -f $baseName)
        $sideOutput = Join-Path $dir ("{0}_preview_highlight_side.png" -f $baseName)
        $topOutput = Join-Path $dir ("{0}_preview_highlight_top.png" -f $baseName)
        $bottomOutput = Join-Path $dir ("{0}_preview_highlight_bottom.png" -f $baseName)
        $printBedOutput = Join-Path $dir ("{0}_preview_highlight_print_bed.png" -f $baseName)

        Invoke-OpenSCADRender -Destination $isoOutput -Camera "0,0,0,60,0,315,200" -AutoCenter -ViewAll -Mode "highlight"
        Invoke-OpenSCADRender -Destination $sideOutput -Camera "0,0,0,90,0,90,200" -AutoCenter -ViewAll -Mode "highlight"
        Invoke-OpenSCADRender -Destination $topOutput -Camera "0,0,0,0,0,0,200" -Projection "ortho" -AutoCenter -ViewAll -Mode "highlight"
        Invoke-OpenSCADRender -Destination $bottomOutput -Camera "0,0,0,180,0,0,200" -Projection "ortho" -AutoCenter -ViewAll -Mode "highlight"
        Invoke-OpenSCADRender -Destination $printBedOutput -Camera "0,0,0,120,0,315,200" -AutoCenter -ViewAll -Mode "highlight"
    }
    else {
        $highlightOutput = Join-Path $dir ("{0}_preview_highlight.png" -f $baseName)
        Invoke-OpenSCADRender -Destination $highlightOutput -Camera "" -Mode "highlight"
    }
}
elseif ($MultiView) {
    $isoOutput = Join-Path $dir ("{0}_preview_iso.png" -f $baseName)
    $sideOutput = Join-Path $dir ("{0}_preview_side.png" -f $baseName)
    $topOutput = Join-Path $dir ("{0}_preview_top.png" -f $baseName)
    $bottomOutput = Join-Path $dir ("{0}_preview_bottom.png" -f $baseName)
    $printBedOutput = Join-Path $dir ("{0}_preview_print_bed.png" -f $baseName)

    Invoke-OpenSCADRender -Destination $isoOutput -Camera "0,0,0,60,0,315,200" -AutoCenter -ViewAll
    Invoke-OpenSCADRender -Destination $sideOutput -Camera "0,0,0,90,0,90,200" -AutoCenter -ViewAll
    Invoke-OpenSCADRender -Destination $topOutput -Camera "0,0,0,0,0,0,200" -Projection "ortho" -AutoCenter -ViewAll
    Invoke-OpenSCADRender -Destination $bottomOutput -Camera "0,0,0,180,0,0,200" -Projection "ortho" -AutoCenter -ViewAll
    Invoke-OpenSCADRender -Destination $printBedOutput -Camera "0,0,0,120,0,315,200" -AutoCenter -ViewAll
}
else {
    Invoke-OpenSCADRender -Destination $OutputFile -Camera ""
}
