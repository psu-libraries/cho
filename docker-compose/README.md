# Install Docker
https://download.docker.com/mac/stable/Docker.dmg

- Drag to Applications
- Open


# Build 
Builds the docker image from your Dockerfile. You'll need to build anytime anything *outside* of `./app` changes. changes from within `./app` are automaticaly persisted to the docker container via volume bind mount

`docker-compose build`


# Run CHO
All the defaults for CHO should be sane enough to "just work" Running

`docker-compose up -d` will startup solr, redis, postgres, and the rails app.

If you want to build, and run the app in the same command you can run 

`docker-compose up --build`

the following will be available to localhost for your convenience 

localhost:8080 - adminer
localhost:3000 - rails app
localhost:5432 - postgres
localhost:8983 - solr


#DANGER ZONE
There be dragons in solr land. The first time solr boots up, you will need to create the 'cho' core, and send it it's configuration

```
# create the core
docker-compose exec solr solr create_core -c cho

# configure solr
docker cp solr/config/schema.xml cho_solr_1:/var/solr/data/cho/conf/schema.xml
docker cp solr/config/solrconfig.xml cho_solr_1:/var/solr/data/cho/conf/solrconfig.xml

# restart solr
docker-compose restart solr
```


# Rake Tasks
To run rake tasks you run them like you normally would, but preface the command with `docker-compose exec web`
Example

`docker-compose exec web bundle exec rake db:seed`


# Cleanup 
```
docker-compose down
```

# Remove all state
```

```