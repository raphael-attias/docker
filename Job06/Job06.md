
# Job06 - Utilisation et gestion des volumes Docker

## Objectif

Se renseigner et mettre en pratique l’utilisation de volumes Docker pour partager des données entre deux conteneurs, et comprendre la gestion des volumes.

## Prérequis

-   Docker installé et fonctionnel (voir Job 01)
    
-   Connaissances de base sur les conteneurs Docker
    
-   Terminal Bash
    

## Concepts clés

-   **Volume Docker** : espace de stockage persistant géré par Docker, indépendant du cycle de vie des conteneurs.
    
-   **Bind mount** : montage d’un répertoire hôte dans le conteneur.
    
-   **Named volume** : volume géré par Docker, identifié par un nom.
    

## Étapes détaillées

### 1. Créer un volume nommé

```
# Créer un volume Docker nommé "shared_data"
docker volume create shared_data

# Vérifier la création du volume
docker volume ls
```

### 2. Lancer deux conteneurs partageant ce volume

```
# Conteneur A : écrit un fichier dans /data
docker run -d --name writer \
  -v shared_data:/data \
  alpine sh -c "echo 'Hello from writer' > /data/message.txt && sleep 3600"

# Conteneur B : lit le fichier depuis /data
docker run -d --name reader \
  -v shared_data:/data \
  alpine tail -f /data/message.txt

docker logs reader  # afficher le contenu du fichier
```

### 3. Utiliser un bind mount (montage de répertoire hôte)

```
# Créer un dossier sur l'hôte à partager
mkdir -p ~/docker-shared
echo "Local file" > ~/docker-shared/local.txt

# Démarrer un conteneur qui lit le contenu du dossier hôte
docker run --rm -v ~/docker-shared:/mnt/host alpine ls /mnt/host
```

### 4. Gestion et inspection des volumes

```
# Inspecter un volume nommé
docker volume inspect shared_data

# Vérifier la taille et l'utilisation (requiert plugin docker-system
# ou utilisation de 'docker system df')
docker system df --volumes
```

### 5. Nettoyage des volumes

```
# Supprimer un volume spécifique (doit être non monté)
docker volume rm shared_data

# Supprimer tous les volumes inutilisés
docker volume prune -f
```