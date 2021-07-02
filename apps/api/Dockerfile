ARG RUBY_VERSION="2.7.1"

FROM ruby:${RUBY_VERSION} as release

WORKDIR /api

RUN apt-get update -qq && \
  apt-get install -y libxslt-dev libxml2-dev build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY entrypoint.sh sidekiq-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh /usr/bin/sidekiq-entrypoint.sh

COPY . .

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]
