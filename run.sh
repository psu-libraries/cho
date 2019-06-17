#!/bin/bash

./bin/rails db:create
./bin/rails db:migrate
./bin/rails db:seed

./bin/rails s

