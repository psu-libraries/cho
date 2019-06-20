FROM node:10 as nodejs

FROM ruby:2.6.3

WORKDIR /cho

# ENV BUNDLE_PATH='/cho/.vendor/bundle'
# ENV GEM_HOME='/cho/.vendor/gems'
ARG RAILS_ENV
ENV RAILS_ENV=$RAILS_ENV

ENV TZ=America/New_York

RUN gem install bundler

COPY Gemfile Gemfile.lock /cho/

# RUN bundle package --all

# RUN if [ "$RAILS_ENV" = "development" ]; then bundle install --deployment; else bundle install --without development test --deployment; fi 
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

# RUN curl -Lo fits.zip https://github.com/harvard-lts/fits/releases/download/1.4.1/fits-1.4.1.zip
# RUN unzip 

CMD ["./entrypoint.sh"]