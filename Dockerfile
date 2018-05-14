FROM ruby:2.5.1

# see update.sh for why all "apt-get install"s have to stay as one long line
RUN apt-get update && apt-get install -y curl sudo
RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash 
RUN apt-get install -y nodejs && rm -rf /var/lib/apt/lists/*

RUN apt-get install npm
RUN npm i -g yarn
# see http://guides.rubyonrails.org/command_line.html#rails-dbconsole
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

ENV RAILS_VERSION 5.2.0

#RUN gem install rails --version "$RAILS_VERSION"


RUN gem install bundler
WORKDIR /tmp
ADD Gemfile Gemfile
ADD Gemfile.lock Gemfile.lock
RUN bundle install
ENV APP_HOME /app_name
RUN mkdir -p $APP_HOME
WORKDIR $APP_HOME
ADD . $APP_HOME