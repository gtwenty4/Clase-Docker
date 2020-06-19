FROM node:10 as builder

COPY ["package.json", "package-lock.json", "/usr/src/"]

WORKDIR /usr/src

RUN npm install --only=production

COPY [".", "/usr/src/"]

RUN npm install --only=development

RUN npm run test


# Productive image
FROM node:10

COPY ["package.json", "package-lock.json", "/usr/src/"]

WORKDIR /usr/src

RUN npm install --only=production

#El primer path no es del contexto de build es un path del stage anterior (builder)
COPY --from=builder ["/usr/src/index.js", "/usr/src/"]

EXPOSE 3000

CMD ["node", "index.js"]
