# Cours 1 : Outillage

## Java

Pour développer en Java, nous avons besoin d'installer un JDK (Java Development Kit). La dernière version LTS (Long Term Support) est la version 21.

### Installation d'OpenJDK

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

2. Installer le dépôt APT de AdoptOpenJDK:

```Bash
mkdir -p /etc/apt/keyrings
wget -O - https://packages.adoptium.net/artifactory/api/gpg/key/public | tee /etc/apt/keyrings/adoptium.asc
echo "deb [signed-by=/etc/apt/keyrings/adoptium.asc] https://packages.adoptium.net/artifactory/deb $(awk -F= '/^VERSION_CODENAME/{print$2}' /etc/os-release) main" | tee /etc/apt/sources.list.d/adoptium.list
```

3. Instaler OpenJDK 21 :

```Bash
apt update 
apt install temurin-21-jdk
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

## IntelliJ IDEA

IntelliJ IDEA est un environment de développement intégré (IDE) pour le développement avec les différents langages ciblant la JVM. Il est très puissant et est largement utilisé dans l'industrie.

### Installation d'IntelliJ

<tabs>
<tab title="Windows (winget)">

```Bash
winget install -e --id JetBrains.IntelliJIDEA.Community
```

</tab>
<tab title="Linux (Flatpak)">

```Bash
flatpak install flathub com.jetbrains.IntelliJ-IDEA-Community
```

</tab>
<tab title="MacOS (Homebrew)">

```Bash
brew install --cask intellij-idea-ce
```

</tab>
</tabs>

## Git

### Qu'est-ce que Git ?

Git est un **système de gestion de version** (version control system ou VCS en anglais). Il en existe d'autre (
Mercurial, SVN), mais git est de loin le plus utilisé de nos jours.

L'objectif du système de gestion de version est de versionner efficacement notre code, suivre précisément les
changements qu'on y apporte, et naviguer facilement à travers les différentes versions. Cela est très important, car cela permet de ne jamais perdre de changement, ou de pouvoir revenir en arrière en cas soucis par exemple.

Git facilite également la coopération à plusieurs sur un projet. Il permet de travailler en parallèle et de réconcilier
les versions qui ont divergé.

### Concept importants

#### Commit

Un commit est une sauvegarde de l'intégralité d'une version du projet à un instant T. Il représente une étape dans
l'historique

#### Branche

Permet de faire diverger en parallèle plusieurs versions du projet pour pouvoir les réconcilier facilement et les
réconcilier plus tard.

### Installer git

<tabs>
<tab title="Windows (winget)">

```bash
winget install -e --id Git.Git
```

</tab>
<tab title="Debian/Ubuntu (APT)">

```Bash
apt-get install git
```

</tab>
<tab title="MacOS (Homebrew)">

```Bash
brew install git
```

</tab>
</tabs>


Configuration du compte local :

```bash
git config --global user.name "Your Name"
git config --global user.email "youremail@yourdomain.com"
```

### Créer un dépot local

```bash
mkdir dossierPourMonDepot
cd dossierPourMonDepot
git init
```

### Workflow Git "de base"

#### Créer un commit

1. `git add .` : ajouter tous les changements au tracking git
2. `git commit -m "Message de commit"` : créer un commit avec les changements

#### Créer une branche

1. `git branch nomDeLaBranche` : créer la branche
2. `git checkout nomDeLaBranche` : se positionner sur la branche

### Fusion

Pour rapport les changements d'un branche sur une autre on fusionne :

Pour merge la branche b2 dans la branche b1

```bash
git checkout b1
git merge b2
```

Il peut y avoir des conflits à résoudres si les mêmes lignes ont étées changées dans les historiques divergeants.

### Serveurs

On utilise un dépot distant pour se synchroniser avec les gens avec qui on coopère. Il y a principalement :

- Github
- Gitlab

### Ajouter un dépot distant

```bash
git remote add nomLocalDuDepotDistant urlDuDepotDistant
```

### Intéractions avec un dépot distant

Pousser des changements :

```bash
git push nomDeLaBranche
```

Tirer des changements :

```bash
git pull nomDeLaBranche
```

Mettre à jours les infos sur le dépot distant :

```
git fetch
```

### Récapitulatif du workflow de base pour implémenter une fonctionnalité

1. Créer une nouvelle branche : `git branch maFeature`
2. Se place sur la nouvelle branche : `git checkout maFeature`
3. Faire des changements dans le code
4. Ajouter les changements à git : `git add .`
5. Créer un nouveau commit avec les changements : `git commit -a -m "message de commit"`
6. Pousser les changements : `git push origin maFeature`
7. Retourner sur master : `git checkout master`
8. Fusionner la branche de feature : `git merge maFeature`

### Outils recommandés

Outil du cours : Intégration Git de IntelliJ IDEA.

Autres outils intéressants : 

- GitKraken : https://www.gitkraken.com/
- SourceTree : <https://www.sourcetreeapp.com/>

## Gitlab

Gitlab est une des nombreuses options qui existent en tant que serveur git. Un serveur git est un serveur qui va
permettre à toutes les personnes travaillant sur un projet de synchroniser leur travail, car Gitlab héberge un dépôt distant. Gitlab fournit également des outils de coopération, notamment la revue de code. 

La revue de code permet de vérifier le code de ses collègues pour vérifier s'il ne contient pas de problème, mais aussi pour suggérer des améliorations de qualité.

Nous utiliserons l'instance Gitlab suivante : https://gitlab.com. Vous aurez donc besoin de créer un compte sur cette dernière.

## Gradle

### Installer gradle

<tabs>
<tab title="Windows">

1. Télécharger [la dernière distribution Gradle](https://gradle.org/releases)
2. Extraire l'archive à l'endroit où vous souhaitez l'installer (ex : C:/tools/gradle)
3. Configurer l'environment : ajoutez une variable d'environment système `GRADLE_HOME` à votre `PATH`, avec comme valeur le chemin du répertoire où vous avez extrait l'archive

</tab>
<tab title="MacOS (Homebrew)">

```Bash
brew install gradle
```

</tab>
<tab title="Linux">

1. Télécharger [la dernière distribution Gradle](https://gradle.org/releases)
2. Extraire l'archive à l'endroit où vous souhaitez l'installer (ex : /opt/gradle)
3. Configurer l'environment : ajoutez une variable `GRADLE_HOME` à votre `PATH`, avec comme valeur le chemin du répertoire où vous avez extrait l'archive

</tab>
</tabs>

Pour vérifier que Gradle fonctionne correctement : 

```Bash
gradle -v
```

Le résultat devrait être : 

```Bash
------------------------------------------------------------
Gradle 8.5
------------------------------------------------------------

