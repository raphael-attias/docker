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
    local type="$1"
    local message="$2"
    local GREEN='\033[0;32m'
    local RED='\033[0;31m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m' # No Color

    case "$type" in
        "info") echo -e "${GREEN}[INFO]${NC} $message" ;;
        "warn") echo -e "${YELLOW}[WARN]${NC} $message" ;;
        "error") echo -e "${RED}[ERROR]${NC} $message" ;;
        *) echo "$message" ;;
    esac
}

# Vérifier si le script est exécuté avec les privilèges root
if [ "$(id -u)" -ne 0 ]; then
    print_message "error" "Ce script doit être exécuté en tant que root ou avec sudo."
    exit 1
fi

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
    print_message "error" "Docker n'est pas installé sur ce système."
    exit 1
fi

# Demander confirmation
echo "==================================================================="
print_message "warn" "ATTENTION : Ce script va supprimer TOUS les éléments Docker :"
echo "- Tous les conteneurs (en cours d'exécution et arrêtés)"
echo "- Toutes les images"
echo "- Tous les volumes"
echo "- Tous les réseaux"
echo "- Et désinstaller Docker du système"
echo "==================================================================="
read -p "Êtes-vous sûr de vouloir continuer ? (y/n): " -n 1 -r
echo
if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
    print_message "info" "Opération annulée."
    exit 0
fi

# 1. Arrêt de tous les conteneurs en cours d'exécution
print_message "info" "Arrêt de tous les conteneurs en cours d'exécution..."
if docker ps -q | grep -q .; then
    docker stop $(docker ps -q) || print_message "warn" "Erreur lors de l'arrêt des conteneurs."
else
    print_message "info" "Aucun conteneur en cours d'exécution."
fi

# 2. Suppression de tous les conteneurs
print_message "info" "Suppression de tous les conteneurs..."
if docker ps -a -q | grep -q .; then
    docker rm -f $(docker ps -a -q) || print_message "warn" "Erreur lors de la suppression des conteneurs."
else
    print_message "info" "Aucun conteneur à supprimer."
fi

# 3. Suppression de toutes les images
print_message "info" "Suppression de toutes les images..."
if docker images -q | grep -q .; then
    docker rmi -f $(docker images -q) || print_message "warn" "Erreur lors de la suppression des images."
else
    print_message "info" "Aucune image à supprimer."
fi

# 4. Suppression de tous les volumes
print_message "info" "Suppression de tous les volumes..."
if docker volume ls -q | grep -q .; then
    docker volume rm $(docker volume ls -q) || print_message "warn" "Erreur lors de la suppression des volumes."
else
    print_message "info" "Aucun volume à supprimer."
fi

# 5. Suppression de tous les réseaux personnalisés
print_message "info" "Suppression de tous les réseaux personnalisés..."
docker network prune -f || print_message "warn" "Erreur lors de la suppression des réseaux."

# 6. Nettoyage du cache Docker
print_message "info" "Nettoyage du système Docker..."
docker system prune -a -f --volumes || print_message "warn" "Erreur lors du nettoyage du système."

# 7. Désinstallation des paquets Docker
print_message "info" "Désinstallation des paquets Docker..."

if [ -f /etc/debian_version ]; then
    apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker-compose docker.io containerd runc
    apt-get autoremove -y
    apt-get clean
    rm -rf /var/lib/docker /var/lib/containerd /etc/docker /etc/apparmor.d/docker
    rm -f /etc/apt/sources.list.d/docker*.list
elif [ -f /etc/redhat-release ]; then
    yum remove -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    rm -rf /var/lib/docker /var/lib/containerd /etc/docker
elif [ -f /etc/arch-release ]; then
    pacman -Rns --noconfirm docker docker-compose
    rm -rf /var/lib/docker /etc/docker
else
    print_message "warn" "Distribution non reconnue. La désinstallation des paquets pourrait être incomplète."
fi

# 8. Suppression du groupe Docker
print_message "info" "Suppression du groupe Docker si présent..."
if getent group docker &> /dev/null; then
    groupdel docker || print_message "warn" "Erreur lors de la suppression du groupe docker."
fi

# 9. Nettoyage systemd
print_message "info" "Nettoyage des services Docker dans systemd..."
systemctl daemon-reload
systemctl reset-failed

# Fin
echo "==================================================================="
print_message "info" "Nettoyage de Docker terminé avec succès !"
echo "Tous les conteneurs, images, volumes, réseaux et paquets Docker ont été supprimés."
echo "==================================================================="
