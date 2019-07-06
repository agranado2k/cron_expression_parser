FROM ruby:2.6.3-alpine3.10
RUN apk add --update build-base

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
RUN gem install bundler:2.0.2
RUN bundle install

ADD . .
