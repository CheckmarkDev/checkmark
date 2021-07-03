ARG NODE_VERSION="14-alpine"
ARG NODE_ENV="production"
ARG YARN_VERSION="1.22.10"

FROM node:${NODE_VERSION} AS release

ARG NODE_ENV
ARG YARN_VERSION

# As root user, gives "node" the permission to npm files
RUN chown -R node /usr/local/lib/node_modules /usr/local/bin

# Uses the "node" user by default
USER node

RUN npm install -g yarn@${YARN_VERSION} --force

WORKDIR /www

COPY --chown=node package.json yarn.lock ./

RUN yarn install --prod --frozen-lockfile

# Copy the necessary files. As we only have src and index, don't
# copy the rest.
COPY --chown=node src ./src
COPY --chown=node index.js ./index.js

EXPOSE 9090

CMD ["node", "index.js"]
