# CHO

Penn State University Library's cultural heritage object repository project.

## Development Setup

Clone the application and install:

    git clone
    cd cho
    bundle install

Ensure that postgres is installed and running, then:

    createdb `whoami`
    cp config/samples/database.yml config/database.yml

And edit `database.yml`, replacing _YOUR_LOCAL_USERNAME_ with your local user's login name.

Run migrations and tests:

    rake db:drop db:create db:migrate
    bundle exec rspec
