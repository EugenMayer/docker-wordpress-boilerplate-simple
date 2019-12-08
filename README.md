# WAT

This boilerplate focuses on providing a simple, less technical way to run wordpress on docker

 - using official wordpress image and adding the `wp-cli` to it

This image can be used for production or running it locally for development.

The usual workflow using `composer` and things like that are not included here to reduce the complexity of this
boilerplate for the audience.

# Usage

- create a `.env` file and add `DB_PW=<secret>` to it, so you have a mysql password set

`.env`
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
```
docker-compose pull
./start.sh
```

### Wordpress, assets, plugins, themes
You wordpress data is mounted to a host-mount under `data/wordpress_files` ( which are excluded from this git repo )
There you find your wordpress installation including all plugins,themes and assets

A host-mount is used to simplify the workflow for most users ( e.g. adding a custom theme or similar )

### Database data
The database is located in the named volume `db-data`

# Advanced

## SSL

To be able to run wordpress behind SSL using LetsEncrypt without any big effort, you can use the `traefik` integration.

The easiest way for starters is using the `-http` variant. You will need 1 more variables to your `.env` file

`.env`
```
DB_PW=<youdbpw>
WORDPRESS_DOMAIN=mywordpress.de
```

```
docker-compose -f docker-compose.yml -f docker-compose-traefik-http.yml up
```

Now you can already connect using `https://mywordpress.de` and in addition requests to `http://mywordpress.de` are already
redirected to `https://mywordpress.de` automatically. Neat

Or for the DNS-01 variant you will need to add another 2 variables (this example is for cloudflare)

`.env`
```
DB_PW=<youdbpw>
WORDPRESS_DOMAIN=mywordpress.de
TRAEFIK_ACME_CHALLENGE_DNS_PROVIDER=cloudflare
TRAEFIK_ACME_CHALLENGE_DNS_CREDENTIALS=CF_DNS_API_TOKEN=<YOURTOKEN>
```

```
docker-compose -f docker-compose.yml -f docker-compose-traefik-dns.yml up
```

## using the official image

If you want to use the official image instead of `eugenmayer/wordpress` ( see below) just replace the `image:` in the 
`docker-compose.yml` with `wordpress:latest` (uncomment it)

## Building the custom image

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
./wp-cli,sh

# or
docker-compose exec -u www-data  wordpress bash

# or 

docker exec -it -u www-data <wordpress-container> bash
```

Or you can fire up the commands directly

```bash
./wp-cli.sh cli version
./wp-cli.sh user update --user_pass=123 Admin
```