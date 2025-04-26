
## Job11 - Utilisation de Portainer

Pour ce job, nous allons installer Portainer et explorer comment il peut faciliter la gestion de Docker.


### Fichier `docker compose.yml` pour Portainer

```
services:
  portainer:
    image: portainer/portainer-ce:latest
    container_name: portainer
    restart: unless-stopped
    security_opt:
      - no-new-privileges:true
    volumes:
      - /etc/localtime:/etc/localtime:ro
      - /var/run/docker.sock:/var/run/docker.sock
      - portainer_data:/data
    ports:
      - "9000:9000"

volumes:
  portainer_data:
```

> Ici, le volume `portainer_data` conserve la configuration et les données de Portainer.

## Installation et démarrage de Portainer

1.  **Se placer dans le dossier**
    
    ```
    cd Job11
    ```
    
2.  **Démarrer Portainer avec Docker Compose**
    
    ```
    docker compose up -d
    ```
    
3.  **Vérifier le statut**
    
    ```
    docker ps
    ```
    
    Vous devriez voir :
    
    ```
    Name       Command         State               Ports
    --------------------------------------------------------
    portainer  /portainer      Up                  0.0.0.0:9000->9000/tcp
    ```

2.  Accès à l'interface Portainer:

-   Ouvrez votre navigateur et accédez à: [http://localhost:9000](http://localhost:9000)

### Guide d'utilisation de Portainer pour les jobs précédents

#### Job 02 - Hello World via Portainer

1.  Dans Portainer, accédez à "Containers" dans le menu de gauche
2.  Cliquez sur "Add container" (Ajouter un conteneur)
3.  Nom: hello-world-test
4.  Image: hello-world
5.  Cliquez sur "Deploy the container" (Déployer le conteneur)
6.  Vérifiez les logs du conteneur pour voir le message Hello World

#### Job 03 - Créer un conteneur "helloworld" personnalisé

1.  Dans Portainer, accédez à "Images" dans le menu de gauche
2.  Cliquez sur "Build a new image" (Construire une nouvelle image)
3.  Nom: custom-helloworld
4.  Copiez-collez le contenu du Dockerfile créé précédemment
5.  Cliquez sur "Build the image" (Construire l'image)
6.  Après la construction, allez dans "Containers" → "Add container"
7.  Nom: custom-hello
8.  Image: custom-helloworld
9.  Déployez et vérifiez les logs

#### Job 04 - Image SSH via Portainer

1.  Dans Portainer, allez dans "Images" → "Build a new image"
2.  Nom: ssh-container
3.  Copiez-collez le Dockerfile SSH créé précédemment
4.  Construisez l'image
5.  Créez un nouveau conteneur avec cette image
6.  Dans la configuration, mappez le port 2222 de l'hôte vers le port 22 du conteneur
7.  Déployez et testez la connexion SSH

#### Job 06 - Volumes Docker via Portainer

1.  Dans Portainer, accédez à "Volumes" dans le menu de gauche
2.  Cliquez sur "Add volume" (Ajouter un volume)
3.  Nom: data-volume
4.  Créez le volume
5.  Créez deux conteneurs qui partagent ce volume en configurant le montage dans l'interface

#### Job 07 - Nginx et FTP via docker-compose dans Portainer

1.  Dans Portainer, accédez à "Stacks" dans le menu de gauche
2.  Cliquez sur "Add stack" (Ajouter une pile)
3.  Nom: nginx-ftp-stack
4.  Copiez-collez le fichier docker-compose.yml créé précédemment
5.  Déployez la pile et vérifiez l'état des services

#### Job 08 - Conteneur Nginx personnalisé

1.  Dans Portainer, allez dans "Images" → "Build a new image"
2.  Nom: custom-nginx
3.  Copiez-collez le Dockerfile Nginx créé précédemment
4.  Construisez l'image
5.  Créez un conteneur avec cette image en mappant le port 8080

#### Job 09 - Registry Docker avec UI

1.  Dans Portainer, accédez à "Stacks"
2.  Ajoutez une nouvelle pile nommée "registry-stack"
3.  Copiez-collez le fichier docker-compose.yml du registry
4.  Déployez et utilisez l'interface pour gérer vos images

### Alternatives à Portainer

Il existe plusieurs alternatives à Portainer pour la gestion de conteneurs Docker:

1.  **Rancher** - Une plateforme complète de gestion pour Kubernetes et Docker
2.  **Yacht** - Une interface simple et moderne pour Docker
3.  **Dockstation** - Une application desktop pour gérer Docker
4.  **Lazydocker** - Une interface en ligne de commande plus simple
5.  **Kitematic** - Développé par Docker lui-même (moins maintenu)
6.  **Porteus** - Une autre interface web pour Docker
7.  **DockPanel** - Interface légère pour Docker