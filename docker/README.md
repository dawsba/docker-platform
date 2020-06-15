# AlpineLinux with NGINX 1.16 and PHP7.3 on x86_64 and arm

### Supported tags and respective `Dockerfile` links
-	[`latest` (*Dockerfile*)](https://github.com/Tob1asDocker/alpine-nginx-php/blob/master/alpine.x86_64.Dockerfile)
-	[`extended` (*Dockerfile*)](https://github.com/Tob1asDocker/alpine-nginx-php/blob/master/alpine.x86_64.extended.Dockerfile)
-	[`arm` (*Dockerfile*)](https://github.com/Tob1asDocker/alpine-nginx-php/blob/master/alpine.armhf.Dockerfile) (Raspberry Pi)
-	[`arm-extended` (*Dockerfile*)](https://github.com/Tob1asDocker/alpine-nginx-php/blob/master/alpine.armhf.extended.Dockerfile) (Raspberry Pi)

### Information:
AlpineLinux with NGINX and PHP7 on x86_64 and ARM
See https://wiki.alpinelinux.org/wiki/Nginx_with_PHP#PHP7_Installation for more information or to install more PHP packages!

### How to use this image (example)
 
```sh
docker run --name alpine-nginx-php-container -d -p 80:80 -v ${PWD}/html:/var/www/html -e PHP_ERRORS=1 -e PHP_UPLOAD_MAX_FILESIZE=250 tobi312/alpine-nginx-php:latest
 ``` 
  
An own Dockerfile?, then here an example with install git and copy own *entrypoint*-file(s):  

```sh
echo -e "FROM tobi312/alpine-nginx-php:latest\nRUN apk --no-cache add git\nCOPY *.sh /entrypoint.d/" > Dockerfile
```

### Environment Variables
* `TZ` (Default: Europe/Berlin)
* `PHP_ERRORS` (set 1 to enable)
* `PHP_MEM_LIMIT` (Value in MB)
* `PHP_POST_MAX_SIZE` (Value in MB)
* `PHP_UPLOAD_MAX_FILESIZE` (Value in MB)
* `PHP_MAX_FILE_UPLOADS` (number)

### This Image on
* [DockerHub](https://hub.docker.com/r/tobi312/alpine-nginx-php/)
* [GitHub](https://github.com/Tob1asDocker/alpine-nginx-php)
