FROM wordpress:latest

# install the wordpress cli (wp-cli)
RUN apt-get update \ 
 && apt-get install -y less \
 && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp



