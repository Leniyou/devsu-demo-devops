try { 
    # Configuración
    $packageJsonPath = "package.json"
    $changelogPath = "CHANGELOG.md"
    $branch = $env:BUILD_SOURCEBRANCHNAME
    $autor = $env:BUILD_REQUESTEDFOR
    $email = $env:BUILD_REQUESTEDFOREMAIL

    # Leer versión actual desde package.json
    $packageJson = Get-Content $packageJsonPath | ConvertFrom-Json
    $currentVersion = $packageJson.version

    Write-Host "La version actual del proyecto es: '$currentVersion'"

    # Obtener último mensaje de commit
    $lastCommitMessage = git log -1 --pretty=%B

    # Determinar tipo de incremento
    if ($lastCommitMessage -match "major") {
        $type = "major"
    } elseif ($lastCommitMessage -match "minor") {
        $type = "minor"
    } elseif ($lastCommitMessage -match "patch") {
        $type = "patch"
    } else {
        $type = "default"
    }

    # Función para incrementar versión semántica
    function Get-NewVersion {
        param (
            [string]$currentVersion,
            [string]$incrementType
        )

        $versionParts = $currentVersion -split "\." 
        $major = [int]$versionParts[0]
        $minor = [int]$versionParts[1]
        $patch = [int]($versionParts[2] -split "-")[0]  # Ignora sufijos

        switch ($incrementType.ToLower()) {
            "major" { $major++; $minor = 0; $patch = 0 }
            "minor" { $minor++; $patch = 0 }
            "patch" { $patch++ }
            default { $patch++ }
        }

        return "$major.$minor.$patch"
    }

    # Obtener nueva versión
    $newVersion = Get-NewVersion -currentVersion $currentVersion -incrementType $type

    # Crear versiones etiquetadas
    $alpha = "$newVersion-alpha.1"
    $beta  = "$newVersion-beta.1"
    $prod  = "$newVersion-prod"
    $plain = $newVersion

    # Imprimir versiones generadas
    Write-Host "Generando versiones:"
    Write-Host "Alpha: $alpha"
    Write-Host "Beta:  $beta"
    Write-Host "Prod:  $prod"
    Write-Host "Final: $plain"

    # Git settings
    git config --global credential.useHttpPath true
    git config user.email $email
    git config user.name $autor

    git fetch origin
    git checkout $branch
    git pull origin $branch --rebase

    # Actualizar package.json
    $packageJson.version = $plain
    $packageJson | ConvertTo-Json -Depth 10 | Set-Content $packageJsonPath -Encoding UTF8

    # Actualizar CHANGELOG.md
    $fecha = (Get-Date).ToUniversalTime().AddHours(-4).ToString("yyyy-MM-dd HH:mm:ss")
    $changelogEntry ="`n`n## [Version $plain] - $fecha`n
    - Despliegue automático basado en commit:
    $lastCommitMessage`n
    Autor: $autor | Rama: $branch"

    $changelogContent = Get-Content $changelogPath -Raw
    $changelogContent.Replace("<!-- [NEXT_ENTRY] -->", "<!-- [NEXT_ENTRY] -->$changelogEntry") | Out-File $changelogPath -NoNewline

    git add *
    git commit -m "ci: Version del proyecto actualizada a '$plain' [skip ci]"
    git push origin $branch

    # Crear tag en Git y enviarlo al repositorio remoto
    if (-not (git tag | Select-String -Pattern "^$plain$")) {
        git tag "$plain"
        git push origin "$plain"
        Write-Host "Git tag creado y subido: $plain"
    } else {
        Write-Host "⚠️ El tag '$plain' ya existe. No se volverá a crear."
    }

    # Establecer variables para Azure DevOps
    Write-Host "##vso[build.updatebuildnumber]$plain"
    Write-Host "##vso[task.setvariable variable=dockerTagAlpha;isOutput=true]$alpha"
    Write-Host "##vso[task.setvariable variable=dockerTagBeta;isOutput=true]$beta"
    Write-Host "##vso[task.setvariable variable=dockerTagProd;isOutput=true]$prod"
    Write-Host "##vso[task.setvariable variable=dockerTagFinal;isOutput=true]$plain"

    Write-Host "`nVersion del proyecto actualizada a '$plain'`n"

} catch {
    Write-Error "❌ Error durante la ejecución del script: $($_.Exception.Message)"
    exit 1
}
