# Job 11 - Portainer et alternatives

## Objectif
Installer et utiliser Portainer pour refaire les Jobs 2 à 9 via l'interface graphique, puis explorer les alternatives à Portainer.

## Préparation

### Structure du projet
```
job-11/
├── docker-compose.yml     # Pour déployer Portainer
└── alternatives.md        # Documentation sur les alternatives à Portainer
```

### Fichier docker-compose.yml pour Portainer
```yaml
version: '3'

services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock:ro
      - portainer_data:/data
    ports:
      - "9000:9000"

volumes:
  portainer_data:
```

## Étapes d'installation et configuration de Portainer

### 1. Préparation des fichiers

Créez la structure de dossiers et le fichier docker-compose.yml :

```bash
mkdir -p job-11
cd job-11
```

Créez le fichier `docker-compose.yml` avec le contenu indiqué ci-dessus.

### 2. Déploiement de Portainer

Lancez Portainer avec Docker Compose :

```bash
docker-compose up -d
```

Vérifiez que le conteneur est en cours d'exécution :

```bash
docker-compose ps
```

Résultat attendu :
```
   Name                 Command               State           Ports         
-------------------------------------------------------------------------
portainer   /portainer                        Up      0.0.0.0:9000->9000/tcp
```

### 3. Configuration initiale de Portainer

1. Ouvrez votre navigateur et accédez à `http://localhost:9000`
2. Créez un compte administrateur lors de la première connexion :
   - Définissez un nom d'utilisateur (généralement "admin")
   - Créez un mot de passe fort (au moins 12 caractères)
3. Choisissez "Local" comme environnement Docker à gérer

## Réalisation des Jobs 2 à 9 avec Portainer

Voici comment réaliser les Jobs précédents en utilisant l'interface graphique de Portainer.

### Job 07 - Nginx et FTP avec volume partagé

1. **Création du volume :**
   - Dans le menu latéral, cliquez sur "Volumes"
   - Cliquez sur "Add Volume"
   - Nommez-le "web_data"
   - Cliquez sur "Create the volume"

2. **Création du réseau :**
   - Dans le menu latéral, cliquez sur "Networks"
   - Cliquez sur "Add network"
   - Nommez-le "app_network"
   - Cliquez sur "Create the network"

3. **Déploiement du conteneur Nginx :**
   - Dans le menu latéral, cliquez sur "Containers"
   - Cliquez sur "Add container"
   - Nom : nginx-web
   - Image : nginx:latest
   - Port mapping : 8080:80
   - Network : Sélectionnez "app_network"
   - Dans "Advanced container settings" > "Volumes", configurez :
     - Sélectionnez le volume "web_data"
     - Container path : /usr/share/nginx/html
   - Cliquez sur "Deploy the container"

4. **Déploiement du conteneur FTP :**
   - Dans le menu latéral, cliquez sur "Containers"
   - Cliquez sur "Add container"
   - Nom : ftp-server
   - Image : stilliard/pure-ftpd:latest
   - Port mapping : 
     - 21:21
     - 30000-30009:30000-30009
   - Network : Sélectionnez "app_network"
   - Dans "Advanced container settings" > "Volumes", configurez :
     - Sélectionnez le volume "web_data"
     - Container path : /home/ftpuser
   - Dans "Advanced container settings" > "Env", ajoutez :
     - PUBLICHOST=localhost
     - FTP_USER_NAME=ftpuser
     - FTP_USER_PASS=ftppassword
     - FTP_USER_HOME=/home/ftpuser
   - Cliquez sur "Deploy the container"

5. **Création du fichier index.html :**
   - Connectez-vous au conteneur Nginx via Portainer :
     - Cliquez sur le conteneur "nginx-web"
     - Onglet "Console" > "Connect" (shell)
     - Utilisez "sh" comme commande et connectez-vous
   - Créez le fichier index.html :
     ```bash
     echo '<!DOCTYPE html>
     <html>
     <head>
         <title>Job 07 via Portainer</title>
     </head>
     <body>
         <h1>Job 07 - Nginx et FTP</h1>
         <p>Cette page a été créée via Portainer par [VOTRE NOM]</p>
     </body>
     </html>' > /usr/share/nginx/html/index.html
     ```

