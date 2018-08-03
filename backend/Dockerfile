FROM node:8.9-alpine

WORKDIR /app

COPY package.json /app/package.json
RUN npm install \
 && npm ls \
 && npm cache clean --force 
COPY . /app

ARG service_name=foo
ARG version=v1

ENV SERVICE_NAME=$service_name
ENV VERSION=$version
ENV PORT 80
EXPOSE 80

CMD ["node", "server.js"]