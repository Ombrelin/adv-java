# Projet

## Introduction

Le Monopoly est un jeu de société très connu. Il n'est pas très fun à jouer, mais il a un intérêt sur le plus pédagogique, car ses règles sont plutôt bien connues et intéressantes à implémenter sous forme de logiciel. Il nous permet aussi d'intégrer facilement les sujets qui nous intéressent dans ce module comme le threading et le réseau.

Pour la petite histoire, le Monopoly a été inventé au début du 20e siècle par [Lizzie Magie](https://en.wikipedia.org/wiki/Lizzie_Magie) pour monter le problème de l'accumulation de la propriété foncière. Je recommande [cette vidéo](https://www.youtube.com/watch?v=tpQ9vyUkB4E) sur le sujet de l'origine du Monopoly si cela vous intéresse. 

## Objectif

L'objectif du projet est, dans un premier temps, d'implémenter une simulation du jeu de société, le Monopoly. Une fois cette simulation mise en place, elle pourra être utilisée pour jouer au jeu entre plusieurs joueurs via le réseau, depuis une interface en ligne de commande d'abord, puis, si le temps le permet avec des éléments d'interface graphique.

## Notation

La notation du projet est conçue pour ne pas être trop punitive pour ceux qui sont en difficulté et récompenser ceux qui s'investissent beaucoup. Je n'hésiterai cependant pas à sanctionner le manque de travail évident. Je n'aurai pas de problème à mettre 0 à quelqu'un qui n'a pas travaillé du tout, tout comme je n'hésiterai pas à mettre 20 à quelqu'un qui fourni un travail complet et de qualité.

Le barème est le suivant : 

- 10 points pour la complétion des fonctionnalités du projet : si votre code passe tous les tests d'intégration fournis, et que je ne repère pas de dysfonctionnement dans votre code, vous avez 10 sur cette partie. Chaque livrable de fonctionnalités rapporte 2 points.
- 10 points de qualité du code :
  - Utilisation de tests unitaires en plus de mes tests (3 points)
  - Application des pratiques de qualité logicielle vus en cours (4 points)
  - Utilisation des fonctionnalités appropriées du langage selon le contexte (3 points)

## Démarrage du projet

### Compte Github

Le projet se déroulera sur Github, vous aurez donc besoin de créer un compte dessus.

### Binômes

Ce projet est à faire par binôme. Une fois que vous avez choisi votre binome, envoyez-moi un email à mon adresse `arsene.lapostolet@intervenants.efrei.net` pour me communiquer votre binôme ainsi que votre nom d'utilisateur Github ainsi que celui de votre binôme. 

### Forker le projet

Le projet est fourni sous forme de template dans [ce dépôt Github](https://github.com/Ombrelin/efrei-adv-java-project), vous devez forker ce projet pour créer votre propre dépôt sur lequel vous allez travailler : 

![](github-fork.jpg)

N'oubliez pas de créer votre projet en privé !

### Ajouter le prof

Ajoutez-moi ensuite sur votre projet (mon nom d'utilisateur est `Ombrelin`) :

![](github-add-collab.jpg)

### Description du dossier du projet

Le projet est un projet Gradle voir [la section du cours à ce sujet](Cours-1-Outillage.md#gradle). Il contient un module appelée `core` qui va contenir du code que je fournis : 

1. Des tests d'intégration, qui vérifient de façon automatique que votre code implémente bien les spécifications requises.
2. Des abstractions (interfaces) qui permettent à mes tests de s'intégrer avec votre code

### Créer votre module

Pour commencer à travailler sur le projet il vous faut créer votre module, qui contiendra votre code de simulation :

1. Créer un nouveau module Gradle nommé `simulation` avec l'aide d'IntelliJ : 

![](ij-new-module.gif)

![](ij-new-module.png)


2. Mettre à jour la configuration Gradle de votre module :

```Groovy
plugins {
    id 'java-library'
}

repositories {
    mavenCentral()
}

dependencies {
    implementation project(":core")
    testImplementation project(":core").sourceSets.test.output
    testImplementation platform('org.junit:junit-bom:5.9.2')
    testImplementation 'org.junit.jupiter:junit-jupiter'
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}


test {
    useJUnitPlatform()
}
```

> Similaire au module `core` mais avec la dépendance du module `simulation` vers le module `core` grâce aux lignes :
> ```Groovy
> implementation project(":core")
> testImplementation project(":core").sourceSets.test.output
> ```

3. Créer votre paquet racine dans votre projet. Suggestion de nommage (dans `main/java` et `test/java`) : `fr.<votre nom><nom binome>.efrei.monopoly.simulation`.
4. Créer un paquet `integration` dans votre paquet de test, et créer une classe `MonopolyTests` qui étend ma classe de test `BaseMonopolyTests`. Ainsi vous pourrez pour le 1er livrable implémenter la méthode `createMonopoly` pour fournir votre propre implémentation de `Monopoly` afin de pouvoir exécuter mes tests avec.
5. Vous êtes prêts à commencer le projet !

## Processus de livraison

1. Fusionner la branche *template/livrable-x* (où *x* est le numéro du livrable) de mon dépôt dans la branche *master* de votre dépôt, afin d'avoir les tests d'intégration correspondant au livrable.
2. Sur votre dépôt, créer une nouvelle branche à partir de la branche master appelée *dev/livrable-x* en remplaçant *x* par le nom du livrable concerné.
3. Commiter sur cette branche les changements permettant de satisfaire les tests d'intégration du livrable
4. Créer une *merge request* de votre branche *dev/livrable-x*, vers votre branche *master*, en me mettant dans le champ *assignee* de la *merge request.
5. Je vais ensuite être notifié de la demande de revue, et vais procéder à une relecture de votre code, et éventuellement faire des commentaires, des recommendations d'amélioration. Une fois ces améliorations implémentée ou votre choix spécifique argumenté, je ferai une évaluer du code en l'état, qui servira pour la partie "qualité" de la notation. Je vais enfin procéder à la fusion de votre branche de livraison sur votre *master*, vous pouvez ainsi reprendre le processus du début, pour le prochain livrable.

> ⚠ Vous ne devez jamais commiter/pousser directement sur la branche *master* de votre dépôt.

## Planning du projet

| Date                     | Sujet                              |
|--------------------------|------------------------------------|
| Vendredi 19 Janvier 2024 | Démarrage du projet                |
| Dimanche 4 Février 2024  | Date limite de rendu du livrable 1 |
| Dimanche 18 Février 2024 | Date limite de rendu du livrable 2 |
| Dimanche 3 Mars 2024     | Date limite de rendu du livrable 3 |
| Vendredi 17 Mars 2024    | Date limite de rendu du livrable 4 |
| Vendredi 31 Mars 2024    | Date limite de rendu du livrable 5 |

## Livrables

### Livrable 1 : Jets de dés, plateau, déplacement

Les joueurs peuvent se déplacer sur le plateau. Pour l'instant les joueurs ne peuvent rien faire, jeu progresse quand ils donnent l'ordre IDLE (ne rien faire), ce qui fait jeter les dés et déplacer le joueur suivant.

La composition du plateau est la suivante, est décrite dans le fichier de ressources `monopoly.csv`. Ce fichier est à parser pour créer une représentation en mémoire du plateau. 

> Pour lire un fichier de ressource, on peut utiliser `getClass().getResourceAsStream("/chemin/du/fichier")`, le chemin à passer étant le chemin du fichier relativement au répertoire `resources` (le premier / est important).

Voici les règles concernant les dés : on simule le jet de deux dés à six face, le score de déplacement est la somme des deux dés. Les dés ne sont pas testés par mes tests, ils sont remplacés par une pseudo entité, mais je corrigerai la validité de votre implémentation ainsi que comment vous l'avez testée.

> Pour implémenter de l'aléatoire en Java, on peut utiliser la classe [`java.util.Random`](https://docs.oracle.com/javase/8/docs/api/java/util/Random.html)

En résumé, 3 tâches à faire pour ce livrable : 

1. Parser le plateau depuis le fichier CSV et en faire une modélisation
2. Implémenter les dés
3. Combiner la modélisation du plateau dans votre simulation de Monopoly afin d'avoir la fonctionnalité de déplacement spécifiée par les tests fournis.

### Livrable 2 : Argent, Achat, Loyers terrain nu, Taxes

Notre variante de Monopoly n'utilise pas la mise aux enchères systématique.

Dans ce livrable, on va implémenter : 

- Un système de gestion de l'argent des joueurs, et des transactions
- Possibilité pour les joueurs d'acheter des propriétés
- Les joueurs doivent régler un loyer lorqu'ils arrivent sur une propriété déjà possédée par un autre joueur
- Les joueurs doivent régler une taxe quand ils tombent sur une case de type taxe

### Livrable 3 : Prison, case départ

### Livrable 4 : Construction et loyers adéquats

### Livrable 5 : Jeu en réseau avec client en ligne de commande

### Livrable 6 (Bonus) : Interface graphique pour le client