FROM node:10 as nodejs

FROM ruby:2.6.3

WORKDIR /cho

RUN apt-get update && \
    apt-get install default-jdk curl unzip -y

RUN mkdir /opt/fits &&  \
    curl -Lo /tmp/fits.zip https://github.com/harvard-lts/fits/releases/download/1.4.1/fits-1.4.1.zip &&  \
    unzip /tmp/fits.zip -d /opt/fits &&  \
    ln -s /opt/fits/fits.sh /usr/local/bin/fits

ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

ENV TZ=America/New_York

RUN gem install bundler

COPY Gemfile Gemfile.lock /cho/

RUN bundle install

COPY --from=nodejs /usr/local/bin/node /usr/local/bin/
COPY --from=nodejs /usr/local/lib/node_modules /usr/local/lib/node_modules
COPY --from=nodejs /opt/ /opt/

RUN ln -sf /usr/local/bin/node /usr/local/bin/nodejs \
  && ln -sf ../lib/node_modules/npm/bin/npm-cli.js /usr/local/bin/npm \
  && ln -sf ../lib/node_modules/npm/bin/npx-cli.js /usr/local/bin/npx \
  && ln -sf /opt/yarn*/bin/yarn /usr/local/bin/yarn \
  && ln -sf /opt/yarn*/bin/yarnpkg /usr/local/bin/yarnpkg

COPY package.json /cho
COPY yarn.lock /cho
RUN yarn install

COPY . /cho

CMD ["./entrypoint.sh"]
