
# Job09 - Registry Docker Local avec Interface Web

## Objectif

Déployer un registre Docker privé local et y adjoindre une interface web pour naviguer et gérer visuellement les images.

## Préparation

### Structure du projet

```text
Job09/
├── docker-compose.yml
└── Job09.md

```

### Fichier `docker-compose.yml`

```yaml
services:
  registry:
    image: registry:2
    container_name: job09_registry
    ports:
      - "5000:5000"
    volumes:
      - registry-data:/var/lib/registry

  registry-ui:
    image: joxit/docker-registry-ui:latest
    container_name: job09_registry-ui
    ports:
      - "8082:80"
    environment:
      - REGISTRY_TITLE=Local Registry
      - REGISTRY_URL=http://registry:5000
    depends_on:
      - registry

volumes:
  registry-data:

```

> Le volume `registry-data` conserve les données du registre entre les redémarrages.

## Étapes d'exécution

1.  **Positionnez-vous dans le dossier du job** :
    
    ```bash
    cd Job09
    
    ```
    
2.  **Démarrage des services** :
    
    ```bash
    docker compose up -d
    
    ```
    
3.  **Vérification de l’état** :
    
    ```bash
    docker compose ps
    
    ```
    
    Vous devriez voir :
    
    ```text
    Name                     Command                  State               Ports
    --------------------------------------------------------------------------------
    job09_registry_1         /entrypoint.sh /etc/...   Up      0.0.0.0:5000->5000/tcp
    job09_registry-ui_1      /docker-entrypoint.sh ... Up      0.0.0.0:8082->80/tcp
    
    ```
    

## Utilisation

### 1. Pousser une image dans le registre local

```bash
# Exemple avec l'image alpine
# 1) Télécharger l'image depuis Docker Hub
docker pull alpine:latest

# 2) Tagger l'image pour votre registre local
docker tag alpine:latest localhost:5000/alpine:latest

# 3) Pousser l'image dans le registre local
docker push localhost:5000/alpine:latest

```

### 2. Accéder à l’interface web

-   Ouvrez votre navigateur à l’adresse :  
    `http://localhost:8082`
    
-   Vous verrez le titre **Local Registry** et la liste des images présentes.
    

### 3. Récupérer une image depuis le registre local

```bash
# Supprimer les images locales pour tester
docker rmi alpine:latest localhost:5000/alpine:latest

# Pull depuis le registre privé
docker pull localhost:5000/alpine:latest

docker run --rm localhost:5000/alpine:latest echo "Hello from local registry"

```

## Nettoyage

Pour arrêter et supprimer les conteneurs et le volume :

```bash
docker-compose down -v

```