#!/bin/bash

echo -e "\n\n\033[0;32mTravis test.sh script\033[0m"

echo -e "\n\n\033[1;33mMaking dependency cache directory\033[0m"
mkdir -p dep_cache
echo "Listing directory contents:"
ls -l dep_cache

echo -e "\n\n\033[1;33mPreparing...\033[0m"
cp config/travis/hydra-ldap.yml config/hydra-ldap.yml
cp config/travis/database.yml config/database.yml
psql -c 'create database travis_ci_test;' -U postgres
bundle exec solr_wrapper --config config/travis/solr_wrapper_test.yml &
bin/jetty_wait

echo -e "\n\n\033[1;33mRunning RSpec test suite\033[0m"
bundle exec rake cho:travis:rspec
RSPEC_EXIT_CODE=$?

exit $RSPEC_EXIT_CODE
