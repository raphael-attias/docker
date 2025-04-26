Job 03

Objectif

Recréer le conteneur hello-world à partir d'une image Debian minimale en utilisant un Dockerfile personnalisé.

Fichiers générés

Dockerfile : job-03.Dockerfile

Script : hello.sh

job-03.Dockerfile

# Utilise une image Debian légère
FROM debian:stable-slim

# Installe curl et nettoie le cache apt
RUN apt-get update && \
    apt-get install -y --no-install-recommends curl && \
    rm -rf /var/lib/apt/lists/*

# Copie et rend exécutable le script hello.sh
COPY hello.sh /usr/local/bin/hello.sh
RUN chmod +x /usr/local/bin/hello.sh

# Commande par défaut
CMD ["/usr/local/bin/hello.sh"]

hello.sh

#!/bin/bash

echo "Hello from custom hello-world container!"

Étapes de mise en œuvre

Se positionner dans le répertoire du job :

cd /chemin/vers/docker/project

Créer le script hello.sh :

cat << 'EOF' > hello.sh
#!/bin/bash
echo "Hello from custom hello-world container!"
EOF
chmod +x hello.sh

Vérifier que les deux fichiers sont présents :

ls -l job-03.Dockerfile hello.sh
# -rw-r--r-- 1 user user  ... job-03.Dockerfile
# -rwxr-xr-x 1 user user  ... hello.sh

Construire l’image Docker :

docker build -t custom-hello-world -f job-03.Dockerfile .

Exécuter le conteneur pour vérifier le message :

docker run --rm custom-hello-world
# Doit afficher : Hello from custom hello-world container!

Erreurs possibles & astuces

COPY hello.sh not found : assurez-vous que hello.sh existe dans le même dossier que job-03.Dockerfile.

Permission denied : vérifiez les droits d’exécution du script (chmod +x hello.sh).

Legacy builder deprecated : installez et activez Buildx si besoin (docker buildx create --use).