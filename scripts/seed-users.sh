#!/bin/sh

echo "Esperando a que la app arranque..."

# Espera hasta que el servidor esté disponible
until curl --output /dev/null --silent --head --fail http://localhost:8000; do
  echo "Esperando al servidor..."
  sleep 2
done

echo "Servidor disponible. Agregando datos de prueba..."

# Insertar 5 usuarios con POST
curl -s -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0010010011", "name": "Juan"}'

curl -s -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0020020022", "name": "Pedro"}'

curl -s -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0030030033", "name": "Maria"}'

curl -s -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0040040044", "name": "Ana"}'

curl -s -X POST http://localhost:8000/api/users \
  -H "Content-Type: application/json" \
  -d '{"dni": "0050050055", "name": "Luis"}'

echo "Datos de prueba creados."
