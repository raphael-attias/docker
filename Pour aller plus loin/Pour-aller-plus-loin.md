
# Pour aller plus loin

## Objectif

Reproduire un environnement type XAMPP :

-   Serveur PHP (Nginx/Apache + PHP-FPM)
    
-   Base de données MariaDB
    
-   Interface phpMyAdmin
    
-   Serveur FTP
    
-   Volume partagé pour le site web
    

## Fichier `docker-compose.yml`

```yaml
services:
  web:
    image: php:8.1-fpm-alpine
    container_name: web-php
    volumes:
      - web-data:/var/www/html

  nginx:
    image: nginx:stable-alpine
    container_name: web-nginx
    ports:
      - "8080:80"
    volumes:
      - web-data:/usr/share/nginx/html
      - ./nginx/default.conf:/etc/nginx/conf.d/default.conf:ro

  db:
    image: mariadb:10.6
    container_name: db-mariadb
    environment:
      - MYSQL_ROOT_PASSWORD=rootpwd
      - MYSQL_DATABASE=appdb1234

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    container_name: web-phpmyadmin
    ports:
      - "8081:80"
    environment:
      - PMA_HOST=db
    depends_on:
      - db

  ftp:
    image: fauria/vsftpd
    container_name: web-ftp
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    environment:
      - FTP_USER=user
      - FTP_PASS=pass1234
    volumes:
      - web-data:/home/user/www
    depends_on:
      - web

volumes:
  web-data:

```

> Le volume `web-data` permet de partager le contenu du site entre PHP-FPM, Nginx et le FTP.

## Commandes de démarrage

```bash
docker compose up -d

```

-   **Nginx** : [http://localhost:8080](http://localhost:8080/)
    
-   **phpMyAdmin** : [http://localhost:8081](http://localhost:8081/) (login root / rootpwd)
    
-   **FTP** (passif) : user/pass1234 sur localhost:21