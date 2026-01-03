FROM ruby:3.3-slim

# Install system dependencies
RUN apt-get update -qq \
    && apt-get install -y --no-install-recommends \
       build-essential \
       libpq-dev \
       postgresql-client \
       imagemagick \
       libjemalloc2 \
       curl \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

# Bundler config (development-friendly defaults)
ENV RAILS_ENV=development \
    BUNDLE_DEPLOYMENT=0 \
    BUNDLE_WITHOUT=""

# Install gems first for better layer caching
COPY Gemfile Gemfile.lock* ./
RUN gem install bundler \
    && bundle install

# Copy application code
COPY . .

# Ensure entrypoint is executable inside the image
RUN chmod +x bin/docker-entrypoint

EXPOSE 3000

# Run app via entrypoint which prepares DB if starting server
ENTRYPOINT ["bash","bin/docker-entrypoint"]
CMD ["bash","-lc","bundle exec rails server -b 0.0.0.0 -p 3000"]
