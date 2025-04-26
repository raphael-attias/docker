job-04.md

Objectif

Créer une image Docker minimale basée sur Debian avec un serveur SSH configuré pour l'utilisateur root (mot de passe root123), en exposant le port SSH interne (22) sur un port externe non standard (2222).

Fichiers générés

Dockerfile : job-04.Dockerfile

job-04.Dockerfile

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

Étapes de mise en œuvre

Se positionner dans le répertoire du job :

cd /chemin/vers/docker/project

Vérifier la présence du Dockerfile :

ls -l job-04.Dockerfile

Construire l’image Docker :

docker build -t ssh-debian -f job-04.Dockerfile .

Lancer le conteneur en mappant le port :

docker run -d --name ssh-test -p 2222:22 ssh-debian

Vérification

Depuis la machine hôte ou un autre terminal, tester la connexion SSH :

ssh root@localhost -p 2222
# Entrez le mot de passe : root123
echo $USER
# Doit retourner "root"

Erreurs possibles & astuces

Permission denied : assurez-vous que le démon SSH est bien lancé (docker logs ssh-test pour vérifier).

Port déjà utilisé : choisissez un autre port externe si 2222 est occupé.

Fichier non trouvé : vérifiez le nom exact du Dockerfile (job-04.Dockerfile).

Hypothèses

Le démon Docker est actif et accessible.

Aucune règle de pare-feu ne bloque le port 2222 sur la machine hôte.

L’utilisateur a les droits nécessaires pour construire et lancer des conteneurs Docker.