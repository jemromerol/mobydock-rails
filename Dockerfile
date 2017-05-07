FROM ruby:2.3-alpine
MAINTAINER Jose Emilio Romero Lopez <jemromerol@gmail.com>

RUN apk update && apk add build-base postgresql-dev libffi-dev postgresql-client nodejs

ENV INSTALL_PATH /srv/mobydock
RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

COPY Gemfile Gemfile
RUN bundle install

COPY . .

RUN bundle exec rake RAILS_ENV=production DATABASE_URL=postgresql://user:pass@127.0.0.1/dbname SECRET_TOKEN=pickasecuretoken assets:precompile

VOLUME ["$INSTALL_PATH/public"]

CMD bundle exec puma -C config/puma.rb
