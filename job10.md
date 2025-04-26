# Job 10 - Scripts Bash pour Docker

## Objectif
Créer deux scripts Bash :
1. Un script pour effacer totalement Docker (images, volumes, conteneurs, paquets)
2. Un script pour automatiser l'installation de Docker sur Debian

## Préparation

### Structure du projet
```
job-10/
├── docker-cleanup.sh     # Script de nettoyage Docker
└── docker-install.sh     # Script d'installation Docker
```

### Script de nettoyage Docker (docker-cleanup.sh)

```bash
#!/bin/bash

# ======================================================================
# Script de nettoyage complet de Docker
# 
# Ce script supprime tous les éléments Docker :
# - Conteneurs (en cours d'exécution et arrêtés)
# - Images
# - Volumes
# - Réseaux
# - Et désinstalle les paquets Docker
# ======================================================================

# Fonction pour afficher des messages avec couleurs
print_message() {
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    
    case $1 in
        "info")
            echo -e "${GREEN}[INFO]${NC} $2"
            ;;
        "warn")
            echo -e "${YELLOW}[WARN]${NC} $2"
            ;;
        "error")
            echo -e "${RED}[ERROR]${NC} $2"
            ;;
        *)
            echo "$2"
            ;;
    esac
}

# Vérifier si le script est exécuté avec les privilèges root
if [ "$(id -u)" -ne 0 ]; then
    print_message "error" "Ce script doit être exécuté en tant que root ou avec sudo."
    exit 1
fi

# Demander confirmation
echo "==================================================================="
print_message "warn" "ATTENTION: Ce script va supprimer TOUS les éléments Docker:"
echo "- Tous les conteneurs (en cours d'exécution et arrêtés)"
echo "- Toutes les images"
echo "- Tous les volumes"
echo "- Tous les réseaux"
echo "- Les paquets Docker installés sur le système"
echo "==================================================================="
read -p "Êtes-vous sûr de vouloir continuer? (y/n): " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_message "info" "Opération annulée."
    exit 0
fi

# 1. Arrêt de tous les conteneurs en cours d'exécution
print_message "info" "Arrêt de tous les conteneurs en cours d'exécution..."
docker_running=$(docker ps -q)
if [ -n "$docker_running" ]; then
    docker stop $(docker ps -q) || print_message "warn" "Aucun conteneur en cours d'exécution."
else
    print_message "info" "Aucun conteneur en cours d'exécution."
fi

# 2. Suppression de tous les conteneurs
print_message "info" "Suppression de tous les conteneurs..."
docker_containers=$(docker ps -a -q)
if [ -n "$docker_containers" ]; then
    docker rm -f $(docker ps -a -q) || print_message "warn" "Problème lors de la suppression des conteneurs."
else
    print_message "info" "Aucun conteneur à supprimer."
fi

# 3. Suppression de toutes les images
print_message "info" "Suppression de toutes les images..."
docker_images=$(docker images -q)
if [ -n "$docker_images" ]; then
    docker rmi -f $(docker images -q) || print_message "warn" "Problème lors de la suppression des images."
else
    print_message "info" "Aucune image à supprimer."
fi

# 4. Suppression de tous les volumes
print_message "info" "Suppression de tous les volumes..."
docker_volumes=$(docker volume ls -q)
if [ -n "$docker_volumes" ]; then
    docker volume rm $(docker volume ls -q) || print_message "warn" "Problème lors de la suppression des volumes."
else
    print_message "info" "Aucun volume à supprimer."
fi

# 5. Suppression de tous les réseaux (sauf les réseaux par défaut)
print_message "info" "Suppression de tous les réseaux personnalisés..."
# Supprime tous les réseaux sauf bridge, host et none
docker network prune -f || print_message "warn" "Problème lors de la suppression des réseaux."

# 6. Suppression du système de cache et des données Docker inutilisées
print_message "info" "Nettoyage du système Docker..."
docker system prune -a -f --volumes || print_message "warn" "Problème lors du nettoyage du système Docker."

# 7. Désinstallation des paquets Docker
print_message "info" "Désinstallation des paquets Docker..."

# Détection de la distribution
if [ -f /etc/debian_version ]; then
    # Debian / Ubuntu
    apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose docker.io containerd runc
    apt-get autoremove -y
    apt-get clean
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker
    rm -rf /etc/apparmor.d/docker
    rm -f /etc/apt/sources.list.d/docker*.list
elif [ -f /etc/redhat-release ]; then
    # CentOS / RHEL
    yum remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    rm -rf /var/lib/docker
    rm -rf /var/lib/containerd
    rm -rf /etc/docker
elif [ -f /etc/arch-release ]; then
    # Arch Linux
    pacman -Rns --noconfirm docker docker-compose
    rm -rf /var/lib/docker
    rm -rf /etc/docker
else
    print_message "warn" "Distribution non reconnue. La désinstallation des paquets pourrait être incomplète."
fi

print_message "info" "Suppression des groupes Docker..."
getent group docker > /dev/null 2>&1 && groupdel docker

print_message "info" "Nettoyage des scripts d'initialisation Docker..."
systemctl daemon-reload
systemctl reset-failed

echo "==================================================================="
print_message "info" "Nettoyage de Docker terminé avec succès!"
echo "Tous les conteneurs, images, volumes et réseaux ont été supprimés."
echo "Les paquets Docker ont été désinstallés du système."
echo "==================================================================="
```

