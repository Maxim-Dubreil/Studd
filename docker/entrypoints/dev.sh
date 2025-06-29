#!/bin/bash
set -e

# Check db with netcat
# GOAL: Wait for the database to be ready before starting the application
rm -f tmp/pids/server.pid

echo "Wait for db..."
while ! nc -z db 5432; do
  sleep 0.1
done
echo "db ready !"

# Start db
bundle exec rails db:prepare

# Start the development server via bin
exec foreman start -f Procfile.dev 