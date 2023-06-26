# Comprobar si el directorio actual es un directorio de trabajo de Terraform inicializado
if (!(Test-Path -Path .\.terraform)) {
    Write-Output "El directorio de trabajo de Terraform no está inicializado. Inicializando ahora..."
    terraform init
} else {
    Write-Output "El directorio de trabajo de Terraform ya está inicializado. Actualizando los módulos..."
    terraform get -update
}

# Realizar un plan con el fichero de variables terraform_private.tfvars
if (Test-Path -Path .\terraform_private.tfvars) {
    Write-Output "Realizando el plan de Terraform..."
    terraform plan -var-file="terraform_private.tfvars" -out="tfplan"
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Terraform plan falló con el código de salida: $LASTEXITCODE"
        exit
    }
} else {
    Write-Error "El archivo terraform_private.tfvars no existe en el directorio actual."
    exit
}

# Solicitar la confirmación del usuario antes de aplicar el plan
Write-Output "Presiona enter para continuar con la aplicación del plan de Terraform..."
$null = Read-Host

# Realizar un APPLY con intervención manual
Write-Output "Aplicando el plan de Terraform. Esta acción requerirá confirmación manual..."
terraform apply "tfplan"
if ($LASTEXITCODE -ne 0) {
    Write-Error "Terraform apply falló con el código de salida: $LASTEXITCODE"
}
