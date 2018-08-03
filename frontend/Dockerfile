FROM node:8.9-alpine

WORKDIR /app

COPY package.json /app/package.json
RUN npm install \
 && npm ls \
 && npm cache clean --force 
COPY . /app

ARG version=v1

ENV VERSION=$version
ENV PORT 80
EXPOSE 80

CMD ["node", "server.js"]