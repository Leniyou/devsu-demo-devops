Param (
    [Parameter( Mandatory = $True )][string]$Env,
    [Parameter( Mandatory = $True )][string]$Version,
    [Parameter( Mandatory = $True )][string]$Email,
    [Parameter( Mandatory = $True )][string]$User
)
try {

    $Branch = $env:BUILD_SOURCEBRANCHNAME

    Write-Host "# -- PARÁMETROS -- #"
    Write-Host  "Env: ${Env}"
    Write-Host  "Version: ${Version}"
    Write-Host "Email: ${Email}"
    Write-Host  "User: ${User}"
    Write-Host  "Branch: ${Branch}"

    Install-Module -Name powershell-yaml -Force
    Import-Module powershell-yaml

    Set-Location .\k8s\devsu-demo-devops-nodejs\overlays\${Env}\

    Write-Host "Git global config"
    # Git settings
    git config --global credential.useHttpPath true
    git config user.email $email
    git config user.name $autor

    git fetch origin
    git checkout $Branch
    git pull origin $Branch --rebase

    C:\tools\kustomize\kustomize.exe edit set image devsu-demo-devops-nodejs=docker.io/leniyou/devsu-demo-devops-nodejs:${Version}

    Write-Host "Validando estado con 'git status'"
    git status

    Write-Host "Agregando cambios con 'git add .'"
    git add .

    Write-Host "Actualizando version con 'git commit'"
    git commit -am "ci: Version actualizada -> devsu-demo-devops-nodejs:${Version} [skip ci]"

    Write-Host "Subiendo cambios con 'git push'"
    git push origin $Branch

    Write-Host "Cambios agregados correctamente"
} catch {
    Write-Error "❌ Error durante la ejecución del script: $($_.Exception.Message)"
    exit 1
}
