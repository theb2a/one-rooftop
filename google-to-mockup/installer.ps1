# ============================================================
#  Packager le skill google-to-mockup en fichier .skill
#  → Double-cliquer ou "Exécuter avec PowerShell"
# ============================================================

$skillFolderName = "google-to-mockup"
$scriptDir       = Split-Path -Parent $MyInvocation.MyCommand.Path
$parentDir       = Split-Path -Parent $scriptDir
$outputFile      = Join-Path $parentDir "$skillFolderName.skill"

Write-Host ""
Write-Host "  TheB2ATeK — Packaging du skill" -ForegroundColor Cyan
Write-Host "  ================================" -ForegroundColor Cyan

# Supprimer l'ancien fichier si existant
if (Test-Path $outputFile) {
    Remove-Item $outputFile -Force
    Write-Host "  Ancien fichier supprimé." -ForegroundColor DarkGray
}

# Créer un dossier temp avec seulement les fichiers du skill (pas installer.ps1)
$tempDir = Join-Path $env:TEMP "skill_build_$(Get-Random)"
New-Item -ItemType Directory -Path $tempDir | Out-Null
$tempSkillDir = Join-Path $tempDir $skillFolderName
New-Item -ItemType Directory -Path $tempSkillDir | Out-Null

# Copier uniquement SKILL.md (et les éventuels sous-dossiers scripts/, assets/, references/)
Get-ChildItem -Path $scriptDir -Recurse | Where-Object {
    $_.Name -ne "installer.ps1" -and $_.Name -ne "*.skill"
} | ForEach-Object {
    $relativePath = $_.FullName.Substring($scriptDir.Length + 1)
    $destPath = Join-Path $tempSkillDir $relativePath
    if ($_.PSIsContainer) {
        New-Item -ItemType Directory -Path $destPath -Force | Out-Null
    } else {
        $destFolder = Split-Path -Parent $destPath
        if (-not (Test-Path $destFolder)) {
            New-Item -ItemType Directory -Path $destFolder -Force | Out-Null
        }
        Copy-Item -Path $_.FullName -Destination $destPath
        Write-Host "  + $relativePath" -ForegroundColor DarkGreen
    }
}

# Créer le zip .skill
Compress-Archive -Path "$tempSkillDir\*" -DestinationPath $outputFile -Force

# Nettoyage
Remove-Item $tempDir -Recurse -Force

Write-Host ""
Write-Host "  ✅ Skill packagé avec succès !" -ForegroundColor Green
Write-Host "  📦 Fichier : $outputFile" -ForegroundColor Yellow
Write-Host ""
Write-Host "  INSTALLATION dans Cowork :" -ForegroundColor Cyan
Write-Host "  1. Ouvrez Cowork" -ForegroundColor White
Write-Host "  2. Allez dans Settings > Plugins > Install skill" -ForegroundColor White
Write-Host "  3. Sélectionnez le fichier google-to-mockup.skill" -ForegroundColor White
Write-Host "  4. Le skill est disponible dans tous vos projets !" -ForegroundColor White
Write-Host ""

# Ouvrir le dossier parent pour accès facile au .skill
explorer.exe $parentDir

Write-Host "  Appuyez sur une touche pour fermer..."
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
