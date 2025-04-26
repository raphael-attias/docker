
# Job04.md

## Objectif

Créer une image Docker minimale basée sur Debian avec un serveur SSH configuré pour l'utilisateur **root** (mot de passe `root123`), en exposant le port SSH interne (22) sur un port externe non standard (2222).

## Fichiers générés

-   **Dockerfile** : `Job04.Dockerfile`
    

### Job04.Dockerfile

```
# Utilise l'image Debian slim
FROM debian:stable-slim

# Met à jour apt, installe openssh-server, crée le répertoire sshd, et définit le mot de passe root
RUN apt-get update && \
    apt-get install -y --no-install-recommends openssh-server && \
    rm -rf /var/lib/apt/lists/* && \
    mkdir -p /var/run/sshd && \
    echo 'root:root123' | chpasswd

# Assure que SSH écoute sur le port 22
RUN sed -i 's/#Port 22/Port 22/' /etc/ssh/sshd_config

# Expose le port SSH interne
EXPOSE 22

# Lance le démon SSH au démarrage du conteneur
CMD ["/usr/sbin/sshd", "-D"]
```

## Étapes

1.  Lancer les services en arrière-plan :
    
    ```
    docker-compose up -d
    ```
    
2.  Créer localement le fichier `index.html` :
    
    ```
    echo "<h1>Votre Prénom Nom</h1>" > index.html
    ```
    
3.  Transfert via FTP (FileZilla ou client en CLI) vers le conteneur FTP :
    
    ```
    ftp devops@localhost 21
    # Mot de passe: dp1234
    put index.html /home/devops/www/index.html
    ```
    
4.  Vérifier la présence du fichier sur le volume depuis l’hôte :
    
    ```
    docker-compose exec ftp ls -l /home/devops/www
    # Le fichier index.html doit apparaître avec l’utilisateur root
    ```
    
5.  Vérifier depuis le navigateur : Accéder à [http://localhost:8080](http://localhost:8080) pour voir votre page.