# app building node
FROM node:latest as build-deps

WORKDIR /usr/src/app
ENV HOMEDIR=/usr/src/app

COPY package.json yarn.lock ./
RUN yarn
COPY . ./
RUN yarn build

# sever node
FROM node:latest

WORKDIR /usr/src/app
ENV HOMEDIR=/usr/src/app

COPY package.json .
COPY yarn.lock .
RUN yarn install --prod --non-interactive

COPY --from=build-deps /usr/src/app/build ./build
COPY server/ ./server

EXPOSE 80
CMD [ "node", "server/index" ]
