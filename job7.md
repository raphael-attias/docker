Job 07 - Docker Compose avec Nginx et FTP
Objectif
Créer deux conteneurs (Nginx et FTP) liés entre eux avec un volume commun, puis tester l'accès FTP en envoyant un fichier HTML qui sera servi par Nginx.
Préparation
Structure du projet
job-07/
├── docker-compose.yml
├── ftp/
│   └── users.conf       # Configuration des utilisateurs FTP
└── web/
    └── index.html       # Notre fichier HTML à servir
Fichier docker-compose.yml
yamlversion: '3'

services:
  nginx:
    image: nginx:latest
    ports:
      - "8080:80"
    volumes:
      - web_data:/usr/share/nginx/html
    networks:
      - app_network
    depends_on:
      - ftp

  ftp:
    image: stilliard/pure-ftpd:latest
    ports:
      - "21:21"
      - "30000-30009:30000-30009"  # Ports passifs pour FTP
    volumes:
      - web_data:/home/ftpuser
      - ./ftp/users.conf:/etc/pure-ftpd/passwd/pureftpd.passwd
    environment:
      PUBLICHOST: "localhost"
      FTP_USER_NAME: ftpuser
      FTP_USER_PASS: ftppassword
      FTP_USER_HOME: /home/ftpuser
    networks:
      - app_network

volumes:
  web_data:  # Volume partagé entre les deux conteneurs

networks:
  app_network:
Fichier index.html
html<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Job 07 - Docker</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            max-width: 800px;
            margin: 0 auto;
            padding: 20px;
            line-height: 1.6;
        }
        h1 {
            color: #2c3e50;
        }
    </style>
</head>
<body>
    <h1>Projet Docker - Job 07</h1>
    <p>Page créée par [VOTRE NOM/PRÉNOM]</p>
    <p>Cette page est servie par Nginx depuis un conteneur Docker après avoir été uploadée via FTP.</p>
</body>
</html>
Étapes d'exécution
1. Préparation des fichiers
Créez la structure de dossiers et les fichiers nécessaires :
bashmkdir -p job-07/ftp job-07/web
cd job-07
Créez le fichier docker-compose.yml avec le contenu indiqué ci-dessus.
Créez le fichier web/index.html avec votre nom et prénom.
2. Démarrage des conteneurs
Lancez les conteneurs avec Docker Compose :
bashcd job-07
docker-compose up -d
Vérifiez que les conteneurs sont en cours d'exécution :
bashdocker-compose ps
Résultat attendu :
     Name                    Command               State                     Ports                   
-------------------------------------------------------------------------------------------------
job-07_ftp_1     /run.sh                        Up      0.0.0.0:21->21/tcp, 0.0.0.0:30000-30009->30000-30009/tcp
job-07_nginx_1   /docker-entrypoint.sh ngin     Up      0.0.0.0:8080->80/tcp
3. Connexion FTP et envoi de fichier

Ouvrez FileZilla (ou tout autre client FTP)
Entrez les paramètres de connexion :

Hôte : localhost
Nom d'utilisateur : ftpuser
Mot de passe : ftppassword
Port : 21


Connectez-vous et accédez au dossier partagé
Envoyez le fichier index.html

4. Vérification
Ouvrez votre navigateur et accédez à http://localhost:8080 pour confirmer que votre page HTML est bien servie par Nginx.
Problèmes courants et solutions
Erreur de connexion FTP
Si vous ne pouvez pas vous connecter au serveur FTP :

Vérifiez que les ports sont correctement exposés :
bashdocker-compose ps

Le mode passif peut nécessiter une configuration supplémentaire selon votre réseau :
bash# Si nécessaire, ajoutez ces lignes à l'environnement du service FTP
environment:
  PASV_ADDRESS: localhost  # Changez pour votre IP publique si nécessaire
  PASV_MIN_PORT: 30000
  PASV_MAX_PORT: 30009


Page Nginx non accessible
Si la page web n'est pas accessible via Nginx :

Vérifiez que le volume est correctement monté :
bashdocker volume inspect job-07_web_data

Vérifiez que Nginx a les permissions nécessaires pour lire les fichiers :
bashdocker exec -it job-07_nginx_1 ls -la /usr/share/nginx/html


Nettoyage
Pour arrêter et supprimer les conteneurs, réseaux et volumes :
bashdocker-compose down -v