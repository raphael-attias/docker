## Job 01 - Installation de Docker sur une VM Debian
Objectif
Créer une machine virtuelle Debian en mode console et installer Docker (CLI uniquement).
Prérequis

Logiciel de virtualisation (VirtualBox, VMware, etc.)
Image ISO de Debian (dernière version stable)

Configuration de la VM

8 Go de disque dur
1 Go de RAM
1 vCPU
Mode console (sans interface graphique)

Étapes détaillées
1. Création de la VM
Dans votre logiciel de virtualisation, créez une nouvelle machine virtuelle avec les spécifications suivantes :

Nom : Debian-Docker
Type : Linux
Version : Debian (64-bit)
Mémoire : 1024 Mo (1 Go)
Disque dur : 8 Go (VDI, dynamiquement alloué)
CPU : 1

2. Installation de Debian

Démarrez la VM et sélectionnez l'image ISO Debian
Choisissez l'installation en mode texte
Suivez les étapes d'installation standards :

Langue, pays, clavier
Configuration réseau
Partitionnement (utiliser tout le disque)
Sélection des logiciels : décochez l'environnement de bureau, gardez uniquement les utilitaires système standard
Installation du GRUB



3. Mise à jour du système
bash# Connexion à la VM (utilisez l'utilisateur créé lors de l'installation)
# Obtenir les privilèges root
su -
# ou si sudo est installé
sudo -i

# Mettre à jour les paquets
apt update
apt upgrade -y
4. Installation des prérequis pour Docker
bash# Installer les dépendances nécessaires
apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release
5. Ajout du dépôt Docker officiel
bash# Ajouter la clé GPG officielle de Docker
curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajouter le dépôt Docker stable
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian \
  $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null
6. Installation de Docker Engine
bash# Mettre à jour l'index des paquets
apt update

# Installer Docker Engine et CLI (pas d'interface graphique)
apt install -y docker-ce docker-ce-cli containerd.io
7. Vérification de l'installation
bash# Vérifier que le service Docker est actif
systemctl status docker

# Vérifier la version de Docker installée
docker --version
>> resultat : Docker version 28.1.1, build 4eba377

8. Configuration de Docker pour un utilisateur non-root (optionnel mais recommandé)
bash# Créer le groupe docker s'il n'existe pas déjà
groupadd -f docker

# Ajouter votre utilisateur au groupe docker
usermod -aG docker $USER

# Appliquer les changements de groupe
newgrp docker

# Vérifier que vous pouvez exécuter docker sans sudo
docker info
root@AigleRoyal:~# docker info
Client: Docker Engine - Community
 Version:    28.1.1
 Context:    default
 Debug Mode: false
 Plugins:
  compose: Docker Compose (Docker Inc.)
    Version:  v2.35.1
    Path:     /root/.docker/cli-plugins/docker-compose

Server:
 Containers: 0
  Running: 0
  Paused: 0
  Stopped: 0
 Images: 0
 Server Version: 28.1.1
 Storage Driver: overlay2
  Backing Filesystem: extfs
  Supports d_type: true
  Using metacopy: false
  Native Overlay Diff: true
  userxattr: false
 Logging Driver: json-file
 Cgroup Driver: cgroupfs
 Cgroup Version: 1
 Plugins:
  Volume: local
  Network: bridge host ipvlan macvlan null overlay
  Log: awslogs fluentd gcplogs gelf journald json-file local splunk syslog
 Swarm: inactive
 Runtimes: io.containerd.runc.v2 runc
 Default Runtime: runc
 Init Binary: docker-init
 containerd version: 05044ec0a9a75232cad458027ca83437aae3f4da
 runc version: v1.2.5-0-g59923ef
 init version: de40ad0
 Security Options:
  seccomp
   Profile: builtin
 Operating System: Debian GNU/Linux 12 (bookworm)
 OSType: linux
 Architecture: x86_64
 CPUs: 8
 Total Memory: 7.68GiB
 Name: AigleRoyal
 ID: 7b2b15eb-1e81-4c4f-843e-ccf640233e26
 Docker Root Dir: /var/lib/docker
 Debug Mode: false
 Experimental: false
 Insecure Registries:
  ::1/128
  127.0.0.0/8
 Live Restore Enabled: false

Erreurs courantes et solutions
Erreur : "Permission denied while trying to connect to the Docker daemon socket"
Solution : Assurez-vous d'avoir ajouté votre utilisateur au groupe docker et d'avoir appliqué ce changement avec la commande newgrp docker ou en vous déconnectant puis reconnectant.
Erreur : "Package 'docker-ce' has no installation candidate"
Solution : Vérifiez que vous avez correctement ajouté le dépôt Docker et que le nom de code de votre distribution Debian est supporté. Si besoin, remplacez le nom de code automatique par le plus récent supporté par Docker.
Erreur : "Failed to start Docker Application Container Engine"
Solution : Vérifiez les logs système avec journalctl -xeu docker.service pour identifier le problème spécifique.

Note importante : Cette installation est manuelle et n'utilise pas Snap, conformément aux exigences du projet.