#!/bin/bash

# ======================================================================
# Script d'installation automatique de Docker sur Debian
# ======================================================================

# Fonction pour afficher des messages colorés
print_message() {
    local GREEN='\033[0;32m'
    local RED='\033[0;31m'
    local YELLOW='\033[1;33m'
    local NC='\033[0m' # No Color
    
    case $1 in
        "info") echo -e "${GREEN}[INFO]${NC} $2" ;;
        "warn") echo -e "${YELLOW}[WARN]${NC} $2" ;;
        "error") echo -e "${RED}[ERROR]${NC} $2" ;;
        *) echo "$2" ;;
    esac
}

# Vérification privilèges root
if [ "$(id -u)" -ne 0 ]; then
    print_message "error" "Ce script doit être exécuté en tant que root ou avec sudo."
    exit 1
fi

# Vérification système Debian
if [ ! -f /etc/debian_version ]; then
    print_message "error" "Ce script est conçu uniquement pour Debian ou ses dérivés."
    exit 1
fi

# Détection de l'utilisateur
CURRENT_USER="${SUDO_USER:-$(whoami)}"
if [ "$CURRENT_USER" = "root" ]; then
    print_message "warn" "Exécuté en tant que root. Aucun utilisateur standard détecté."
    read -p "Souhaitez-vous spécifier un utilisateur à ajouter au groupe docker ? (y/n): " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        read -p "Entrez le nom d'utilisateur: " CURRENT_USER
    else
        CURRENT_USER=""
    fi
fi

echo "==================================================================="
print_message "info" "Installation de Docker sur Debian"
echo "==================================================================="

# 1. Mise à jour du système
print_message "info" "Mise à jour des paquets système..."
apt-get update -y && apt-get upgrade -y

# 2. Installation des dépendances
print_message "info" "Installation des dépendances..."
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# 3. Ajout de la clé GPG officielle Docker
print_message "info" "Ajout de la clé GPG Docker..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

# 4. Ajout du dépôt Docker
print_message "info" "Ajout du dépôt Docker..."
echo \
"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
$(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null

# 5. Mise à jour des sources
print_message "info" "Mise à jour des sources de paquets..."
apt-get update -y

# 6. Installation de Docker Engine et Docker Compose Plugin
print_message "info" "Installation de Docker Engine et Docker Compose..."
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# 7. Activation et démarrage du service Docker
print_message "info" "Activation et démarrage du service Docker..."
systemctl enable --now docker

# Vérification du service
if systemctl is-active --quiet docker; then
    print_message "info" "Docker est actif et fonctionne correctement."
else
    print_message "error" "Docker n'a pas pu être démarré. Vérifiez les journaux (journalctl -u docker)."
    exit 1
fi

# 8. Ajout de l'utilisateur au groupe Docker
if [ -n "$CURRENT_USER" ]; then
    print_message "info" "Ajout de l'utilisateur $CURRENT_USER au groupe docker..."
    usermod -aG docker "$CURRENT_USER"
    print_message "info" "Déconnectez-vous puis reconnectez-vous ou exécutez : newgrp docker"
fi

# 9. Test de l'installation
print_message "info" "Test de Docker avec l'image hello-world..."
if docker run --rm hello-world; then
    echo "==================================================================="
    print_message "info" "Docker a été installé et fonctionne parfaitement ! 🎉"
    if [ -n "$CURRENT_USER" ]; then
        echo "L'utilisateur $CURRENT_USER a été ajouté au groupe docker."
        echo "N'oubliez pas : déconnexion/reconnexion ou 'newgrp docker' !"
    fi
    echo "==================================================================="
else
    echo "==================================================================="
    print_message "error" "Le test de Docker a échoué. Installation incomplète."
    echo "Vérifiez manuellement avec 'docker info' ou 'docker run hello-world'."
    echo "==================================================================="
    exit 1
fi