6. **Test du service :**
   - Accédez à `http://localhost:8080` pour vérifier que Nginx sert bien votre page
   - Utilisez FileZilla pour vous connecter au serveur FTP avec les identifiants configurés

### Job 08 - Nginx avec Dockerfile

1. **Création d'un nouveau Dockerfile :**
   - Dans le menu latéral, cliquez sur "Stacks"
   - Cliquez sur "Add stack"
   - Nommez-le "custom-nginx"
   - Ajoutez le contenu suivant dans l'éditeur :
     ```yaml
     version: '3'
     
     services:
       custom-nginx:
         build:
           context: .
           dockerfile: Dockerfile
         ports:
           - "8081:80"
         volumes:
           - nginx_data:/var/www/html
     
     volumes:
       nginx_data:
     ```
   - Dans l'onglet "Web editor", créez un nouveau fichier "Dockerfile" :
     ```Dockerfile
     FROM debian:bullseye-slim
     
     ENV DEBIAN_FRONTEND=noninteractive
     
     RUN apt-get update && apt-get install -y \
         nginx \
         && apt-get clean \
         && rm -rf /var/lib/apt/lists/*
     
     RUN rm /etc/nginx/sites-enabled/default
     
     RUN echo 'server { \
         listen 80 default_server; \
         listen [::]:80 default_server; \
         root /var/www/html; \
         index index.html; \
         server_name _; \
         location / { \
             try_files $uri $uri/ =404; \
         } \
     }' > /etc/nginx/conf.d/default.conf
     
     RUN mkdir -p /var/www/html
     
     RUN echo '<!DOCTYPE html> \
     <html> \
     <head> \
         <title>Custom Nginx via Portainer</title> \
     </head> \
     <body> \
         <h1>Job 08 - Custom Nginx via Dockerfile</h1> \
         <p>Cette page est servie par un conteneur Nginx personnalisé</p> \
     </body> \
     </html>' > /var/www/html/index.html
     
     EXPOSE 80
     
     CMD ["nginx", "-g", "daemon off;"]
     ```
   
   - Cliquez sur "Deploy the stack"

2. **Test du service :**
   - Accédez à `http://localhost:8081` pour vérifier que votre conteneur Nginx personnalisé fonctionne

### Job 09 - Registry Local avec interface web

1. **Création du stack pour le Registry :**
   - Dans le menu latéral, cliquez sur "Stacks"
   - Cliquez sur "Add stack"
   - Nommez-le "docker-registry"
   - Ajoutez le contenu suivant dans l'éditeur :
     ```yaml
     version: '3'
     
     services:
       registry:
         image: registry:2
         ports:
           - "5000:5000"
         volumes:
           - registry_data:/var/lib/registry
         restart: always
         environment:
           REGISTRY_STORAGE_DELETE_ENABLED: "true"
     
       registry-ui:
         image: joxit/docker-registry-ui:latest
         ports:
           - "8082:80"
         environment:
           - REGISTRY_URL=http://registry:5000
           - REGISTRY_TITLE=Registry Local
           - SINGLE_REGISTRY=true
           - DELETE_IMAGES=true
         depends_on:
           - registry
     
     volumes:
       registry_data:
     ```
   
   - Cliquez sur "Deploy the stack"

2. **Test du Registry :**
   - Accédez à `http://localhost:8082` pour accéder à l'interface web du registry
   - Pour pousser une image dans le registry, utilisez le terminal de votre machine hôte :
     ```bash
     docker pull alpine:latest
     docker tag alpine:latest localhost:5000/alpine:latest
     docker push localhost:5000/alpine:latest
     ```
   - Rafraîchissez l'interface web pour voir l'image ajoutée

## Alternatives à Portainer

Portainer est une solution populaire pour la gestion de Docker, mais il existe plusieurs alternatives qui peuvent mieux convenir selon vos besoins spécifiques.

### 1. Docker Desktop

**Description :** Docker Desktop est l'outil officiel de Docker qui combine moteur Docker et interface graphique.

