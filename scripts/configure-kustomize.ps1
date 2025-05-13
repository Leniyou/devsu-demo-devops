try {   
    $ErrorActionPreference = "Stop"

    $kustomizePath = "C:\tools\kustomize\kustomize.exe"

    if (-Not (Test-Path $kustomizePath)) {
    Write-Host "Kustomize no encontrado. Procediendo a instalar..."

    $url = "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv5.6.0/kustomize_v5.6.0_windows_amd64.zip"
    $tempPath = "$env:USERPROFILE\Downloads\kustomize_temp"
    New-Item -ItemType Directory -Path $tempPath -Force | Out-Null
    $zipFile = "$tempPath\kustomize.zip"

    Invoke-WebRequest -Uri $url -OutFile $zipFile
    Expand-Archive -Path $zipFile -DestinationPath $tempPath -Force

    New-Item -ItemType Directory -Path "C:\tools\kustomize\" -Force | Out-Null
    Move-Item "$tempPath\kustomize.exe" $kustomizePath -Force

    # Añadir al PATH si no está
    $env:Path += ";C:\tools\kustomize\"
    if ($envPath -notlike "*C:\tools\kustomize\*") {
        [System.Environment]::SetEnvironmentVariable("Path", "$envPath;C:\tools\kustomize\", [System.EnvironmentVariableTarget]::Machine)
        Write-Host "Ruta agregada al PATH del sistema. Puede requerir reinicio del agente."
    }

    Write-Host "✅ Kustomize instalado exitosamente."
    }
    else {
    Write-Host "Kustomize ya está instalado en $kustomizePath"
    }

    Write-Host "Confirmación de versión"
    & $kustomizePath version
} catch {
    Write-Error "❌ Error durante la ejecución del script: $($_.Exception.Message)"
    exit 1
}
