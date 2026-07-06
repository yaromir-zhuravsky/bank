FROM ruby:3.4.4-alpine

WORKDIR /bank

RUN apk add --no-cache \
      build-base \
      postgresql-dev \
      postgresql-client \
      yaml-dev \
      tzdata

COPY Gemfile Gemfile.lock ./

ENV RAILS_ENV=production \
    BUNDLE_WITHOUT=development:test

RUN bundle install

COPY . .



EXPOSE 3000

ENTRYPOINT ["./bin/docker-entrypoint.sh"]

CMD ["./bin/rails", "server"]