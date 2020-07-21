FROM wordpress:latest

# install the wordpress cli (wp-cli)
RUN apt-get update \ 
 && apt-get install -y less \
 && pecl install apcu \
 && echo "extension=apcu.so" > /usr/local/etc/php/conf.d/docker-php-ext-apcu.ini \
 && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
 && chmod +x wp-cli.phar \
 && mv wp-cli.phar /usr/local/bin/wp 
 
# higher upload limit
COPY docker/php/uploads.ini /usr/local/etc/php/conf.d/uploads.ini


