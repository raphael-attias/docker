
# Job10 - Scripts Bash pour Docker

## Objectif

1.  Créer un script Bash (`docker-cleanup.sh`) pour supprimer entièrement Docker (images, conteneurs, volumes, réseaux et paquets).
    
2.  Créer un script Bash (`docker-install.sh`) pour automatiser l'installation de Docker sur une machine Debian.
    

## Structure du projet

```
Job10/
├── docker-cleanup.sh     # Script de nettoyage Docker
├── docker-install.sh     # Script d'installation Docker
└── Job10.md

```

----------

## Script de nettoyage Docker (`docker-cleanup.sh`)

```bash
#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# Script de nettoyage complet de Docker
#-----------------------------------------------------------------------

print_message() {
  local type="$1" msg="$2"
  local GREEN='\033[0;32m' YELLOW='\033[1;33m' RED='\033[0;31m' NC='\033[0m'
  case "$type" in
    info)  echo -e "${GREEN}[INFO]${NC} $msg" ;;  
    warn)  echo -e "${YELLOW}[WARN]${NC} $msg" ;;  
    error) echo -e "${RED}[ERROR]${NC} $msg" ;;  
    *)     echo "$msg" ;;  
  esac
}

# Vérifier les privilèges root
if [[ $(id -u) -ne 0 ]]; then
  print_message error "Ce script doit être exécuté en tant que root."
  exit 1
fi

# Vérifier si Docker est installé
if ! command -v docker &> /dev/null; then
  print_message error "Docker n'est pas installé sur ce système."
  exit 1
fi

# Confirmation avant suppression
print_message warn "Ce script va supprimer : conteneurs, images, volumes, réseaux et paquets Docker."
read -rp "Confirmez-vous ? (y/N) : " ans
if [[ ! $ans =~ ^[Yy]$ ]]; then
  print_message info "Opération annulée."
  exit 0
fi

# 1. Arrêt et suppression des conteneurs
print_message info "Arrêt et suppression des conteneurs..."
docker stop $(docker ps -q) 2>/dev/null || true
docker rm -f $(docker ps -a -q) 2>/dev/null || true

# 2. Suppression des images
print_message info "Suppression des images..."
docker rmi -f $(docker images -q) 2>/dev/null || true

# 3. Suppression des volumes
print_message info "Suppression des volumes..."
docker volume rm $(docker volume ls -q) 2>/dev/null || true

# 4. Suppression des réseaux personnalisés
print_message info "Suppression des réseaux personnalisés..."
docker network prune -f 2>/dev/null || true

# 5. Nettoyage système Docker
print_message info "Nettoyage du système Docker..."
docker system prune -a -f --volumes 2>/dev/null || true

# 6. Désinstallation des paquets Docker
print_message info "Désinstallation des paquets Docker..."
if [[ -f /etc/debian_version ]]; then
  apt-get purge -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin docker.io runc
  apt-get autoremove -y && apt-get clean
  rm -rf /var/lib/docker /var/lib/containerd /etc/docker /etc/apparmor.d/docker
  rm -f /etc/apt/sources.list.d/docker*.list
else
  print_message warn "Distribution non reconnue : désinstallation manuelle possible requise."
fi

# 7. Nettoyage final systemd
print_message info "Nettoyage systemd..."
systemctl daemon-reload 2>/dev/null || true
systemctl reset-failed 2>/dev/null || true

print_message info "Nettoyage de Docker terminé !"

```

----------

## Script d'installation Docker (`docker-install.sh`)

```bash
#!/usr/bin/env bash
set -euo pipefail

# ----------------------------------------------------------------------
# Script d'installation automatique de Docker sur Debian
#-----------------------------------------------------------------------

print_message() {
  local type="$1" msg="$2"
  local GREEN='\033[0;32m' YELLOW='\033[1;33m' RED='\033[0;31m' NC='\033[0m'
  case "$type" in
    info)  echo -e "${GREEN}[INFO]${NC} $msg" ;;  
    warn)  echo -e "${YELLOW}[WARN]${NC} $msg" ;;  
    error) echo -e "${RED}[ERROR]${NC} $msg" ;;  
    *)     echo "$msg" ;;  
  esac
}

# Vérifier les privilèges root
if [[ $(id -u) -ne 0 ]]; then
  print_message error "Ce script doit être exécuté en tant que root."
  exit 1
fi

# Vérifier la distribution Debian
if [[ ! -f /etc/debian_version ]]; then
  print_message error "Ce script est réservé à Debian et dérivés."
  exit 1
fi

# Mise à jour et dépendances
print_message info "Mise à jour des paquets..."
apt-get update -y && apt-get upgrade -y
print_message info "Installation des prérequis..."
apt-get install -y apt-transport-https ca-certificates curl gnupg lsb-release

# Ajout de la clé GPG et du dépôt Docker
print_message info "Ajout de la clé GPG Docker..."
mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg | \
  gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg

print_message info "Ajout du dépôt Docker..."
echo \"deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable\" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

# Installation de Docker Engine et Compose
print_message info "Installation de Docker Engine et Compose..."
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin

# Activation et test
print_message info "Activation du service Docker..."
if command -v systemctl &> /dev/null; then
  systemctl enable --now docker
else
  print_message warn "systemd non disponible, démarrez Docker manuellement ou via Docker Desktop (WSL2)"
fi

print_message info "Test de Docker avec hello-world..."
if docker run --rm hello-world &> /dev/null; then
  print_message info "Installation réussie !"
else
  print_message error "Le test a échoué. Vérifiez 'docker info'."
  exit 1
fi

```

----------

## Utilisation

1.  Rendez les scripts exécutables :
    
    ```bash
    chmod +x docker-cleanup.sh docker-install.sh
    
    ```
    
2.  Pour installer Docker sur Debian :
    
    ```bash
    sudo ./docker-install.sh
    
    ```
    
3.  Pour nettoyer complètement Docker :
    
    ```bash
    sudo ./docker-cleanup.sh
    
    ```