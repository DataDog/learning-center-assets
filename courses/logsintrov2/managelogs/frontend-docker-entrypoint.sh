#!/bin/bash
# This is entrypoint for docker image of spree sandbox on docker cloud
cd store-frontend && bundle update ddtrace --minor
RAILS_ENV=development bundle exec rails s -p 3000 -b '0.0.0.0'