### Script d'installation Docker (docker-install.sh)

```bash
#!/bin/bash

# ======================================================================
# Script d'installation automatique de Docker sur Debian
# 
# Ce script installe :
# - Docker Engine
# - Docker Compose
# - Configure les permissions pour l'utilisateur actuel
# ======================================================================

# Fonction pour afficher des messages avec couleurs
print_message() {
    GREEN='\033[0;32m'
    RED='\033[0;31m'
    YELLOW='\033[1;33m'
    NC='\033[0m' # No Color
    
    case $1 in
        "info")
            echo -e "${GREEN}[INFO]${NC} $2"
            ;;
        "warn")
            echo -e "${YELLOW}[WARN]${NC} $2"
            ;;
        "error")
            echo -e "${RED}[ERROR]${NC} $2"
            ;;
        *)
            echo "$2"
            ;;
    esac
}

# Vérifier si le script est exécuté avec les privilèges root
if [ "$(id -u)" -ne 0 ]; then
    print_message "error" "Ce script doit être exécuté en tant que root ou avec sudo."
    exit 1
fi

# Vérifier que nous sommes sur Debian ou une distribution basée sur Debian
if [ ! -f /etc/debian_version ]; then
    print_message "error" "Ce script est conçu uniquement pour Debian ou les distributions basées sur Debian."
    exit 1
fi

# Détecter l'utilisateur qui a lancé sudo (pour l'ajouter au groupe docker plus tard)
if [ -n "$SUDO_USER" ]; then
    CURRENT_USER=$SUDO_USER
else
    CURRENT_USER=$(whoami)
    if [ "$CURRENT_USER" = "root" ]; then
        print_message "warn" "Vous êtes connecté en tant que root. Aucun utilisateur ne sera ajouté au groupe docker."
        read -p "Souhaitez-vous spécifier un utilisateur à ajouter au groupe docker? (y/n): " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            read -p "Entrez le nom d'utilisateur: " CURRENT_USER
        else
            CURRENT_USER=""
        fi
    fi
fi

echo "==================================================================="
print_message "info" "Installation de Docker sur Debian"
echo "==================================================================="

# 1. Mise à jour du système
print_message "info" "Mise à jour des paquets système..."
apt-get update
apt-get upgrade -y

# 2. Installation des prérequis
print_message "info" "Installation des prérequis..."
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# 3. Ajout de la clé GPG officielle de Docker
print_message "info" "Ajout de la clé GPG Docker..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg

# 4. Configuration du dépôt Docker
print_message "info" "Configuration du dépôt Docker..."
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Mise à jour de la liste des paquets
print_message "info" "Mise à jour des sources de paquets..."
apt-get update

# En cas d'erreur avec la clé GPG, correction automatique
if [ $? -ne 0 ]; then
    print_message "warn" "Problème avec les permissions de la clé GPG. Correction en cours..."
    chmod a+r /etc/apt/keyrings/docker.gpg
    apt-get update
fi

# 6. Installation de Docker Engine
print_message "info" "Installation de Docker Engine..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 7. Vérification de l'installation
print_message "info" "Vérification de l'installation de Docker..."
if systemctl is-active --quiet docker; then
    print_message "info" "Docker Engine a été installé avec succès et est en cours d'exécution!"
else
    print_message "error" "Docker Engine n'est pas en cours d'exécution. Tentative de démarrage..."
    systemctl start docker
    if systemctl is-active --quiet docker; then
        print_message "info" "Docker Engine a été démarré avec succès!"
    else
        print_message "error" "Impossible de démarrer Docker Engine. Veuillez vérifier les journaux système."
        exit 1
    fi
fi

# 8. Installation de Docker Compose
print_message "info" "Installation de Docker Compose..."
apt-get install -y docker-compose-plugin

# 9. Ajout de l'utilisateur au groupe Docker pour éviter d'utiliser sudo
if [ -n "$CURRENT_USER" ]; then
    print_message "info" "Ajout de l'utilisateur $CURRENT_USER au groupe docker..."
    usermod -aG docker $CURRENT_USER
    print_message "info" "Pour appliquer les changements de groupe, déconnectez-vous et reconnectez-vous, ou exécutez: newgrp docker"
fi

# 10. Configuration pour démarrer Docker au démarrage
print_message "info" "Configuration de Docker pour démarrer automatiquement..."
systemctl enable docker

# 11. Test d'installation avec l'image hello-world
print_message "info" "Test de l'installation avec l'image hello-world..."
docker run --rm hello-world

# Vérification finale
if [ $? -eq 0 ]; then
    echo "==================================================================="
    print_message "info" "Installation de Docker terminée avec succès!"
    echo "Docker Engine est installé et fonctionne correctement."
    echo "Docker Compose est installé."
    if [ -n "$CURRENT_USER" ]; then
        echo "L'utilisateur $CURRENT_USER a été ajouté au groupe docker."
        echo "Pour appliquer les changements de groupe, déconnectez-vous et reconnectez-vous,"
        echo "ou exécutez: newgrp docker"
    fi
    echo "==================================================================="
else
    echo "==================================================================="
    print_message "error" "Le test d'installation a échoué."
    echo "Docker est installé mais semble rencontrer des problèmes."
    echo "Vérifiez les journaux système ou exécutez 'docker info' pour plus d'informations."
    echo "==================================================================="
    exit 1
fi
```

