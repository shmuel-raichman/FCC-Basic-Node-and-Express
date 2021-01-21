# B"H
FROM node:lts-alpine3.12

RUN apk add --no-cache tini

WORKDIR /app

COPY ./package*.json ./
RUN npm install 

COPY . .
RUN npm test

ENTRYPOINT ["tini", "--"]
CMD ["npm", "start"]
