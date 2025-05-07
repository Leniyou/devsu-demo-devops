# -- Builder: Etapa de construcción
FROM node:23.11.0-alpine3.21 AS builder

WORKDIR /src

COPY package*.json ./

RUN npm install --omit=dev --no-audit --progress=false \
    && npm cache clean --force

COPY . .

# -- Runtime: Ejecutar la aplicación
FROM node:23.11.0-alpine3.21 AS runtime

# Establecer variables de entorno
ENV NODE_ENV=development \
    PORT=8000 \
    TZ=America/Santo_Domingo

WORKDIR /app

# Copiar solo lo necesario desde la etapa anterior
COPY --from=builder /src /app

# Instala curl y tzdata, y da permisos a la carpeta de trabajo
RUN apk add --no-cache --update curl tzdata \
    && rm -rf /var/cache/apk/* \
    && chown -R node:node /app && chmod -R 755 /app

# Cambiar a usuario 'node' no root
USER node

# Exponer el puerto
EXPOSE 8000

# Healthcheck simple basado en la ruta /
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8000/ || exit 1

# Comando para iniciar la app
CMD [ "node", "src/index.js"]
