FROM ruby:2.7.1 as release

WORKDIR /api

RUN apt-get update -qq && apt-get install -y libxslt-dev libxml2-dev build-essential patch ruby-dev zlib1g-dev liblzma-dev libpq-dev

RUN apt-get -y install cron

COPY . .

RUN bundle install

COPY entrypoint.sh /usr/bin/

RUN chmod +x /usr/bin/entrypoint.sh

ENTRYPOINT ["entrypoint.sh"]

EXPOSE 3000

CMD ["rails", "s"]
