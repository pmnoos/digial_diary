# Use the official Ruby image as a base
FROM ruby:3.2

RUN apt-get update -qq
RUN apt-get install -y build-essential libpq-dev nodejs curl gnupg
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg > /dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list
RUN apt-get update -qq
RUN apt-get install -y yarn
RUN apt-get clean && rm -rf /var/lib/apt/lists/*
WORKDIR /app

# Copy Gemfiles and install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy the rest of the app
COPY . ./

# Precompile assets (if using Rails asset pipeline)
RUN bundle exec rake assets:precompile

# Expose port 3000 for Rails server
EXPOSE 3000

# Start the Rails server
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
