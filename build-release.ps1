param(
    [string]$Version = ""
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
Set-Location $root

$msbuild = "C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin\MSBuild.exe"
if (-not (Test-Path $msbuild)) {
    $vswhere = "${env:ProgramFiles(x86)}\Microsoft Visual Studio\Installer\vswhere.exe"
    if (Test-Path $vswhere) {
        $msbuild = & $vswhere -latest -requires Microsoft.Component.MSBuild -find "MSBuild\**\Bin\MSBuild.exe"
    }
}
if (-not (Test-Path $msbuild)) { throw "MSBuild not found" }

Write-Host "[1/4] Restore"
& $msbuild WinMemoryCleaner.sln /t:Restore /p:Configuration=Release /v:minimal /nologo
if ($LASTEXITCODE -ne 0) { throw "Restore failed" }

Write-Host "[2/4] Build Release"
& $msbuild WinMemoryCleaner.sln /t:Rebuild /p:Configuration=Release /p:Platform="Any CPU" /v:minimal /nologo
if ($LASTEXITCODE -ne 0) { throw "Build failed" }

$exe = "bin\Release\WinMemoryCleaner.exe"
if (-not (Test-Path $exe)) { throw "Build output missing: $exe" }

if (-not $Version) {
    $fv = (Get-Item $exe).VersionInfo.FileVersion
    $Version = ($fv -split '\.')[0..2] -join '.'
}
Write-Host "Version: $Version"

$stage = "release\WinMemoryCleaner-v$Version-portable"
$zip = "release\WinMemoryCleaner-v$Version-portable.zip"

Write-Host "[3/4] Stage"
if (Test-Path $stage) { Remove-Item -Recurse -Force $stage }
New-Item -ItemType Directory -Force -Path $stage | Out-Null
Copy-Item $exe $stage
if (Test-Path "README.md") { Copy-Item "README.md" $stage }

Write-Host "[4/4] Zip"
if (Test-Path $zip) { Remove-Item $zip }
Compress-Archive -Path "$stage\*" -DestinationPath $zip -CompressionLevel Optimal

$hash = (Get-FileHash $zip -Algorithm SHA256).Hash
$size = (Get-Item $zip).Length

Write-Host ""
Write-Host "DONE" -ForegroundColor Green
Write-Host "  zip:    $zip"
Write-Host "  size:   $size bytes"
Write-Host "  sha256: $hash"
