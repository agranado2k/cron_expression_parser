[![Build Status](https://travis-ci.org/agranado2k/cron_expression_parser.svg?branch=master)](https://travis-ci.org/agranado2k/cron_expression_parser)
# Cron Expression Parser 

Small project ot parse cron expression

### Executing with Docker environment
#### Pre requirement
You need to install [docker compose](https://docs.docker.com/compose/install/).

#### How to build the image
In the project's root folder execute the command:
```shell
docker-compose build
```

#### How to run test
In the project's root folder execute the command
```shell
docker-compose run web bundle exec rspec
```

#### How to run command
In the project's root folder execute the command
```shell
docker-compose run app ./bin/cron_expression '*/15 0 1,15 * 1-5 /usr/bin/find'
```

#### Executing in your local environment
#### Pre requirement
You need to install **ruby version 2.6.3** and **bundler 2.0.2**.
In the project's root folder execute the command:
```shell
bundler install
```

#### How to run test
In the project's root folder execute the command
```shell
bundle exec rspec
```

#### How to run command
In the project's root folder execute the command
```shell
./bin/cron_expression '*/15 0 1,15 * 1-5 /usr/bin/find'
```


