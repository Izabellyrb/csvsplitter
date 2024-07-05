FROM ruby:3.3.3

RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -
RUN apt-get update
RUN apt-get install -y nodejs
RUN npm install --global yarn

RUN mkdir -p /opt/app

WORKDIR /opt/app
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN gem install bundler
RUN bundle install

COPY . /opt/app
