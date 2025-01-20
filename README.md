# docker-compose-laravel
A fork from [here](https://dev.to/aschmelyun/the-beauty-of-docker-for-local-laravel-development-13c0).

This compose project gives you the tooling to kickstart your laravel 11 project. 

## Usage

To get started, make sure you have [Docker installed](https://docs.docker.com/docker-for-mac/install/) on your system, and then clone this repository.

Next:
1. navigate in your terminal to the directory you cloned this.
2. run `cp .env.example .env` and configure your database credentials to the .env file 
3. Install laravel or copy from an existing project.
4. Run `cp src/.env.example src/.env`
5. Configure the `src/.env` file
6. Spin up the containers for the web server by running `docker-compose up -d --build site`.

Follow the steps from the [src/README.md](src/README.md) file to get your Laravel project added in (or create a new blank one).

### Creating a new project
If you already have a project and want dockerize it with this docker compose project, just copy your source code to `./src`. Create a new `./src` directory if it's not there yet. If you want to create a new project:

- Delete the `./src` directory if there is one.
- Run `docker compose run --rm installer`. This command will run the laravel installation process.

## Running the project
Running the project is as easy as running `docker-compose up -d --build site`. You may omit `-d` if you want to see the web server's request logs.

Bringing up the Docker Compose network with `site` instead of just using `up`, ensures that only our site's containers are brought up at the start, instead of all of the command containers as well. The following are built for our web server, with their exposed ports detailed:

- **nginx** - `:80`
- **mysql** - `:3306`
- **php** - `:9000`
- **redis** - `:6379`
- **mailpit** - `:8025` 

Three additional containers are included that handle Composer, NPM, and Artisan commands *without* having to have these platforms installed on your local computer. Use the following command examples from your project root, modifying them to fit your particular use case.

- `docker-compose run --rm composer [composer command here]`
- `docker-compose run --rm npm [npm command here]`
- `docker-compose run --rm artisan [artisan command here]`

## Persistent MySQL Storage

By default, whenever you bring down the Docker network, your MySQL data will be removed after the containers are destroyed. If you would like to have persistent data that remains after bringing containers down and back up, do the following:

1. Create a `./data/mysql` folder in the project root, alongside the `nginx` and `src` folders.
2. Under the mysql service in your `docker-compose.yml` file, add the following lines:

```
volumes:
  - ./data/mysql:/var/lib/mysql
```

## Mailpit

The current version of Laravel (11 as of today) uses Mailpit as the default application for testing email sending and general SMTP work during local development. Using the provided Docker Hub image, getting an instance set up and ready is simple and straight-forward. The service is included in the `docker-compose.yml` file, and spins up alongside the webserver and database services.

To see the dashboard and view any emails coming through the system, visit [localhost:8025](http://localhost:8025) after running `docker-compose up -d site`.

## Laravel Websocket 

The project will now use laravel reverb as the websocket server. To be implemented... or you can implement it on your own if it's not here yet.

## Laravel Pint

To be consistent with your code styling, [Laravel Pint](https://laravel.com/docs/10.x/pint) is implemented. To run Pint, execute the following commands: `docker-compose run --rm pint`. You can even add these commands as part of your pre-commit hooks.

The pint service is using [this service](https://github.com/syncloudsoftech/pinter)

## Laravel Octane
Main app runs on laravel octane FrankenPHP integration. See `frankenphp.dockerfile` if you want to add additional dependencies.

During development, it makes sense to reload octane every request. This behaviour can be modified inside `frankenphp.dockerfile`: `--max-requests=1` means that octane reloads ever 1 request while `--workers=1` spins up 1 octane worker. Change these values according to your production needs. You may check out the [Laravel Octane Documentation](https://laravel.com/docs/11.x/octane) for more information.

### Queue workers and cron
Queue workers and cron are on separate services using `php.dockerfile`. These containers *do not* use laravel octane.