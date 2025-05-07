# Azure Pipelines

Este directorio contiene los pipelines YAML usados en Azure DevOps.

## Archivos principales

- `build.yml`: Compila, lint y ejecuta pruebas unitarias.
- `deploy-k8s.yml`: Despliega en Kubernetes/OpenShift.
- `liquibase-mysql.yml`: Ejecuta validaciones y actualizaciones de base de datos usando Liquibase.

## Plantillas

Las plantillas se ubican en `/templates` y contienen pasos reutilizables para los distintos stages.
