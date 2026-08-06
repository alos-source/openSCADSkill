param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile,

    [string]$OutputFile
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $InputFile)) {
    throw "Input file not found: $InputFile"
}

$openscad = Get-Command openscad -ErrorAction SilentlyContinue
$openscadExe = $null

if ($openscad) {
    $openscadExe = $openscad.Source
}
else {
    $windowsCandidates = @(
        "C:\Program Files\OpenSCAD\openscad.com",
        "$env:ProgramFiles\OpenSCAD\openscad.com"
    )

    foreach ($candidate in $windowsCandidates) {
        if (Test-Path -LiteralPath $candidate) {
            $openscadExe = $candidate
            break
        }
    }
}

if (-not $openscadExe) {
    throw "OpenSCAD was not found on PATH or at the default Windows install location."
}

if (-not $OutputFile) {
    $OutputFile = [System.IO.Path]::ChangeExtension($InputFile, ".stl")
}

$args = @("--export-format", "binstl", "-o", $OutputFile, $InputFile)

Write-Host "Exporting: $InputFile -> $OutputFile"
& $openscadExe @args
