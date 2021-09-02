FROM node:16.6.2-alpine3.14 as node

FROM ruby:3.0.2-alpine3.14 as builder

RUN apk --update --no-cache add shadow sudo busybox-suid mariadb-connector-c-dev tzdata alpine-sdk

RUN mkdir -p /myapp
WORKDIR /myapp

COPY Gemfile Gemfile.lock ./
RUN bundle install -j 4

COPY --from=node /usr/local/ /usr/local/
COPY --from=node /opt/ /opt/

COPY package.json yarn.lock ./
RUN yarn install --check-files
RUN yarn install

COPY entrypoint.sh /entrypoint.sh
RUN chmod 755 /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
