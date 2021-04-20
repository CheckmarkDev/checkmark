FROM node:12-alpine as release
ARG NODE_ENV=production

WORKDIR /www

# install dependencies
COPY package.json yarn.lock ./

RUN yarn install --prod --frozen-lockfile

# copy app source
COPY . .

RUN export $(grep -v '^#' .env.prod | xargs)

EXPOSE 9090

CMD ["node", "index.js"]
