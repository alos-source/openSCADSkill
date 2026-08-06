param(
    [Parameter(Mandatory = $true)]
    [string]$InputFile
)

$ErrorActionPreference = "Stop"

if (-not (Test-Path -LiteralPath $InputFile)) {
    throw "Input file not found: $InputFile"
}

$dir = Split-Path -Parent $InputFile
$baseName = [System.IO.Path]::GetFileNameWithoutExtension($InputFile)
$outputPath = Join-Path $dir ("{0}_validation.txt" -f $baseName)

$content = @(
    "Model validation checklist",
    "==========================",
    "- Geometry reviewed: [ ]",
    "- Preview checked: [ ]",
    "- Overhangs acceptable: [ ]",
    "- Supports avoided where possible: [ ]",
    "- Printed successfully: [ ]",
    "- Notes:"
)

Set-Content -Path $outputPath -Value $content
Write-Host "Validation checklist written to $outputPath"
