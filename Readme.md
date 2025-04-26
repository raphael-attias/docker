
# Projet Docker DevOps

Ce dépôt regroupe une série d’exercices pratiques (Jobs 01 à 11) permettant d’acquérir et de maîtriser Docker et son écosystème dans un contexte DevOps.


## Table des matières

1. [Présentation du projet](#présentation-du-projet)

2. [Structure du dépôt](#structure-du-dépôt)

3. [Prérequis](#prérequis)

4. [Exécution des Jobs](#exécution-des-jobs)

5. [Aller plus loin](#aller-plus-loin)

6. [Ressources](#ressources)

8. [Contribuer](#contribuer)
    

----------

## Présentation du projet

Chaque **Job** contient :

-   un objectif pédagogique lié à Docker
    
-   les fichiers nécessaires (Dockerfile, `docker-compose.yml`, scripts…)
    
-   un document Markdown (`job-XX.md`) décrivant les étapes et bonnes pratiques
    

Les Jobs couvrent l’installation de Docker, la gestion des conteneurs, des volumes, de réseaux, la sécurisation, l’automatisation via Bash, et l’utilisation d’outils comme Portainer.

## Structure du dépôt

```text
.
├── README.md                            # Présentation générale du projet
├── Pour aller plus loin/                # Exercice XAMPP-like
│   └── Pour-aller-plus-loin.md
├── Job01/                               # Installation de Docker sur Debian
│   └── job1.md
├── Job02/                               # Test hello-world & commandes Docker de base
│   └── job2.md
├── Job03/                               # Création et tests de conteneurs personnalisés
│   ├── Job03.md
│   ├── Job03.Dockerfile
│   └── hello.sh
├── Job04/                               # Dockerfile et utilisation avancée
│   ├── Job04.md
│   └── Job04.Dockerfile
├── Job05/                               # Alias Bash pour Docker
│   └── Job05.md
├── Job06/                               # Gestion et partage de volumes Docker
│   └── Job06.md
├── Job07/                               # Nginx + FTP avec volume partagé
│   ├── Job07.md
│   └── docker-compose.yml
├── Job08/                               # Conteneur Nginx personnalisé via Dockerfile
│   ├── Job08.md
│   ├── Job08.Dockerfile
│   └── default.conf
├── job9/                                # Registry Docker local + interface web
│   ├── Job09.md
│   └── docker-compose.yml
├── Job10/                               # Scripts Bash installation & nettoyage Docker
│   ├── Job10.md
│   ├── docker-install.sh
│   └── docker-cleanup.sh
└── job11/                               # Portainer et alternatives
    ├── Job11.md
    └── docker-compose.yml

```

## Prérequis

-   Un hôte Linux ou VM Debian/Ubuntu avec accès root ou sudo
    
-   [Docker Engine](https://docs.docker.com/get-docker/) installé (voir Job 01)
    
-   [Docker Compose](https://docs.docker.com/compose/install/) installé
    
-   Connaissances de base en ligne de commande Bash
    

## Exécution des Jobs

1.  **Cloner** ce dépôt :
    

git clone [https://github.com/raphael-attias/docker.git](https://github.com/raphael-attias/docker.git) cd docker

```
2. **Accéder** au dossier du Job souhaité :
   ```bash
cd job-07
# ou
cd job-10

```

3.  **Suivre** les instructions du fichier Markdown correspondant :
    

less job-07.md

```
4. **Exécuter** les commandes (Docker, scripts, Compose) indiquées.
5. **Nettoyer** :
   ```bash
# Pour les stacks Compose
docker-compose down -v
# Pour les scripts
docker-cleanup.sh

```

## Aller plus loin

-   -   Créer une stack complète de type XAMPP avec Docker Compose (`Pour-aller-plus-loin.md`).
        
-   -   Sécuriser les conteneurs : user non-root, secrets, quotas de ressources.
        
-   -   Mettre en place un pipeline CI/CD avec Docker (GitHub Actions, GitLab CI…).
        

## Ressources

-   [Documentation officielle Docker](https://docs.docker.com/)
    
-   [Best practices Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
    
-   [Docker Compose](https://docs.docker.com/compose/)
    
-   [Portainer](https://www.portainer.io/)
    

## Contribuer

Les contributions sont les bienvenues ! Ouvrez une issue ou une pull request pour :

-   Ajouter de nouveaux Jobs ou exercices
    
-   Améliorer la documentation existante
    
-   Corriger des erreurs
