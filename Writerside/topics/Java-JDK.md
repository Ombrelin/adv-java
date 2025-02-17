# Java (JDK)

Pour développer en Java, nous avons besoin d'installer un JDK (Java Development Kit). La dernière version LTS (Long Term Support) est la version 21.

## Installation d'OpenJDK 21

<tabs>
<tab title="Windows">

1. Télécharger [le setup](https://adoptium.net/temurin/releases/?os=windows&arch=x64).
2. Exécuter le fichier MSI et suivre les instructions
</tab>
<tab title="MacOS">

1. Télécharger [l'installeur PKG](https://adoptium.net/temurin/releases/?os=mac&arch=x64)
2. Exécuter l'installeur PKG :
```Bash
installer -pkg <path_to_pkg>/<pkg_name>.pkg -target /
```

</tab>
<tab title="Linux (Debian/Ubuntu)">



1. Installer les packages nécessaires :

```Bash
apt install -y wget apt-transport-https
```

2. Installer le dépôt APT de AdoptOpenJDK :

```Bash
mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
```

3. Installer OpenJDK 21 :

```Bash
apt update 
apt install temurin-21-jdk
```

</tab>
<tab title="Linux (Fedora/CentOS/RHEL">
```bash
yum install temurin-21-jdk
```
</tab>
</tabs>

Pour vérifier la bonne installation du JDK :

```Bash
java --version
```

Le résultat devrait ressembler à :

```
openjdk 21.0.1 2023-10-17 LTS
OpenJDK Runtime Environment Temurin-21.0.1+12 (build 21.0.1+12-LTS)
OpenJDK 64-Bit Server VM Temurin-21.0.1+12 (build 21.0.1+12-LTS, mixed mode, sharing)
```

## Références du cours

- [Documentation Adoptium (OpenJDK)](https://adoptium.net/installation/)