# Script para configurar o Oh My Posh e ajustar a tecla Tab no PowerShell

# Instalar Oh My Posh (se necessário)
if (-not (Get-Command "Set-PoshPrompt" -ErrorAction SilentlyContinue)) {
    Write-Host "Instalando o Oh My Posh..." -ForegroundColor Green
    Install-Module -Name "OhMyPosh" -Force -SkipPublisherCheck
} else {
    Write-Host "Oh My Posh já está instalado." -ForegroundColor Yellow
}

# Instalar o PSReadLine (se necessário)
if (-not (Get-Module -Name PSReadLine -ListAvailable)) {
    Write-Host "Instalando o PSReadLine..." -ForegroundColor Green
    Install-Module -Name PSReadLine -Force -SkipPublisherCheck
} else {
    Write-Host "PSReadLine já está instalado." -ForegroundColor Yellow
}

# Adicionar o comando no perfil do PowerShell
$profilePath = $PROFILE

if (-not (Test-Path $profilePath)) {
    Write-Host "Criando o perfil do PowerShell..." -ForegroundColor Green
    New-Item -Path $profilePath -ItemType File -Force
}

# Adicionando as configurações ao perfil
$profileContent = @"
# Carregar o Oh My Posh
Import-Module oh-my-posh
Set-PoshPrompt -Theme montys   # Troque 'montys' por outro tema, se desejar

# Configurar a tecla Tab para autocompletar
Set-PSReadLineKeyHandler -Key Tab -Function Complete
"@

Add-Content -Path $profilePath -Value $profileContent

Write-Host "Configurações aplicadas. Para que as mudanças tenham efeito, reinicie o PowerShell." -ForegroundColor Cyan
