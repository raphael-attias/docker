# Projet Docker DevOps

Ce dépôt contient une série d'exercices pratiques pour apprendre Docker, mis en œuvre dans le cadre d'un projet pédagogique DevOps.

## Sommaire des Jobs

| Job | Description | Documentation |
|-----|-------------|---------------|
| 07 | Configuration de conteneurs Nginx et FTP liés avec volume partagé | [Job 07](./job-07.md) |
| 08 | Création d'un conteneur Nginx personnalisé via Dockerfile | [Job 08](./job-08.md) |
| 09 | Mise en place d'un registre Docker local avec interface web | [Job 09](./job-09.md) |
| 10 | Scripts Bash pour le nettoyage et l'installation de Docker | [Job 10](./job-10.md) |
| 11 | Utilisation de Portainer et exploration des alternatives | [Job 11](./job-11.md) |

## Structure du projet

```
.
├── README.md                      # Ce fichier
├── job-07.md                      # Documentation pour le Job 07
├── job-07/                        # Fichiers pour le Job 07
│   ├── docker-compose.yml         # Configuration Docker Compose
│   ├── ftp/                       # Dossier pour la configuration FTP
│   └── web/                       # Contenu web pour Nginx
│       └── index.html
├── job-08.md                      # Documentation pour le Job 08
├── job-08/                        # Fichiers pour le Job 08
│   ├── Dockerfile                 # Dockerfile pour Nginx personnalisé
│   ├── nginx.conf                 # Configuration Nginx
│   └── html/                      # Contenu web
│       └── index.html
├── job-09.md                      # Documentation pour le Job 09
├── job-09/                        # Fichiers pour le Job 09
│   └── docker-compose.yml         # Configuration pour le registre Docker
├── job-10.md                      # Documentation pour le Job 10
├── job-10/                        # Scripts pour le Job 10
│   ├── docker-cleanup.sh          # Script de nettoyage Docker
│   └── docker-install.sh          # Script d'installation Docker
├── job-11.md                      # Documentation pour le Job 11
└── job-11/                        # Fichiers pour le Job 11
    ├── docker-compose.yml         # Configuration pour Portainer
    └── alternatives.md            # Documentation sur les alternatives à Portainer
```

## Instructions générales

### Prérequis

- Machine virtuelle Debian en mode console
- Droits sudo pour l'installation de Docker
- Connexion Internet pour télécharger les images Docker

### Installation de Docker

Utilisez le script d'installation fourni dans le Job 10 :

```bash
cd job-10
chmod +x docker-install.sh
sudo ./docker-install.sh
```

### Test des Jobs

Chaque job possède sa propre documentation et ses propres fichiers. Pour exécuter un job spécifique :

1. Naviguez dans le répertoire du job :
   ```bash
   cd job-XX
   ```

2. Suivez les instructions dans le fichier `job-XX.md` correspondant.

3. Pour nettoyer après avoir terminé un job :
   ```bash
   # Pour les jobs utilisant docker-compose
   docker-compose down -v
   
   # Pour les autres jobs
   docker stop $(docker ps -a -q) && docker rm $(docker ps -a -q)
   ```

## Aller plus loin

Pour approfondir vos connaissances Docker, voici quelques pistes supplémentaires :

### Stack XAMPP avec Docker

Une extension intéressante serait de créer une stack complète similaire à XAMPP avec Docker :

- Un conteneur avec Nginx ou Apache (avec support PHP)
- Un conteneur MariaDB/MySQL 
- Un conteneur phpMyAdmin
- Un conteneur FTP
- Des volumes partagés pour le code et les données

Vous pourriez utiliser Docker Compose pour orchestrer cette stack :

```yaml
version: '3'

services:
  web:
    image: nginx:latest
    ports:
      - "80:80"
    volumes:
      - ./www:/var/www/html
      - ./nginx:/etc/nginx/conf.d
    depends_on:
      - php
      - mysql

  php:
    image: php:8.1-fpm
    volumes:
      - ./www:/var/www/html
    environment:
      - PHP_INI_DIR=/usr/local/etc/php
      
  mysql:
    image: mariadb:latest
    environment:
      MYSQL_ROOT_PASSWORD: root_password
      MYSQL_DATABASE: my_database
      MYSQL_USER: my_user
      MYSQL_PASSWORD: my_password
    volumes:
      - mysql_data:/var/lib/mysql

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - "8080:80"
    environment:
      PMA_HOST: mysql
    depends_on:
      - mysql

  ftp:
    image: stilliard/pure-ftpd:latest
    ports:
      - "21:21"
      - "30000-30009:30000-30009"
    volumes:
      - ./www:/home/ftpuser
    environment:
      PUBLICHOST: "localhost"
      FTP_USER_NAME: ftpuser
      FTP_USER_PASS: ftppassword
      FTP_USER_HOME: /home/ftpuser

volumes:
  mysql_data:
```

### Sécurisation des conteneurs

Pour améliorer la sécurité des déploiements Docker :

1. Utilisez des images minimales basées sur Alpine Linux
2. Exécutez les conteneurs en tant qu'utilisateur non-root
3. Mettez en place des quotas de ressources (CPU, mémoire)
4. Utilisez des secrets Docker pour les informations sensibles
5. Scannez régulièrement vos images pour les vulnérabilités

### Mise en place de CI/CD avec Docker

Créez un pipeline d'intégration continue qui utilise Docker pour :

1. Construire automatiquement vos images
2. Exécuter des tests unitaires et d'intégration
3. Pousser les images validées vers un registre Docker
4. Déployer automatiquement les nouvelles versions

## Ressources utiles

- [Documentation officielle Docker](https://docs.docker.com/)
- [Best practices pour l'écriture de Dockerfiles](https://docs.docker.com/develop/develop-images/dockerfile_best-practices/)
- [Docker Compose documentation](https://docs.docker.com/compose/)
- [Docker Hub](https://hub.docker.com/) - Registre public d'images Docker
- [Portainer Documentation](https://docs.portainer.io/)