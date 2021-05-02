FROM ruby:2.7.1 as release

WORKDIR /api

RUN apt-get update -qq && apt-get install -y libxslt-dev libxml2-dev build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

COPY sidekiq-entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/sidekiq-entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "s", "-b", "0.0.0.0"]