**Avantages :**
- Interface intuitive et bien intégrée
- Support officiel de Docker Inc.
- Extensions disponibles
- Inclut Kubernetes pour les systèmes locaux
- Idéal pour les environnements de développement

**Inconvénients :**
- Uniquement disponible pour Windows et macOS (pas pour Linux serveur)
- Certaines fonctionnalités sont payantes pour les entreprises
- Consomme plus de ressources que d'autres solutions

**Site web :** [Docker Desktop](https://www.docker.com/products/docker-desktop/)

### 2. Rancher Desktop

**Description :** Alternative open-source à Docker Desktop, focalisée sur Kubernetes mais avec support Docker.

**Avantages :**
- 100% open-source et gratuit
- Fonctionne sur Windows, macOS et Linux
- Intègre Kubernetes et Docker
- Développé par SUSE
- Interface utilisateur moderne

**Inconvénients :**
- Moins mature que Docker Desktop
- Peut être plus complexe pour les débutants

**Site web :** [Rancher Desktop](https://rancherdesktop.io/)

### 3. Lazydocker

**Description :** Interface TUI (Terminal User Interface) pour Docker, idéale pour les utilisateurs qui préfèrent rester dans le terminal.

**Avantages :**
- Léger et rapide
- Interface dans le terminal (pas besoin de navigateur)
- Excellent pour les serveurs distants
- Très efficace pour les utilisateurs avancés

**Inconvénients :**
- Courbe d'apprentissage plus raide
- Moins intuitif pour les débutants
- Moins de fonctionnalités graphiques avancées

**Site web :** [Lazydocker GitHub](https://github.com/jesseduffield/lazydocker)

### 4. Yacht

**Description :** Interface web moderne et légère pour gérer les conteneurs Docker.

**Avantages :**
- Interface web minimaliste et moderne
- Facile à installer et à utiliser
- Consomme peu de ressources
- Open-source

**Inconvénients :**
- Moins de fonctionnalités que Portainer
- Communauté plus petite
- Développement moins actif

**Site web :** [Yacht GitHub](https://github.com/SelfhostedPro/Yacht)

### 5. DockStation

**Description :** Application desktop pour gérer les projets Docker.

**Avantages :**
- Interface graphique riche
- Gestion des projets Docker Compose
- Visualisation des logs et statistiques
- Disponible pour Windows, macOS et Linux

**Inconvénients :**
- Ne fonctionne que sur des machines avec interface graphique
- Développement moins actif récemment

**Site web :** [DockStation](https://dockstation.io/)

### 6. Podman Desktop

**Description :** Alternative à Docker basée sur Podman, avec une interface graphique.

**Avantages :**
- Fonctionne sans démon (rootless)
- Compatible avec les conteneurs OCI
- Interface similaire à Docker Desktop
- Développé par Red Hat

**Inconvénients :**
- Compatibilité Docker pas toujours parfaite
- Écosystème moins mature

**Site web :** [Podman Desktop](https://podman-desktop.io/)

### Tableau comparatif

| Fonctionnalité | Portainer | Docker Desktop | Rancher Desktop | Lazydocker | Yacht | DockStation | Podman Desktop |
|----------------|-----------|---------------|-----------------|------------|-------|-------------|----------------|
| Type d'interface | Web | GUI | GUI | TUI | Web | GUI | GUI |
| Open-source | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Linux | ✅ | ❌ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Windows | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| macOS | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ | ✅ |
| Support Kubernetes | ✅ (CE+ / BE) | ✅ | ✅ | ❌ | ❌ | ❌ | ✅ |
| Légèreté | Moyen | Lourd | Moyen | Très léger | Léger | Moyen | Moyen |
| Facilité d'utilisation | ✅✅ | ✅✅✅ | ✅✅ | ✅ | ✅✅ | ✅✅ | ✅✅ |
| Gestion multi-environnement | ✅✅✅ | ❌ | ✅ | ❌ | ✅ | ✅ | ❌ |

## Nettoyage

Pour arrêter et supprimer Portainer :

```bash
cd job-11
docker-compose down -v
```