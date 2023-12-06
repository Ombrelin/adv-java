# Cours 1 : Outillage

## Git

### Qu'est ce que Git ?

Git est un **système de gestion de version** (version control system ou VCS en anlgais). Il en existe d'autre (
Mercurial, SVN), mais git est de loin le plus utilisé de nos jours.

L'objectif du système de gestion de version est de versionner efficacement notre coder, suivre précisement les
changements qu'on y apporte, et naviguer facilement à travers les différentes versions. Cela est très important car cela
permet de ne jamais perdre de changement, ou de pouvoir revenir en arrière en cas soucis par exemple.

Git facilite également la coopération à plusieurs sur un projet. Il permet de travailler en parallèle et de réconcilier
les versions qui ont divergé.

### Concept importants

#### Commit

Un commit est une sauvegarde de l'initégralité d'une version du projet à un instant T. Il représente une étape dans
l'historique

#### Branche

Permet de faire diverger en parrallèle plusieurs versions du projet pour pouvoir les réconclier facilement et les
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

1. Créer une nouvelle branche : git branch maFeature
2. Se place sur la nouvelle branche : git checkout maFeature
3. Faire des changements dans le code
4. Ajouter les changements à git : git add .
5. Créer un nouveau commit avec les changements : git commit -a -m "message de commit"
6. Pousser les changements : git push origin maFeature
7. Retourner sur master : git checkout master
8. Fusionner la branche de feature : git merge maFeature

### Outils recommandés

Outil du cours : Intégration Git de IntelliJ IDEA.

Autre outils intéressants : 

- GitKraken : https://www.gitkraken.com/
- SourceTree : <https://www.sourcetreeapp.com/>

## Gitlab

Gitlab est une des nombreuses options qui existent en tant que serveur git. Un serveur git est un serveur qui va
permettre à toutes les personnes travaillant sur un projet de synchroniser leur travail, car Gitlab héberge un dépôt
distant. Gitlab fournit également des outils de coopération, notamment la revue de code. La revue de code permet de
vérifier le code de ses collègues pour vérifier s'il ne contient pas de problème mais aussi pour suggérer des
amélioration de qualité.

## Gradle

https://docs.gradle.org/current/samples/sample_building_java_applications.html