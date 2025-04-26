# Job 02 - Test de l'installation Docker avec hello-world

## Objectif

Tester l'installation de Docker avec le conteneur `hello-world` et se familiariser avec les commandes Docker de base.

## Prérequis

-   Docker installé (voir Job 01)
    
-   Connexion Internet fonctionnelle
    

## Étapes détaillées

### 1. Tester Docker avec hello-world

```bash
# Exécuter le conteneur hello-world
docker run hello-world

```

**Résultat attendu :**

```
Hello from Docker!
This message shows that your installation appears to be working correctly.

To generate this message, Docker took the following steps:
 1. The Docker client contacted the Docker daemon.
 2. The Docker daemon pulled the "hello-world" image from the Docker Hub.
 3. The Docker daemon created a new container from that image which runs the
    executable that produces the output you are currently reading.
 4. The Docker daemon streamed that output to the Docker client, which sent it
    to your terminal.
[...]

```

### 2. Explorer les commandes Docker de base

#### Gestion des images

```bash
# Lister les images Docker téléchargées
docker images

# Télécharger une image sans créer de conteneur
docker pull alpine

# Rechercher une image sur Docker Hub
docker search nginx

```

#### Gestion des conteneurs

```bash
# Lister les conteneurs en cours d'exécution
docker ps

# Lister tous les conteneurs (y compris ceux arrêtés)
docker ps -a

# Exécuter un conteneur en mode interactif et avec un terminal
docker run -it alpine sh

# Dans le shell Alpine, exécutez quelques commandes
echo "Hello from Alpine!"
exit

# Exécuter un conteneur en arrière-plan (détaché)
docker run -d --name web-server nginx

# Arrêter un conteneur en cours d'exécution
docker stop web-server

# Démarrer un conteneur arrêté
docker start web-server

# Redémarrer un conteneur
docker restart web-server

# Supprimer un conteneur (doit être arrêté ou utiliser -f pour forcer)
docker stop web-server
docker rm web-server

```

#### Logs et informations

```bash
# Exécuter un nouveau conteneur nginx
docker run -d --name web-server nginx

# Afficher les logs d'un conteneur
docker logs web-server

# Afficher les statistiques d'utilisation des ressources
docker stats web-server

# Afficher les informations détaillées d'un conteneur
docker inspect web-server

```

#### Exécuter des commandes dans un conteneur en cours d'exécution

```bash
# Exécuter une commande dans un conteneur sans y entrer
docker exec web-server ls -la

# Ouvrir un terminal interactif dans un conteneur en cours d'exécution
docker exec -it web-server bash

```

### 3. Nettoyage

```bash
# Arrêter tous les conteneurs en cours d'exécution
docker stop $(docker ps -q)

# Supprimer tous les conteneurs arrêtés
docker rm $(docker ps -a -q)

# Supprimer toutes les images non utilisées
docker image prune -a

```

## Résultats attendus

-   Le conteneur `hello-world` s'exécute correctement et affiche le message de bienvenue
    
-   Vous avez pu exécuter et expérimenter les commandes Docker de base
    
-   Vous comprenez la différence entre images et conteneurs
    

## Commandes Docker essentielles à retenir

Commande

Description

`docker run`

Crée et démarre un nouveau conteneur

`docker ps`

Liste les conteneurs en cours d'exécution

`docker ps -a`

Liste tous les conteneurs

`docker images`

Liste les images téléchargées

`docker pull`

Télécharge une image depuis un registre

`docker start/stop`

Démarre/arrête un conteneur existant

`docker exec`

Exécute une commande dans un conteneur

`docker logs`

Affiche les logs d'un conteneur

`docker rm`

Supprime un conteneur

`docker rmi`

Supprime une image