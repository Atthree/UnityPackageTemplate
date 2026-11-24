<#
.SYNOPSIS
  Şablondan yeni bir Unity (UPM) paketi oluşturur.

.EXAMPLE
  .\new-package.ps1 -Name VehiclePhysics -DisplayName "Vehicle Physics" -Description "Raycast car physics."

  Oluşturur:  ..\VehiclePhysics\
    package.json       name = com.atthree.vehicle-physics
    Runtime/           Atthree.VehiclePhysics.asmdef
    Editor/            Atthree.VehiclePhysics.Editor.asmdef
    Tests/Runtime/     Atthree.VehiclePhysics.Tests.asmdef + örnek test
    README / CHANGELOG / LICENSE, git deposu ve ilk commit.

.EXAMPLE
  .\new-package.ps1 -Name SaveSystem -DisplayName "Save System" -Description "..." -Namespace Atthree.Saving -GitHub

  -GitHub: GitHub'da herkese açık repo açar ve push eder (gh CLI gerekir).
#>
param(
    [Parameter(Mandatory = $true)] [string] $Name,          # PascalCase, ör. VehiclePhysics (klasör + repo adı)
    [Parameter(Mandatory = $true)] [string] $DisplayName,   # Package Manager'da görünen ad
    [Parameter(Mandatory = $true)] [string] $Description,
    [string] $Author = "Atthree",                            # GitHub kullanıcı adı
    [string] $Namespace = "",                                # boşsa: <Author>.<Name>
    [string] $PackageId = "",                                # boşsa: com.<author>.<name-kebab>
    [string] $Unity = "6000.0",
    [string] $OutDir = "",                                   # boşsa: şablonun yanında <Name> klasörü
    [switch] $GitHub
)

$ErrorActionPreference = "Stop"

function ConvertTo-Kebab([string] $s) {
    # VehiclePhysics -> vehicle-physics
    return ([regex]::Replace($s, '(?<=[a-z0-9])([A-Z])', '-$1')).ToLower()
}

if ($Name -notmatch '^[A-Z][A-Za-z0-9]+$') { throw "Name PascalCase olmalı (ör. VehiclePhysics)." }
if ($Namespace -eq "") { $Namespace = "$Author.$Name" }
if ($PackageId -eq "") { $PackageId = "com.$($Author.ToLower()).$(ConvertTo-Kebab $Name)" }
if ($OutDir -eq "") { $OutDir = Join-Path (Split-Path $PSScriptRoot -Parent) $Name }

$templateDir = Join-Path $PSScriptRoot "template"
if (Test-Path $OutDir) { throw "Klasör zaten var: $OutDir" }

$tokens = @{
    "__PACKAGE_ID__"   = $PackageId
    "__DISPLAY_NAME__" = $DisplayName
    "__DESCRIPTION__"  = $Description
    "__NAMESPACE__"    = $Namespace
    "__REPO_NAME__"    = $Name
    "__AUTHOR__"       = $Author
    "__UNITY__"        = $Unity
    "__YEAR__"         = (Get-Date).Year.ToString()
    "__DATE__"         = (Get-Date).ToString("yyyy-MM-dd")
}

function Expand-Tokens([string] $text) {
    foreach ($key in $tokens.Keys) { $text = $text.Replace($key, $tokens[$key]) }
    return $text
}

$utf8NoBom = New-Object System.Text.UTF8Encoding($false)

Get-ChildItem $templateDir -Recurse -File -Force | ForEach-Object {
    $relative = $_.FullName.Substring($templateDir.Length + 1)
    $target = Join-Path $OutDir (Expand-Tokens $relative)
    New-Item -ItemType Directory -Force (Split-Path $target -Parent) | Out-Null
    $content = [System.IO.File]::ReadAllText($_.FullName)
    [System.IO.File]::WriteAllText($target, (Expand-Tokens $content), $utf8NoBom)
}

Push-Location $OutDir
try {
    git init -q -b main
    git add -A
    git commit -q -m "Initial package scaffold ($PackageId)"
    if ($GitHub) {
        gh repo create "$Author/$Name" --public --source . --description $Description --push
    }
}
finally { Pop-Location }

Write-Host ""
Write-Host "Paket oluşturuldu: $OutDir" -ForegroundColor Green
Write-Host "  Paket adı : $PackageId"
Write-Host "  Namespace : $Namespace"
Write-Host ""
Write-Host "Oyun projene bağlamak için Packages/manifest.json içine ekle:"
Write-Host "  `"$PackageId`": `"file:<bu klasörün yolu>`","
Write-Host "Testleri görmek için aynı dosyaya:"
Write-Host "  `"testables`": [ `"$PackageId`" ]"
