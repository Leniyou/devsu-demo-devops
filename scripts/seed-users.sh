#!/bin/sh

echo "Esperando a que la app arranque..."

Espera hasta que el servidor esté disponible
until curl -k --output /dev/null --silent --head --fail https://devsu-demo-devops-nodejs-prod.local/health; do
  echo "Esperando al servidor..."
  sleep 2
done

echo "Servidor disponible. Agregando datos de prueba..."

# Insertar 5 usuarios con POST
curl -k -s -X POST https://devsu-demo-devops-nodejs-prod.local/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0010010011", "name": "Juan"}'

curl -k -s -X POST https://devsu-demo-devops-nodejs-prod.local/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0020020022", "name": "Pedro"}'

curl -k -s -X POST https://devsu-demo-devops-nodejs-prod.local/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0030030033", "name": "Maria"}'

curl -k -s -X POST https://devsu-demo-devops-nodejs-prod.local/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0040040044", "name": "Ana"}'

curl -k -s -X POST https://devsu-demo-devops-nodejs-prod.local/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0050050055", "name": "Luis"}'

echo "Datos de prueba creados."