## Étapes d'exécution

### 1. Préparation des fichiers

Créez la structure de dossiers et les fichiers de script :

```bash
mkdir -p job-10
cd job-10
```

Créez les fichiers `docker-cleanup.sh` et `docker-install.sh` avec le contenu indiqué ci-dessus.

### 2. Attribution des permissions d'exécution

Rendez les scripts exécutables :

```bash
chmod +x docker-cleanup.sh docker-install.sh
```

### 3. Utilisation du script d'installation

Pour installer Docker sur votre système Debian :

```bash
sudo ./docker-install.sh
```

Le script va :
1. Mettre à jour le système
2. Installer les prérequis
3. Configurer les dépôts Docker
4. Installer Docker Engine et Docker Compose
5. Ajouter votre utilisateur au groupe docker
6. Configurer Docker pour démarrer au démarrage du système
7. Tester l'installation avec l'image hello-world

### 4. Utilisation du script de nettoyage

⚠️ **ATTENTION** : Ce script supprime toutes les données Docker. Utilisez-le avec précaution.

Pour nettoyer complètement Docker de votre système :

```bash
sudo ./docker-cleanup.sh
```

Le script va :
1. Arrêter tous les conteneurs en cours d'exécution
2. Supprimer tous les conteneurs
3. Supprimer toutes les images
4. Supprimer tous les volumes
5. Supprimer tous les réseaux personnalisés
6. Nettoyer le système Docker
7. Désinstaller les paquets Docker

## Remarques importantes

### Concernant le script d'installation

- Le script est conçu pour Debian et ses dérivés (comme Ubuntu).
- Il installe la dernière version stable de Docker.
- Il ajoute automatiquement l'utilisateur courant au groupe docker.
- Un redémarrage de session est nécessaire pour que les changements de groupe prennent effet.

### Concernant le script de nettoyage

- Ce script supprime **toutes** les données Docker (conteneurs, images, volumes).
- Il désinstalle complètement les paquets Docker du système.
- Une confirmation est demandée avant de procéder à la suppression.
- Utilisez-le uniquement lorsque vous souhaitez une réinitialisation complète.

## Problèmes courants et solutions

### Erreur d'ajout de clé GPG (script d'installation)

Si vous rencontrez une erreur lors de l'ajout de la clé GPG, le script essaie de corriger automatiquement les permissions. Si cela ne fonctionne pas :

```bash
# Correction manuelle
sudo chmod a+r /etc/apt/keyrings/docker.gpg
sudo apt-get update
```

### Erreur de permissions avec Docker (script d'installation)

Si vous rencontrez des erreurs de permissions après installation :

```bash
# Vérifiez que votre utilisateur est bien dans le groupe docker
groups

# Si non, ajoutez-le manuellement
sudo usermod -aG docker $USER

# Appliquez les changements sans déconnexion
newgrp docker
```

### Erreurs lors du nettoyage (script de nettoyage)

Si certains conteneurs ou volumes ne peuvent pas être supprimés :

```bash
# Forcer l'arrêt de tous les conteneurs
sudo docker kill $(docker ps -q)

# Forcer la suppression des volumes en les déconnectant d'abord
sudo docker volume rm $(docker volume ls -q) --force
```