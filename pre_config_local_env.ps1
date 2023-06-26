# Parámetros del script
param(
    [Parameter(Mandatory=$true)]
    [string]$pat
)

# Comprueba si el módulo Az está instalado
if (!(Get-Module -ListAvailable -Name Az)) {
    Write-Output "El módulo Az no está instalado. Instalándolo ahora..."
    Install-Module -Name Az -Scope CurrentUser -Force
    Import-Module Az
} else {
    Write-Output "El módulo Az ya está instalado."
}

# Comprueba si la extensión azure-devops está instalada
$installedExtensions = az extension list --output json | ConvertFrom-Json
if ($installedExtensions.name -notcontains "azure-devops") {
    Write-Output "La extensión azure-devops no está instalada. Instalándola ahora..."
    az extension add --name azure-devops
} else {
    Write-Output "La extensión azure-devops ya está instalada."
}

# Autenticarse con Azure
az login

# Autenticarse con Azure DevOps
# NOTA: Necesitarás ingresar el PAT de manera interactiva, ya que az devops login no soporta pasar el PAT directamente.
echo $pat | az devops login

# Crear una copia de terraform.tfvars
if (Test-Path -Path .\terraform.tfvars) {
    Copy-Item -Path .\terraform.tfvars -Destination .\terraform_private.tfvars
} else {
    Write-Error "El archivo terraform.tfvars no existe en el directorio actual."
}
