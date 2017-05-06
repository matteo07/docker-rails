FROM ruby:2.3 
MAINTAINER matteodema17@gmail.com

# Install apt based dependencies required to run Rails as 
# well as RubyGems. As the Ruby image itself is based on a 
# Debian image, we use apt-get to install those.
RUN apt-get update && apt-get install -y \ 
  build-essential \ 
  nodejs

# Configure the main working directory. This is the base 
# directory used in any further RUN, COPY, and ENTRYPOINT 
# commands.
RUN mkdir -p /var/app 
WORKDIR /var/app

# Copy the Gemfile as well as the Gemfile.lock and install 
# the RubyGems. This is a separate step so the dependencies 
# will be cached unless changes to one of those two files 
# are made.
COPY Gemfile Gemfile.lock ./ 
RUN gem install bundler && bundle install --jobs 20 --retry 5

# Copy the main application.
COPY . /var/app

RUN bundle install

# The main command to run when the container starts. Also 
# tell the Rails dev server to bind to all interfaces by 
# default.

CMD rails s -b 0.0.0.0 -p 80

#BUILD AND RUN
#sudo docker build -t docker-rails .
#sudo docker run -itP docker-rails

#TO FIND DOCKER'S IP
#sudo docker ps -a
#sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' e109c32fe9a2


