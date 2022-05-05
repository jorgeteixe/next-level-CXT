FROM alpine:3.14 as unzip

RUN apk add --no-cache unzip

WORKDIR /root/hesk
ADD hesk325.zip .

RUN unzip hesk325.zip && rm hesk325.zip

FROM php:8.1-apache

# add mysql php extension
RUN docker-php-ext-install mysqli pdo pdo_mysql && docker-php-ext-enable pdo_mysql

COPY --from=unzip /root/hesk /var/www/html/

# folder permissions for hesk
RUN chmod 666 /var/www/html/hesk_settings.inc.php \
  && chmod -R 777 /var/www/html/attachments \
  && chmod -R 777 /var/www/html/cache

EXPOSE 80
