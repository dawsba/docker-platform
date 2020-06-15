# Pull base image
FROM arm32v7/alpine:3.11

# Label for Information about this Image.
LABEL org.opencontainers.image.authors="Barrie Dawson <bdawson@pandorasystems.net>" \
	org.opencontainers.image.title="pi-alpine-nginx-php" \
	org.opencontainers.image.description="AlpineLinux with NGINX Webserver and PHP7 on arm arch for PI" \
	org.opencontainers.image.licenses="Apache-2.0" \
	org.opencontainers.image.url="https://hub.docker.com/r/tobi312/alpine-nginx-php" \
	org.opencontainers.image.source="https://github.com/Tob1asDocker/alpine-nginx-php"

# Define variable
ENV LANG C.UTF-8
ENV TZ Europe/London
ENV TERM=xterm
ENV WWW_USER=pi
ENV WWW_USER_UID=1000

# Install
RUN addgroup -g $WWW_USER_UID -S $WWW_USER && \
    adduser -D -S -h /var/cache/$WWW_USER -s /sbin/nologin $WWW_USER -G $WWW_USER -u $WWW_USER_UID && \
    addgroup $WWW_USER root && \
    addgroup $WWW_USER adm && \
	apk add --update --no-cache \
	tzdata \
	#git wget curl nano zip unzip \
	supervisor \
	nginx \
	coreutils \
	php7 \
	php7-common \
	php7-fpm \
	php7-opcache \
	php7-mcrypt \
	php7-soap \
	php7-openssl \
	php7-session \
	php7-gmp \
	php7-pdo_odbc \
	php7-json \
	php7-dom \
	php7-pdo \
	php7-zip \
	php7-mysqli \
	php7-sqlite3 \
	php7-apcu \
	php7-pdo_pgsql \
	php7-bcmath \
	php7-gd \
	php7-odbc \
	php7-pdo_mysql \
	php7-pdo_sqlite \
	php7-gettext \
	php7-xmlreader \
	php7-xmlrpc \
	php7-bz2 \
	php7-iconv \
	php7-pdo_dblib \
	php7-curl \
	php7-ctype \
	php7-xdebug \
    php7-imagick \
    php7-intl \
    php7-fileinfo\
    php7-mbstring \
    php7-intl \
    php7-fileinfo\
    php7-mbstring \
    php7-xml \
    php7-zlib \
    php7-phar \
    php7-tokenizer \
    php7-simplexml \
    php7-xmlwriter \
	make \
	curl \
	&& mkdir -p /run/nginx \
	&& mkdir -p /etc/ssl/nginx \
	&& mkdir -p /var/www/html \ 
	&& chown -R $WWW_USER:$WWW_USER /var/www/html \
	#&& chown -R $WWW_USER:$WWW_USER /var/tmp/nginx \
	&& sed -i "s/ssl_session_cache shared:SSL:2m;/#ssl_session_cache shared:SSL:2m;/g" /etc/nginx/nginx.conf \
	&& sed -i "s/user nginx;/user ${WWW_USER};/g" /etc/nginx/nginx.conf \
	#&& sed -i "s/client_max_body_size 1m;/client_max_body_size 0;/g" /etc/nginx/nginx.conf \
	&& sed -i "s|;listen.mode\s*=\s*0660|listen.mode = 0660}|g" /etc/php7/php-fpm.d/www.conf \
	&& sed -i "s|;listen.owner\s*=\s*nobody|listen.owner = ${WWW_USER}|g" /etc/php7/php-fpm.d/www.conf \
	&& sed -i "s|;listen.group\s*=\s*nobody|listen.group = ${WWW_USER}|g" /etc/php7/php-fpm.d/www.conf \
	&& sed -i "s|user\s*=\s*nobody|user = ${WWW_USER}|g" /etc/php7/php-fpm.d/www.conf \
	&& sed -i "s|group\s*=\s*nobody|group = ${WWW_USER}|g" /etc/php7/php-fpm.d/www.conf \
	&& ln -sf /dev/stdout /var/log/nginx/access.log \
	&& ln -sf /dev/stderr /var/log/nginx/error.log \
	&& ln -sf /dev/stderr /var/log/php7/error.log \
	&& mkdir /entrypoint.d

RUN echo "$(curl -sS https://composer.github.io/installer.sig) -" > composer-setup.php.sig \
	&& curl -sS https://getcomposer.org/installer | tee composer-setup.php | sha384sum -c composer-setup.php.sig \
	&& php composer-setup.php && rm composer-setup.php* \
	&& chmod +x composer.phar && mv composer.phar /usr/bin/composer 

# Copy files and folders into image
COPY config/nginx_default.conf /etc/nginx/conf.d/default.conf
COPY config/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
COPY source /var/www/html
COPY symfony.ini /etc/php7/conf.d/
COPY symfony.ini /etc/php7/cli/conf.d/
COPY symfony.pool.conf /etc/php7/php-fpm.d/

CMD ["php-fpm7", "-F"]

#COPY entrypoint.sh /entrypoint.sh
#RUN chmod +x /entrypoint.sh

# Define workdir
WORKDIR /var/www/html

# Define mountable directories
VOLUME ["/etc/nginx/conf.d/","/etc/ssl/nginx","/var/www/html"]

# Expose ports
EXPOSE 80 443

# Define main command
#ENTRYPOINT ["/entrypoint.sh"]

# Define default command
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]
