# B"H
FROM node:lts-alpine3.12

RUN apk add --no-cache tini

WORKDIR /app

COPY ./package*.json ./
RUN npm install 

COPY . .
RUN npm test

ARG GITHUB_SHA=""
ARG GITHUB_REF=""

ENV GITHUB_SHA=${GITHUB_SHA}
ENV GITHUB_REF=${GITHUB_REF}

ENTRYPOINT ["tini", "--"]
CMD ["npm", "start"]
# This is comment
# One more
# One more is 
