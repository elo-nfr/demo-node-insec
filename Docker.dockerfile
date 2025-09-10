# Etapa 1: imagem base leve
FROM node:20-alpine

# Diretório da aplicação
WORKDIR /usr/src/app

# Copiar manifestos primeiro (para cache de dependências)
COPY package*.json ./

# Instalar dependências vulneráveis (intencionalmente)
RUN npm install --legacy-peer-deps

# Copiar o restante do código
COPY . .

# Expor porta da aplicação
EXPOSE 3000

# Rodar a aplicação
CMD ["npm", "start"]

