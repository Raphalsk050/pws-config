<# 
    Script: setup.ps1
    Descrição: Instala o Chocolatey (se necessário), Git, posh-git, oh-my-posh, Nerd Fonts Fira Code e o Windows Terminal (opcional) via Chocolatey.
    Em seguida, configura o perfil do PowerShell para carregar os módulos e definir o tema do prompt.
    
    Atenção:
    - Execute este script como Administrador.
    - Caso já possua alguma dessas ferramentas, o Chocolatey fará as verificações necessárias.
    - Após a execução, reinicie seu terminal para que as alterações no perfil sejam aplicadas.
#>

# Verifica se o script está sendo executado como Administrador
if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Error "Este script precisa ser executado como Administrador. Reinicie o PowerShell como Administrador e execute novamente."
    exit 1
}

Write-Output "===== Iniciando o processo de setup ====="

# Instala o Chocolatey se não estiver instalado
if (-not (Get-Command choco -ErrorAction SilentlyContinue)) {
    Write-Output "Chocolatey não encontrado. Instalando Chocolatey..."
    Set-ExecutionPolicy Bypass -Scope Process -Force
    [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072
    iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    Write-Output "Chocolatey instalado com sucesso."
} else {
    Write-Output "Chocolatey já está instalado."
}

# Aguarda alguns segundos para garantir que o choco esteja disponível
Start-Sleep -Seconds 5

# Instalação dos pacotes via Chocolatey
Write-Output "Instalando Git..."
choco install git -y

Write-Output "Instalando posh-git..."
choco install poshgit -y

Write-Output "Instalando oh-my-posh..."
choco install oh-my-posh -y

Write-Output "Instalando Nerd Fonts JetBrains Mono..."
choco install nerd-fonts-jetbrains-mono -y

Write-Output "Instalando a versão mais recente do Windows PowerShell (opcional)..."
choco install powershell -y

# Configuração do perfil do PowerShell
Write-Output "Configurando o perfil do PowerShell..."

# Cria o diretório do perfil, se necessário
$profileDir = Split-Path -Parent $PROFILE
if (-not (Test-Path $profileDir)) {
    New-Item -ItemType Directory -Path $profileDir -Force | Out-Null
}

# Cria o arquivo de perfil se ele ainda não existir
if (-not (Test-Path $PROFILE)) {
    New-Item -Type File -Path $PROFILE -Force | Out-Null
    Write-Output "Arquivo de perfil criado em: $PROFILE"
}

# Conteúdo a ser adicionado ao final do perfil
$profileContent = @"
# Configurações adicionadas pelo setup.ps1
Import-Module posh-git
Import-Module oh-my-posh

# Define o tema do prompt (substitua 'montys' pelo tema de sua preferência)
Set-PoshPrompt -Theme montys

# Configuração do autocomplete (caso não esteja ativo)
Set-PSReadLineKeyHandler -Key Tab -Function Complete
"@

# Verifica se as configurações já foram adicionadas (buscando pela importação do posh-git)
if (-not (Select-String -Path $PROFILE -Pattern "Import-Module posh-git" -Quiet)) {
    Add-Content -Path $PROFILE -Value $profileContent
    Write-Output "Configurações adicionadas ao perfil: $PROFILE"
} else {
    Write-Output "O perfil já contém as configurações necessárias. Nenhuma alteração foi feita."
}

Write-Output "===== Setup concluído! ====="
Write-Output "Reinicie o PowerShell ou o Windows Terminal para aplicar as alterações."
