# Job 09 - Registry Docker Local avec Interface Web

## Objectif
Créer et utiliser un registre local Docker (registry) et y ajouter une interface web pour la gestion visuelle du registre.

## Préparation

### Structure du projet
```
job-09/
└── docker-compose.yml
```

### Fichier docker-compose.yml
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
      REGISTRY_STORAGE_DELETE_ENABLED: "true"  # Permet la suppression d'images
    networks:
      - registry_network

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
    networks:
      - registry_network

volumes:
  registry_data:

networks:
  registry_network:
```

## Étapes d'exécution

### 1. Préparation des fichiers

Créez le dossier pour le projet et le fichier docker-compose :

```bash
mkdir -p job-09
cd job-09
```

Créez le fichier `docker-compose.yml` avec le contenu indiqué ci-dessus.

### 2. Démarrage du registry et de l'interface

Lancez les services avec Docker Compose :

```bash
docker-compose up -d
```

Vérifiez que les conteneurs sont en cours d'exécution :

```bash
docker-compose ps
```

Résultat attendu :
```
     Name                    Command               State           Ports         
--------------------------------------------------------------------------------
job-09_registry_1      /entrypoint.sh /etc/docker ...   Up      0.0.0.0:5000->5000/tcp
job-09_registry-ui_1   /docker-entrypoint.sh ngin ...   Up      0.0.0.0:8082->80/tcp
```

### 3. Test du registry

#### a. Tester le registre avec une image test

Commencez par télécharger une image de test, la tagger pour votre registre local et la pousser :

```bash
# Télécharger une image Alpine
docker pull alpine:latest

# Tagger l'image pour le registre local
docker tag alpine:latest localhost:5000/alpine:latest

# Pousser l'image vers le registre local
docker push localhost:5000/alpine:latest
```

#### b. Vérifier que l'image est dans le registre

Vérifiez via l'API du registre que l'image est bien présente :

```bash
curl http://localhost:5000/v2/_catalog
```

Résultat attendu :
```json
{"repositories":["alpine"]}
```

Pour voir les tags disponibles pour cette image :

```bash
curl http://localhost:5000/v2/alpine/tags/list
```

Résultat attendu :
```json
{"name":"alpine","tags":["latest"]}
```

### 4. Utilisation de l'interface web

1. Ouvrez votre navigateur et accédez à `http://localhost:8082`
2. L'interface vous montrera les images disponibles dans votre registre local
3. Vous pouvez explorer les couches des images et leurs métadonnées

### 5. Tester l'utilisation d'une image du registre local

Pour tirer (pull) et utiliser une image de votre registre local :

```bash
# Supprimer l'image locale pour tester le pull
docker rmi localhost:5000/alpine:latest
docker rmi alpine:latest

# Tirer l'image depuis le registre local
docker pull localhost:5000/alpine:latest

# Tester l'image
docker run --rm localhost:5000/alpine:latest echo "Hello from local registry image!"
```

## Configuration pour utiliser le registre en production

### Sécuriser le registre (optionnel pour un environnement de développement)

Pour un environnement de production, il est recommandé de sécuriser le registre avec HTTPS. Voici les étapes à suivre :

1. Ajouter des certificats TLS
2. Configurer l'authentification

Modifiez alors le fichier docker-compose.yml pour ajouter ces configurations.

### Configurer Docker pour accepter un registre non sécurisé (pour développement uniquement)

Si vous utilisez le registre sans HTTPS en développement, vous devez configurer Docker pour accepter un registre "insecure" :

```bash
# Créer ou modifier le fichier /etc/docker/daemon.json
sudo nano /etc/docker/daemon.json
```

Ajoutez ou modifiez le contenu comme suit :
```json
{
  "insecure-registries": ["localhost:5000"]
}
```

Puis redémarrez Docker :
```bash
sudo systemctl restart docker
```

## Problèmes courants et solutions

### Erreur de connexion au registre

Si vous rencontrez des erreurs lors du push ou du pull :

1. Vérifiez que le registre est en cours d'exécution :
   ```bash
   docker-compose ps
   ```

2. Vérifiez que vous avez configuré Docker pour accepter le registre non sécurisé :
   ```bash
   cat /etc/docker/daemon.json
   ```

3. Vérifiez les logs du registre :
   ```bash
   docker-compose logs registry
   ```

### Erreur d'accès à l'UI

Si vous ne pouvez pas accéder à l'interface web :

1. Vérifiez que le conteneur UI est en cours d'exécution :
   ```bash
   docker-compose ps registry-ui
   ```

2. Vérifiez les logs de l'UI :
   ```bash
   docker-compose logs registry-ui
   ```

## Nettoyage

Pour arrêter et supprimer les conteneurs, réseaux et volumes :

```bash
docker-compose down -v
```