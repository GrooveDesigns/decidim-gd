FROM ruby:2.7.5

RUN apt-get update -qq && apt-get install -y build-essential libpq-dev nodejs

RUN curl -sL https://deb.nodesource.com/setup_16.x | bash - && \
apt-get -y install nodejs

RUN apt-get update && apt-get install -y curl apt-transport-https wget && \
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list && \
apt-get update && apt-get install -y yarn

ENV APP_HOME=/app

WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock ./
COPY package.json yarn.lock ./

# bundle install
RUN gem install bundler:2.2.31
RUN bundle config set force_ruby_platform true
RUN bundle check || bundle install

# yan install
RUN yarn install

COPY . $APP_HOME