FROM ruby:3.3.1

# System dependencies
RUN apt-get update -qq && apt-get install -y \
  build-essential \
  postgresql-client \
  nodejs

WORKDIR /app

# Install gems
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copy app code
COPY . .

# Fix Rails server PID issue
RUN rm -f tmp/pids/server.pid

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]
