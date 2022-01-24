# Depreaction

Eventhough this boilerlplate simply works and can be used, i'am no longer actively maintaining it, since we moved to a kubernetes based setup.

# WAT

This boilerplate focuses on providing a simple, less technical way to run wordpress on docker

 - using official wordpress image and adding the `wp-cli` to it
 - higher upload limit ( 64MB ) out of the box
 - having a securet setup with SSL
 - simple to upgrade and maintain
 - run several wordpress sites in a non-multisite but multi-FPM - but easy with Traefik

This image can be used for **production** or running it locally for development. 
You can easily also start it with an **Let's Encrypt SSL** support right away.

The usual workflow using `composer` and things like that are not included here to reduce the complexity of this
boilerplate for the audience.

This git repo has been setup a way so you can pull it to update the repo without losing any data, configuration or setup. So you can update your "stack management"

# Usage

- create a file `.env`  add put `DB_PW=<secret>` to it, so you have a mysql password set

`vim .env`
```
DB_PW=somepassword
```

Now

```
docker-compose up

# or

./start.sh
```

That's it - now connect to `localhost:81` or whatever you like

# Data

### Update

This will update the wordpress / mysql image and restart your stack if there have been any. This will never delete
any of your data, plugins, themes or database ( what so ever )

just run

```bash
./update.sh
```

or mannually

```bash
docker-compose pull
./start.sh
```

### Wordpress, assets, plugins, themes
You wordpress data is mounted to a host-mount under `data/site1/wordpress_files` ( which are excluded from this git repo )
There you find your wordpress installation including all plugins,themes and assets

A host-mount is used to simplify the workflow for most users ( e.g. adding a custom theme or similar )

### Database data
The database is located in the named volume `db-data`

# Advanced

## SSL

#### HTTP-01 (start here)
To be able to run wordpress behind SSL using LetsEncrypt without any big effort, you can use the `traefik` integration.

The easiest way for starters is using the `-http` variant. You will need 1 more variables to your `.env` file

`.env`
```
# this is needed to enable the extra traefik service
COMPOSE_FILE=docker-compose.yml:docker-compose-traefik-http.yml
DB_PW=<youdbpw>
DB_ROOT_PW=<yourmysqlrootpw>
# add your domain
WORDPRESS_DOMAIN=mywordpress.de
```

```
docker-compose up
```

Now you can already connect using `https://mywordpress.de` and in addition requests to `http://mywordpress.de` are already
redirected to `https://mywordpress.de` automatically. Neat

#### DNS-01 (alternative)

Or for the DNS-01 variant you will need to add another 2 variables (this example is for cloudflare)

`.env`
```
# this is needed to enable the extra traefik service
COMPOSE_FILE=docker-compose.yml:docker-compose-traefik-dns.yml
DB_PW=<youdbpw>
# Be sure to add your domain
WORDPRESS_DOMAIN=mywordpress.de
TRAEFIK_ACME_CHALLENGE_DNS_PROVIDER=cloudflare
TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS=CF_DNS_API_TOKEN=<YOURTOKEN>
```

```
docker-compose up
```

## Official image

If you want to use the official image instead of `eugenmayer/wordpress` ( see below) just replace the `image:` in the 
`docker-compose.yml` with `wordpress:latest` (uncomment it)

## Building your own custom image

The optional docker image `eugenmayer/wordpress` does add the wordpress-cli `wp-cli` to the image, but is based on the
official `wordpress:latest` image. If you want to rebuild it

```
make build

# or
docker-compose build wordpress
```

## Using wp-cli

The important thing is to run it under the `www-data` user

```
./wp-cli.sh

# or
docker-compose exec -u www-data  wordpress bash

# or 

docker exec -it -u www-data <wordpress-container> bash
```

Or you can fire up the commands directly

```bash
./wp-cli.sh cli version
./wp-cli.sh user update --user_pass=123 Admin
./wp-cli.sh migratedb find-replace --find='http://stagin-site.com' --replace='https://production-site.com'
```

## Custom configuration

- create a folder called `config/` - e.g. add a "mycustom.ini" with the content you need inside that folder
- create a filder called `config/docker-compose-overrides.yml` and put something like this inside

```yaml
version: "3.3"

services:
  wordpress:
    volumes:
      - ./config/mycustom.ini:/usr/local/etc/php/conf.d/mycustom.ini
```

You can mount any configuration you need, whatever you like or need to be changed

- now edit your `.env` file and set this

```
COMPOSE_FILE=docker-compose.yml:config/docker-compose-overrides.yml
```

Now just start your stack again.

```
docker-compose up -d
```

That is all all you need.


## Multisite

For running several wordpress instances in the same stack but in different FPM container

see `README.multisite.md
