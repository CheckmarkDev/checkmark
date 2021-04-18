FROM node:12-alpine as release
ARG NODE_ENV=production

WORKDIR /www

# install dependencies
COPY package.json yarn.lock ./
RUN yarn install

# copy app source
COPY . .

EXPOSE 9090

CMD ["node", "index.js"]