Build time:   2023-03-03 16:41:37 UTC
Revision:     7d6581558e226a580d91d399f7dfb9e3095c2b1d

Kotlin:       1.8.10
Groovy:       3.0.13
Ant:          Apache Ant(TM) version 1.10.11 compiled on July 10 2021
JVM:          17.0.6 (Homebrew 17.0.6+0)
OS:           Mac OS X 13.2.1 aarch64
```

### Création d'un projet Java avec Gradle

Commencer par créer un dossier pour le projet, puis se positionner dans ce dossier : 

```Bash
mkdir mon-projet
cd mon-projet
```

Ensuite, initialiser le projet avec : 

```Bash
gradle init
```

Suivre le script d'installation avec les options suivantes : 

1. Type de projet : `application`
2. Langage : `Java`
3. Sous-projets : `no`
4. Langage de script de build : `Groovy`
5. Framework de tests : `JUnit Jupiter`
6. Nom du projet : au choix
7. Nom du paquet : `fr.<votre prenom suivi de votre non de famille, en miniscule, sans accent collé>`
8. Version de Java cible : 21
9. Nouvelles APIs : `no`

## Références du cours

- [Documentation Adoptium (OpenJDK)](https://adoptium.net/installation/)
- [Documentation Git](https://git-scm.com/doc)
- [Gradle Documentation](https://docs.gradle.org/current/samples/sample_building_java_applications.html)