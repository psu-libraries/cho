#!/bin/bash

echo -e "\n\n\033[0;32mTravis test.sh script\033[0m"

echo -e "\n\n\033[1;33mMaking dependency cache directory\033[0m"
mkdir -p dep_cache
echo "Listing directory contents:"
ls -l dep_cache

echo -e "\n\n\033[1;33mInstalling Code Climate test reporting tool\033[0m"
if [ ! -f dep_cache/cc-test-reporter ]; then
  curl -L https://codeclimate.com/downloads/test-reporter/test-reporter-latest-linux-amd64 > ./dep_cache/cc-test-reporter
  chmod +x ./dep_cache/cc-test-reporter
fi
export PATH=$PATH:$(pwd)/dep_cache

echo -e "\n\n\033[1;33mCopy config files and build database\033[0m"
cp config/travis/hydra-ldap.yml config/hydra-ldap.yml
cp config/travis/database.yml config/database.yml
psql -c 'create database travis_ci_test;' -U postgres

echo -e "\n\n\033[1;33mCompiling webpacks\033[0m"
bundle exec rails webpacker:compile

echo -e "\n\n\033[1;33mStarting xvfb\033[0m"
export DISPLAY=:99.0
sh -e /etc/init.d/xvfb start
sleep 5

echo -e "\n\n\033[1;33mPreparing...\033[0m"
bundle exec solr_wrapper --config config/travis/solr_wrapper_test.yml &
bin/jetty_wait

echo -e "\n\n\033[1;33mRunning RSpec test suite with code coverage\033[0m"
cc-test-reporter before-build
bundle exec rake cho:travis:rspec
RSPEC_EXIT_CODE=$?
cc-test-reporter after-build --exit-code $RSPEC_EXIT_CODE

exit $RSPEC_EXIT_CODE
