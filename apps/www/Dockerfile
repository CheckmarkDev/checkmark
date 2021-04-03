# Base
FROM node:10.16.0 AS base

WORKDIR /www

COPY package.json .

COPY package-lock.json .

RUN npm ci

# Dev
FROM base AS dev

COPY . .

CMD ["npm", "run", "dev"]

# Build
FROM base AS build

COPY . .

RUN npm run build

# Release
FROM node:10-alpine AS release

WORKDIR /www

COPY . .

COPY --from=build /www/.nuxt ./.nuxt

RUN npm ci --only=production

EXPOSE 8080

CMD ["npm", "run", "start"]
