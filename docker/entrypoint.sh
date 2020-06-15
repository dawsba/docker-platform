#!/bin/sh
#set -e

# Set TimeZone
if [ ! -z "$TZ" ]; then
	echo ">> set timezone"
	cp /usr/share/zoneinfo/${TZ} /etc/localtime
	echo ${TZ} > /etc/timezone
	date
	sed -i "s|;*date.timezone =.*|date.timezone = ${TZ}|i" /etc/php7/php.ini
fi

# Display PHP error's or not
if [[ "$PHP_ERRORS" == "1" ]] ; then
	echo ">> set display_errors"
	sed -i "s|display_errors\s*=\s*Off|display_errors = On|i" /etc/php7/php.ini
fi

# Display Startup PHP error's or not
if [[ "$PHP__STARTUP_ERRORS" == "1" ]] ; then
	echo ">> set display_startup_errors"
	sed -i "s|display_startup_errors\s*=\s*Off|display_startup_errors = On|i" /etc/php7/php.ini
fi

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
	echo ">> set memory_limit"
	sed -i "s|;*memory_limit =.*|memory_limit = ${PHP_MEM_LIMIT}M|i" /etc/php7/php.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
	echo ">> set post_max_size"
	sed -i "s|;*post_max_size =.*|post_max_size = ${PHP_POST_MAX_SIZE}M|i" /etc/php7/php.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
	echo ">> set upload_max_filesize"
	sed -i "s|;*upload_max_filesize =.*|upload_max_filesize = ${PHP_UPLOAD_MAX_FILESIZE}M|i" /etc/php7/php.ini
fi

# Increase the max_file_uploads
if [ ! -z "$PHP_MAX_FILE_UPLOADS" ]; then
	echo ">> set max_file_uploads"
	sed -i "s|;*max_file_uploads =.*|max_file_uploads = ${PHP_MAX_FILE_UPLOADS}|i" /etc/php7/php.ini
fi

# more entrypoint-files
for f in /entrypoint.d/*; do
	if [ -e "$f" ] ; then
		chmod +x $f
		/bin/sh $f
	fi
done

# exec CMD
echo ">> exec docker CMD"
echo "$@"
exec "$@"
