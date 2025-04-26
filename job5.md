
# Job05

## Objectif

Tout informaticien étant « flemmard », il faut créer des alias pour les commandes Docker en CLI afin de manipuler plus facilement les images et les conteneurs. Ces alias seront ajoutés dans `~/.bashrc`.

## Prérequis

-   Docker installé et fonctionnel (voir Job 01)
    
-   Accès à un terminal Bash
    

## Étapes détaillées

### 1. Créer le fichier d'alias Docker

```bash
# Créer le dossier pour le job
mkdir -p ~/docker/Job05
cd ~/docker/Job05

# Créer et éditer le fichier d'alias
nano docker_aliases.sh

```

Contenu de `docker_aliases.sh` :

```bash
#!/bin/bash

# Alias Docker - Conteneurs
alias dps='docker ps'
alias dpsa='docker ps -a'
alias drm='docker rm'
alias drmi='docker rmi'
alias dstop='docker stop'
alias dstart='docker start'
alias drestart='docker restart'
alias dexec='docker exec -it'
alias dlogs='docker logs'
alias dinspect='docker inspect'
alias dtop='docker stats'

# Alias Docker - Images
alias dimages='docker images'
alias dpull='docker pull'
alias dbuild='docker build'

# Alias Docker - Nettoyage
alias dcleanc='docker container prune -f'
alias dcleani='docker image prune -f'
alias dcleanv='docker volume prune -f'
alias dclean='docker system prune -f'
alias dcleanall='docker system prune -a -f --volumes'

# Alias Docker - Utilitaires
alias dip='docker inspect -f "{{range .NetworkSettings.Networks}}{{.IPAddress}}{{end}}"'
alias dports='docker port'
alias denv='docker inspect -f "{{range .Config.Env}}{{.}}{{println}}{{end}}"'
alias dmount='docker inspect -f "{{range .Mounts}}{{.Source}} -> {{.Destination}}{{println}}{{end}}"'

# Alias Docker - Raccourcis
alias dsh='f() { docker exec -it "$1" /bin/bash || docker exec -it "$1" /bin/sh; }; f'

# Alias Docker Compose
alias dc='docker-compose'
alias dcup='docker-compose up -d'
alias dcdown='docker-compose down'
alias dcps='docker-compose ps'
alias dclogs='docker-compose logs'

# Fonction de nettoyage complet

dcleaneverything() {
  docker stop \
    $(docker ps -q) 2>/dev/null || true
  docker rm \
    $(docker ps -a -q) 2>/dev/null || true
  docker rmi \
    $(docker images -q) 2>/dev/null || true
  docker volume rm \
    $(docker volume ls -q) 2>/dev/null || true
  docker network prune -f 2>/dev/null || true
  docker system prune -a -f --volumes 2>/dev/null || true
  echo "Nettoyé !"
}

```

### 2. Inclure les alias dans `~/.bashrc`

```bash
echo "# Docker aliases" >> ~/.bashrc
echo "if [ -f ~/docker/Job05/docker_aliases.sh ]; then" >> ~/.bashrc
echo "  source ~/docker/Job05/docker_aliases.sh" >> ~/.bashrc
echo "fi" >> ~/.bashrc

```

### 3. Activer les alias

```bash
source ~/.bashrc

```

### 4. Tester

```bash
# Exemple d'utilisation
 dps      # conteneurs en cours
 dimages  # images téléchargées
 dlogs JOB05-container
 dsh JOB05-container
 dclean  # nettoyage rapide

```
