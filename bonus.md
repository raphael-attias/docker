bonus.md

Objectif

Reproduire XAMPP: Nginx/Apache+PHP, MariaDB, phpMyAdmin, FTP, volume commun.

docker-compose.yml
version: '3.8'
services:
  web:
    image: php:8.1-fpm-alpine
    volumes:
      - web-data:/var/www/html
  nginx:
    image: nginx:stable-alpine
    ports:
      - "8080:80"
    volumes:
      - web-data:/usr/share/nginx/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro
  db:
    image: mariadb:10.6
    environment:
      - MYSQL_ROOT_PASSWORD=rootpwd
      - MYSQL_DATABASE=appdb
  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - "8081:80"
    environment:
      - PMA_HOST=db
  ftp:
    image: fauria/vsftpd
    environment:
      - FTP_USER=user
      - FTP_PASS=pass
    volumes:
      - web-data:/home/user/www
volumes:
  web-data:

Commandes

docker-compose up -d