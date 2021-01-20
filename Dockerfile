FROM myapp-node-base:1.0.0 AS builder 

WORKDIR /app

COPY ./package*.json ./
RUN npm install 

COPY . .
RUN npm test

ENTRYPOINT ["tini", "--"]
CMD ["npm", "start"]
