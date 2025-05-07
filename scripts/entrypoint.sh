#!/bin/sh

# Iniciar la app en background
node src/index.js &

# Ejecutar el script de sembrado
/app/src/scripts/seed-users.sh

# Esperar el proceso de Node para mantener el contenedor vivo
wait $!
