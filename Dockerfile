FROM ruby:2.6.3-alpine3.10
RUN gem install bundler

WORKDIR /app
ADD Gemfile Gemfile.lock /app/
RUN bundle install

ADD . .
