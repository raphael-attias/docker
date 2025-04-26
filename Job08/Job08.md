
# Job08 - Conteneur Nginx via Dockerfile personnalisée

## Objectif

Construire un conteneur Docker Nginx à partir d'une image de base Debian (sans utiliser l'image officielle nginx), déployer une configuration personnalisée, rediriger le port 80 et tester la connexion.

## Préparation

### Structure du projet

```
Job08/
├── Job08.Dockerfile
├── default.conf    # Configuration du serveur Nginx
└── Job08.md

```

### Fichier `Dockerfile`

```
# Image de base légère Debian
FROM debian:stable-slim

# Installer Nginx sans cache des listes
RUN apt-get update \
    && apt-get install -y nginx \
    && rm -rf /var/lib/apt/lists/*

# Copier notre configuration personnalisée\ nCOPY default.conf /etc/nginx/conf.d/default.conf

# Exposer le port HTTP
EXPOSE 80

# Démarrer Nginx en mode premier plan
CMD ["nginx", "-g", "daemon off;"]
```

### Fichier `default.conf`

```
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /usr/share/nginx/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    # Logs
    access_log /var/log/nginx/access.log;
    error_log  /var/log/nginx/error.log;
}
```

> **Note** : Si vous n’ajoutez pas de contenu personnalisé dans `/usr/share/nginx/html`, Nginx servira sa page d’accueil par défaut.

## Étapes d'exécution

1.  **Se placer dans le répertoire**
    
    ```
    cd Job08
    ```
    
2.  **Construire l’image**
    
    ```
    docker build -t custom-nginx .
    ```
    
    Vérifiez l’existence de l’image :
    
    ```
    docker images custom-nginx
    ```
    
3.  **Lancer le conteneur**
    
    ```
    docker run -d --name nginx-custom -p 8080:80 custom-nginx
    ```
    
4.  **Tester la page**
    
    -   Via curl :
        
        ```
        curl http://localhost:8080
        ```
        
    -   Dans un navigateur, ouvrez `http://localhost:8080`.
        

## Problèmes courants et solutions

-   **Port occupé** : changez le mapping (`-p 8081:80`) ou libérez le port.
    
-   **Erreur de configuration** : entrez dans le conteneur pour tester `nginx -t` :
    
    ```
    docker exec -it nginx-custom bash
    nginx -t
    ```
    

## Nettoyage

```
docker stop nginx-custom && docker rm nginx-custom
docker rmi custom-nginx
```