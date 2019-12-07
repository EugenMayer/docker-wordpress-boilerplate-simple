# WAT

Simple way of running wordpress through docker:

 - using official wordpress image and adding the `wp-cli` to it


# Usage

- create a `.env` file and add `DB_PW=<secret>` to it, so you have a mysql password set

```
docker-compose up
```

Now connect to `localhost:80` or whatever you like

# Data

### Wordpress, assets, plugins, themes
You wordpress data is mounted to a host-mount under `data/wordpress_files` ( which are excluded from this git repo )
There you find your wordpress installation including all plugins,themes and assets

A host-mount is used to simplify the workflow for most users ( e.g. adding a custom theme or similar )

### Database
The database is located in the named volume `db-data`
