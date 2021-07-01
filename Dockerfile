FROM ruby:2.7.3

# Declare constants
ENV NVM_VERSION v0.34.0
ENV NODE_VERSION v14.17.1

RUN apt-get update && apt-get install -y build-essential libpq-dev nodejs vim postgis imagemagick npm 
# Install NVM
RUN curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash
# Install NODE
ENV NVM_DIR=/root/.nvm
RUN . "$NVM_DIR/nvm.sh" && nvm install ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm use ${NODE_VERSION}
RUN . "$NVM_DIR/nvm.sh" && nvm alias default ${NODE_VERSION}
ENV PATH="/root/.nvm/versions/node/${NODE_VERSION}/bin/:${PATH}"

RUN npm install --global yarn

WORKDIR /usr/src/app
COPY . /usr/src/app

ENV RAILS_ENV development


RUN yarn install --frozen-lockfile
RUN bundle install
RUN bin/rake assets:precompile

EXPOSE 3000

CMD bundle exec rails s -p 3000 -b '0.0.0.0'
