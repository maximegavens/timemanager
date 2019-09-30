#!/bin/bash

# fail if we error out
set -e

# Ensure we have the basics...
mix local.hex --force
mix local.rebar --force
mix deps.get
mix ecto.create
mix ecto.migrate

# Wait for database to come up
until psql -h db -U "postgres" -c '\q' 2>/dev/null; do
  >&2 echo "Postgres is unavailable - sleeping"
  sleep 1
done

# Compile the project
mix deps.compile

#Start
mix phx.server

exec "$@"