
# Job01 - Installation de Docker sur une VM Debian

## Objectif

Créer une machine virtuelle Debian en mode console et installer Docker (CLI uniquement).

## Prérequis

-   Logiciel de virtualisation (VirtualBox, VMware, etc.)
    
-   Image ISO de Debian (dernière version stable)
    

## Configuration de la VM

-   **Disque dur** : 8 Go
    
-   **RAM** : 1 Go
    
-   **vCPU** : 1
    
-   **Mode** : console (sans interface graphique)
    

## Étapes détaillées

### 1. Création de la VM

Dans votre logiciel de virtualisation, créez une nouvelle machine avec :

-   **Nom** : Debian-Docker
    
-   **Type** : Linux
    
-   **Version** : Debian (64-bit)
    
-   **Mémoire** : 1024 Mo (1 Go)
    
-   **Disque dur** : 8 Go (VDI, dynamiquement alloué)
    
-   **CPU** : 1
    

### 2. Installation de Debian

1.  Démarrez la VM et sélectionnez l'ISO Debian
    
2.  Choisissez l’installation en mode texte
    
3.  Suivez les étapes : langue, pays, clavier, configuration réseau
    
4.  Partitionnez : utilisez tout le disque
    
5.  Sélectionnez uniquement les utilitaires système (décochez l’environnement de bureau)
    
6.  Installez GRUB
    

### 3. Mise à jour du système

```bash
# Se connecter à la VM et passer en root
gsu -
# ou si sudo est installé
sudo -i

# Mise à jour des paquets
apt update
apt upgrade -y

```

### 4. Installation des prérequis pour Docker

```bash
apt install -y \
  apt-transport-https \
  ca-certificates \
  curl \
  gnupg \
  lsb-release

```

### 5. Ajout du dépôt Docker officiel

```bash
# Clé GPG Docker
docker-archive-keyring
curl -fsSL https://download.docker.com/linux/debian/gpg \
  | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Dépôt stable
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] \
  https://download.docker.com/linux/debian $(lsb_release -cs) stable" \
  | tee /etc/apt/sources.list.d/docker.list > /dev/null

```

### 6. Installation de Docker Engine

```bash
apt update
apt install -y docker-ce docker-ce-cli containerd.io

```

### 7. Vérification de l'installation

```bash
# Service Docker
tty
systemctl status docker

# Version de Docker
docker --version
# Ex. : Docker version 28.1.1, build 4eba377

```

### 8. Configuration non-root (optionnel)

```bash
# Créer le groupe docker
groupadd -f docker

# Ajouter l’utilisateur courant au groupe docker
usermod -aG docker $USER

# Appliquer les changements sans relogin
newgrp docker

# Tester
docker info

```

**Exemple de sortie :**

```
Client: Docker Engine - Community
 Version:    28.1.1
 ...
Server:
 Containers: 0
 Images: 0
 Server Version: 28.1.1
 ...

```
