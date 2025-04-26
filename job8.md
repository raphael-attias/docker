# Job 08 - Créer un conteneur Nginx via Dockerfile

## Objectif
Créer un conteneur Nginx personnalisé en partant d'une image de base Debian (sans utiliser une image Nginx existante), rediriger les ports et tester la connexion.

## Préparation

### Structure du projet
```
job-08/
├── Dockerfile
├── nginx.conf        # Configuration Nginx personnalisée
└── html/
    └── index.html    # Page de test
```

### Dockerfile
```Dockerfile
# Utiliser Debian comme image de base
FROM debian:bullseye-slim

# Éviter les interactions utilisateur pendant l'installation
ENV DEBIAN_FRONTEND=noninteractive

# Mettre à jour les paquets et installer Nginx
RUN apt-get update && apt-get install -y \
    nginx \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Supprimer la configuration par défaut
RUN rm /etc/nginx/sites-enabled/default

# Copier notre configuration personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Créer un répertoire pour les logs
RUN mkdir -p /var/log/nginx

# Copier notre contenu web
COPY html/ /var/www/html/

# Exposer le port 80
EXPOSE 80

# Commande pour démarrer Nginx en premier plan
CMD ["nginx", "-g", "daemon off;"]
```

### nginx.conf
```nginx
server {
    listen 80 default_server;
    listen [::]:80 default_server;

    root /var/www/html;
    index index.html;

    server_name _;

    location / {
        try_files $uri $uri/ =404;
    }

    # Configuration de logs pour le débogage
    access_log /var/log/nginx/access.log;
    error_log /var/log/nginx/error.log;
}
```

### index.html
```html
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job 08 - Nginx via Dockerfile</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
            background-color: #f5f5f5;
        }
        h1 {
            color: #2c3e50;
            border-bottom: 2px solid #3498db;
            padding-bottom: 10px;
        }
        .container {
            background-color: white;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0,0,0,0.1);
        }
    </style>
</head>
<body>
    <div class="container">
        <h1>Nginx installé via Dockerfile</h1>
        <p>Cette page est servie par un conteneur Nginx personnalisé construit à partir d'une image Debian.</p>
        <p>Le serveur a été configuré manuellement dans le Dockerfile sans utiliser l'image officielle Nginx.</p>
    </div>
</body>
</html>
```

## Étapes d'exécution

### 1. Préparation des fichiers

Créez la structure de dossiers et les fichiers nécessaires :

```bash
mkdir -p job-08/html
cd job-08
```

Créez les fichiers `Dockerfile`, `nginx.conf` et `html/index.html` avec le contenu indiqué ci-dessus.

### 2. Construction de l'image

Construisez l'image Docker avec la commande :

```bash
docker build -t custom-nginx .
```

Vérifiez que l'image a été créée :

```bash
docker images | grep custom-nginx
```

Résultat attendu :
```
custom-nginx   latest    [IMAGE ID]   [CREATED TIME]   [SIZE]
```

### 3. Lancement du conteneur

Lancez le conteneur en redirigeant le port 80 du conteneur vers le port 8081 de l'hôte :

```bash
docker run -d -p 8081:80 --name nginx-custom custom-nginx
```

Vérifiez que le conteneur est en cours d'exécution :

```bash
docker ps | grep nginx-custom
```

### 4. Test de la connexion

Testez la connexion au serveur Nginx :

```bash
curl http://localhost:8081
```

Vous pouvez également ouvrir un navigateur et accéder à `http://localhost:8081` pour voir la page HTML.

### 5. Vérification des logs

Si nécessaire, consultez les logs du conteneur pour déboguer :

```bash
docker logs nginx-custom
```

Pour accéder au shell du conteneur :

```bash
docker exec -it nginx-custom bash
```

## Problèmes courants et solutions

### Erreur "Address already in use"

Si le port est déjà utilisé, vous verrez une erreur comme celle-ci :
```
Error response from daemon: driver failed programming external connectivity on endpoint nginx-custom: Error starting userland proxy: listen tcp4 0.0.0.0:8081: bind: address already in use
```

Solution : changez le port de redirection ou arrêtez le service qui utilise déjà ce port.

```bash
docker run -d -p 8082:80 --name nginx-custom custom-nginx
```

### Erreur de démarrage de Nginx

Si Nginx ne démarre pas correctement :

1. Vérifiez les logs du conteneur :
   ```bash
   docker logs nginx-custom
   ```

2. Accédez au conteneur et vérifiez la configuration :
   ```bash
   docker exec -it nginx-custom bash
   nginx -t  # Teste la configuration
   ```

## Nettoyage

Pour arrêter et supprimer le conteneur :

```bash
docker stop nginx-custom
docker rm nginx-custom
```

Pour supprimer l'image :

```bash
docker rmi custom-nginx
```