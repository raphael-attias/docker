
# Job07 - Docker Compose avec Nginx et FTP

## Objectif

Mettre en place deux conteneurs Docker (Nginx et FTP) partageant un volume nommé pour permettre :

1.  L’envoi d’un fichier HTML via FTP.
    
2.  La diffusion de ce fichier par Nginx sur le port 8080.
    

## Prérequis

-   Docker et Docker Compose installés et fonctionnels.
    
-   Client FTP (FileZilla, lftp, ou FTP en ligne de commande).
    
-   Terminal Bash.
    

## Structure du projet

```text
Job07/
├── docker-compose.yml
└── Job07.md

```

## Fichier `docker-compose.yml`

```yaml
services:
  nginx:
    image: nginx:stable-alpine
    container_name: job07_nginx
    ports:
      - "8080:80"
    volumes:
      - web-data:/usr/share/nginx/html:ro
    networks:
      - app-network

  ftp:
    image: fauria/vsftpd
    container_name: job07_ftp
    user: root
    environment:
      FTP_USER: devops
      FTP_PASS: dp1234
      PASV_ADDRESS: localhost
      PASV_MIN_PORT: 30000
      PASV_MAX_PORT: 30009
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    volumes:
      - web-data:/home/devops/www
    networks:
      - app-network

volumes:
  web-data:

networks:
  app-network:

```

> **Note :** Le volume `web-data` est monté en lecture Seule (`:ro`) par Nginx, et en lecture/écriture par le conteneur FTP.

## Étapes d’exécution

1.  **Démarrage des services**
    
    ```bash
    cd Job07
    docker compose up -d
    
    ```
    
2.  **Vérification de l’état**
    
    ```bash
    docker compose ps
    
    ```
    
    Vous devriez voir deux conteneurs **Up** :
    
    ```text
    Name           Command               State               Ports
    --------------------------------------------------------------------
    job07_ftp_1    /usr/sbin/vsftpd ...   Up    0.0.0.0:21->21/tcp, 0.0.0.0:30000-30009->30000-30009/tcp
    job07_nginx_1  nginx -g 'daemon ...   Up    0.0.0.0:8080->80/tcp
    
    ```
    
3.  **Connexion FTP et upload**
    
    -   **Hôte** : `localhost`
        
    -   **Utilisateur** : `devops`
        
    -   **Mot de passe** : `dp1234`
        
    -   **Port** : `21`
        
    
    Envoyez un fichier **index.html** dans le répertoire racine FTP (`/home/devops/www`).
    
4.  **Vérification via HTTP** Ouvrez un navigateur et rendez-vous sur :  
    `http://localhost:8080`  
    Vous devriez voir le contenu de votre `index.html`.
    

## Problèmes courants et solutions

-   **Impossible de se connecter en FTP**
    
    -   Vérifiez que les ports **21** et **30000–30009** sont bien exposés (`docker compose ps`).
        
    -   Si le mode passif bloque, ajustez `PASV_ADDRESS` sur votre IP publique ou locale.
        
-   **Page Nginx non accessible**
    
    -   Vérifiez que le volume `web-data` contient votre fichier :
        
        ```bash
        docker run --rm -v job-07_web-data:/data busybox ls /data
        
        ```
        
    -   Assurez-vous que Nginx a les droits de lecture (montage en `:ro`).
        

## Nettoyage

Pour arrêter et supprimer les conteneurs, réseaux et volumes :

```bash
docker compose down -v

```