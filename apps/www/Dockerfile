ARG NODE_VERSION="14.16.1"
ARG NPM_VERSION="7.19.1"

# Base
FROM node:${NODE_VERSION} AS base

ARG NPM_VERSION

# As root user, gives "node" the permission to npm files
RUN chown -R node /usr/local/lib/node_modules /usr/local/bin /usr/local/share

# Uses the "node" user by default
USER node

RUN npm install -g npm@${NPM_VERSION}

WORKDIR /www

COPY --chown=node package.json package-lock.json ./

RUN npm ci

# Dev
FROM base AS dev

COPY --chown=node . .

CMD ["npm", "run", "dev"]

# Build
FROM base AS build

COPY --chown=node . .

RUN npm run build

# Release
FROM node:${NODE_VERSION}-alpine AS release

ARG NPM_VERSION

# As root user, gives "node" the permission to npm files
RUN chown -R node /usr/local/lib/node_modules /usr/local/bin /usr/local/share

# Uses the "node" user by default
USER node

RUN npm install -g npm@${NPM_VERSION}

WORKDIR /www

COPY --chown=node --from=build /www/.nuxt ./.nuxt

COPY --chown=node package.json package-lock.json ./

RUN npm ci --only=production

EXPOSE 8080

CMD ["npm", "run", "start"]
