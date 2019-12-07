# WAT

This boileplate focuses on provoding a simple, less technical way to run wordpress on docker

 - using official wordpress image and adding the `wp-cli` to it

The usual workflows using `composer` and things like that are not included here to reduce the complexity of this
boilerplate for the audience.

# Usage

- create a `.env` file and add `DB_PW=<secret>` to it, so you have a mysql password set

```
docker-compose up

# or

./start.sh
```

That's it - now connect to `localhost:80` or whatever you like

# Data

### Wordpress, assets, plugins, themes
You wordpress data is mounted to a host-mount under `data/wordpress_files` ( which are excluded from this git repo )
There you find your wordpress installation including all plugins,themes and assets

A host-mount is used to simplify the workflow for most users ( e.g. adding a custom theme or similar )

### Database
The database is located in the named volume `db-data`

# Advanced

## using the official image

If you want to use the official image instead of `eugenmayer/wordpress` ( see below) just replace the `image:` in the 
`docker-compose.yml` with `wordpress:latest` (uncomment it)
## Building the custom image

The optional docker image `eugenmayer/wordpress` does add the wordpress-cli `wp-cli` to the image, but is based on the
official `wordpress:latest` image. If you want to rebuild it

```
make build

# or
docker-compose build
```

## Using wp-cli

The important thing is to run it under the `www-data` user

```
./wp-cli,sh

# or
docker-compose exec -u www-data  wordpress bash

# or 

docker exec -it -u www-data <wordpress-container> bash
```

Or you can fire up the commands directly

```bash
./wp-cli.sh info
./wp-cli.sh user update --user_pass=123 Admin
```