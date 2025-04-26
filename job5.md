Job 05 - Création d'alias pour les commandes Docker
Objectif
Créer des alias pour les commandes Docker à ajouter dans ~/.bashrc afin de manipuler les images et conteneurs plus facilement.

Prérequis
Docker installé et fonctionnel (voir Job 01)
Accès à un terminal bash
Étapes détaillées
1. Création d'un fichier d'alias Docker
Pour une meilleure organisation, nous allons créer un fichier séparé pour les alias Docker, puis l'inclure dans ~/.bashrc.

bash
# Créer un répertoire pour les scripts Docker
mkdir -p ~/docker-jobs/job05
cd ~/docker-jobs/job05

# Créer le fichier d'alias Docker
nano docker_aliases.sh
Contenu du fichier docker_aliases.sh :

bash
#!/bin/bash

# Alias Docker - Gestion des conteneurs
alias dps='docker ps'                                           # Liste les conteneurs en cours d'exécution
alias dpsa='docker ps -a'                                       # Liste tous les conteneurs
alias drm='docker rm'                                           # Supprime un ou plusieurs conteneurs
alias drmi='docker rmi'                                         # Supprime une ou plusieurs images
alias dstop='docker stop'                                       # Arrête un ou plusieurs conteneurs
alias dstart='docker start'                                     # Démarre un ou plusieurs conteneurs
alias drestart='docker restart'                                 # Redémarre un ou plusieurs conteneurs
alias dexec='docker exec -it'                                   # Exécute une commande dans un conteneur en cours d'exécution
alias dlogs='docker logs'                                       # Affiche les logs d'un conteneur
alias dinspect='docker inspect'                                 # Affiche des informations détaillées sur un conteneur ou une image
alias dtop='docker stats'                                       # Affiche les statistiques d'utilisation des ressources

# Alias Docker - Gestion des images
alias dimages='docker images'                                   # Liste les images Docker
alias dpull='docker pull'                                       # Télécharge une image Docker
alias dbuild='docker build'                                     # Construit une image Docker à partir d'un Dockerfile

# Alias Docker - Nettoyage
alias dcleanc='docker container prune -f'                       # Supprime tous les conteneurs arrêtés
alias dcleani='docker image prune -f'                           # Supprime toutes les images non utilisées
alias dcleanv='docker volume prune -f'                          # Supprime tous les volumes non utilisés
alias dclean='docker system prune -f'                           # Supprime les conteneurs arrêtés, les réseaux non utilisés, les images et volumes en cache
alias dcleanall='docker system prune -a -f --volumes'           # Nettoyage complet (images, conteneurs, volumes)

# Alias Docker - Utilitaires
alias dip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'  # Affiche l'adresse IP d'un conteneur
alias dports='docker port'                                      # Affiche les mappages de port d'un conteneur
alias denv='docker inspect -f "{{range .Config.Env}}{{.}}{{println}}{{end}}"'            # Affiche les variables d'environnement d'un conteneur
alias dmount='docker inspect -f "{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}"'  # Affiche les montages de volumes

# Alias Docker - Raccourcis
alias dsh='docker exec -it $1 /bin/bash || docker exec -it $1 /bin/sh'  # Ouvre un shell dans un conteneur

# Alias Docker Compose
alias dc='docker-compose'                                       # Raccourci pour docker-compose
alias dcup='docker-compose up -d'                               # Démarre les services définis dans docker-compose.yml en mode détaché
alias dcdown='docker-compose down'                              # Arrête et supprime les conteneurs, réseaux définis dans docker-compose.yml
alias dcps='docker-compose ps'                                  # Liste les conteneurs docker-compose
alias dclogs='docker-compose logs'                              # Affiche les logs des services docker-compose

# Fonction pour nettoyer tout Docker (conteneurs, images, volumes, réseaux)
dcleaneverything() {
    echo "Arrêt de tous les conteneurs..."
    docker stop $(docker ps -q) 2>/dev/null || true
    echo "Suppression de tous les conteneurs..."
    docker rm $(docker ps -a -q) 2>/dev/null || true
    echo "Suppression de toutes les images..."
    docker rmi $(docker images -q) 2>/dev/null || true
    echo "Suppression de tous les volumes..."
    docker volume rm $(docker volume ls -q) 2>/dev/null || true
    echo "Suppression de tous les réseaux non utilisés..."
    docker network prune -f 2>/dev/null || true
    echo "Nettoyage système..."
    docker system prune -a -f --volumes 2>/dev/null || true
    echo "Tout a été nettoyé !"
}
2. Inclusion du fichier d'alias dans ~/.bashrc
bash
# Ajouter le fichier d'alias à ~/.bashrc
echo "# Docker aliases" >> ~/.bashrc
echo "if [ -f ~/docker-jobs/job05/docker_aliases.sh ]; then" >> ~/.bashrc
echo "    . ~/docker-jobs/job05/docker_aliases.sh" >> ~/.bashrc
echo "fi" >> ~/.bashrc
3. Activation des alias
bash
# Charger les nouveaux alias dans la session courante
source ~/.bashrc
4. Test des alias
Testez quelques-uns des alias que vous venez de créer :

bash
# Lister les conteneurs Docker en cours d'exécution
dps

# Lister toutes les images Docker
dimages

# Exécuter un conteneur de test
docker run -d --name test-container nginx

# Utiliser un alias pour voir les logs du conteneur
dlogs test-container

# Utiliser un alias pour entrer dans le conteneur
dsh test-container

# Nettoyer après le test
dstop test-container
drm test-container
Script d'installation des alias
Vous pouvez créer un script pour installer automatiquement les alias Docker :

bash
# Créer le script d'installation
nano install_docker_aliases.sh
Contenu du script install_docker_aliases.sh :

bash
#!/bin/bash

# Créer le répertoire si nécessaire
mkdir -p ~/docker-jobs/job05

# Créer le fichier d'alias
cat > ~/docker-jobs/job05/docker_aliases.sh << 'EOL'
#!/bin/bash

# Alias Docker - Gestion des conteneurs
alias dps='docker ps'                                           # Liste les conteneurs en cours d'exécution
alias dpsa='docker ps -a'                                       # Liste tous les conteneurs
alias drm='docker rm'                                           # Supprime un ou plusieurs conteneurs
alias drmi='docker rmi'                                         # Supprime une ou plusieurs images
alias dstop='docker stop'                                       # Arrête un ou plusieurs conteneurs
alias dstart='docker start'                                     # Démarre un ou plusieurs conteneurs
alias drestart='docker restart'                                 # Redémarre un ou plusieurs conteneurs
alias dexec='docker exec -it'                                   # Exécute une commande dans un conteneur en cours d'exécution
alias dlogs='docker logs'                                       # Affiche les logs d'un conteneur
alias dinspect='docker inspect'                                 # Affiche des informations détaillées sur un conteneur ou une image
alias dtop='docker stats'                                       # Affiche les statistiques d'utilisation des ressources

# Alias Docker - Gestion des images
alias dimages='docker images'                                   # Liste les images Docker
alias dpull='docker pull'                                       # Télécharge une image Docker
alias dbuild='docker build'                                     # Construit une image Docker à partir d'un Dockerfile

# Alias Docker - Nettoyage
alias dcleanc='docker container prune -f'                       # Supprime tous les conteneurs arrêtés
alias dcleani='docker image prune -f
