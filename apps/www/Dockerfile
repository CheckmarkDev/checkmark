# Base
FROM node:14.16.1 AS base

WORKDIR /www

COPY package.json package-lock.json ./

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
FROM node:14-alpine AS release

WORKDIR /www

COPY --from=build /www/.nuxt ./.nuxt

COPY package.json package-lock.json ./

RUN npm ci --only=production

EXPOSE 8080

CMD ["npm", "run", "start"]
