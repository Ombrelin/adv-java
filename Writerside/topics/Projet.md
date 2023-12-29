# Projet

## Introduction

Le Monopoly est un jeu de société très connu. Il n'est pas très fun à jouer, mais il a un intérêt sur le plan pédagogique, car ses règles sont plutôt bien connues et intéressantes à implémenter sous forme de logiciel. Il nous permet aussi d'intégrer facilement les sujets qui nous occupent  dans ce module comme le threading et le réseau.

Pour la petite histoire, le Monopoly a été inventé au début du 20e siècle par [Lizzie Magie](https://en.wikipedia.org/wiki/Lizzie_Magie) pour montrer le problème de l'accumulation de la propriété foncière. Je recommande [cette vidéo](https://www.youtube.com/watch?v=tpQ9vyUkB4E) sur le sujet de l'origine du Monopoly si cela vous intéresse. 

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

Le projet est un projet Gradle voir [la section du cours à ce sujet](Cours-1-Outillage.md#gradle). Il contient un module appelé `core` qui va contenir du code que je fournis : 

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

Les joueurs peuvent se déplacer sur le plateau. Pour l'instant les joueurs ne peuvent rien faire, jeu progresse quand ils donnent l'ordre IDLE (ne rien faire), ce qui fait jeter les dés et déplacer le joueur suivant. Les ordres incohérents avec la situation courante du jeu sont ignorés. Un ordre invalide peut être un ordre d'un joueur pour qui ce n'est pas le tour de jouer, ou alors un ordre qui n'est pas cohérent avec la situation courante du tour.

La composition du plateau est la suivante, est décrite dans le fichier de ressources `monopoly.csv` (sous `core/main/resources` dans le projet). Ce fichier est à parser pour créer une représentation en mémoire du plateau. 

![](board.png)

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

- Un système de gestion de l'argent des joueurs, et des transactions. Chaque joueur commence avec une somme de départ de 1500€.
- Possibilité pour les joueurs d'acheter des propriétés
- Les joueurs doivent régler un loyer lorsqu'ils arrivent sur une propriété déjà possédée par un autre joueur
- Les joueurs doivent régler une taxe quand ils tombent sur une case de type taxe

Les loyers terrain nu sont les suivants : 



| Propriété                                                    | Loyer terrain nu |
|--------------------------------------------------------------|------------------|
| <format color="SaddleBrown">Rue Raspail</format>             | 60               |
| <format color="SaddleBrown">Rue Victor Hugo</format>         | 60               | 
| <format color="LightBlue">Rue Jean Jaurès</format>           | 100              |
| <format color="LightBlue">Boulevard Maxime Gorki</format>    | 100              |
| <format color="LightBlue">Rue Youri Gagarine</format>        | 120              |
| <format color="RosyBrown">Avenue Louis Aragon</format>       | 140              | 
| <format color="RosyBrown">Avenue de la République</format>   | 140              |
| <format color="RosyBrown">Avenue de Stalingrad</format>      | 160              |
| <format color="Orange">Allée Berlioz</format>                | 180              |
| <format color="Orange">Rue du Moulin de Saquet</format>      | 180              |
| <format color="Orange">Sentier de la Commune</format>        | 200              |
| <format color="Red">Rue Pascal</format>                      | 220              |
| <format color="Red">Rue Blanqui</format>                     | 220              |
| <format color="Red">Rue Rosa Luxembourg</format>             | 240              |
| <format color="Yellow">Rue de Bretagne</format>              | 260              |
| <format color="Yellow">Rue René Hamon</format>               | 260              |
| <format color="Yellow">Rue Guy Môquet</format>               | 280              |
| <format color="Green">Rue Henri Barbusse</format>            | 300              |
| <format color="Green">Rue Ambroise Croizat</format>          | 300              |
| <format color="Green">Rue de Verdun</format>                 | 320              |
| <format color="Blue">Avenue de Paris</format>                | 350              |
| <format color="Blue">Avenue Paul Vaillant Couturier</format> | 400              |

Pour l'instant le loyer des gare est un prix fixe de 25.

### Livrable 3 : Prison, case départ, gares

#### Prison

Si un joueur tombe sur la case "Aller en prison", il va en prison, et est déplacé sur la case "En prison".

Lors de son prochain tour, si son score au dé est un double, il sort de prison et avance de ce score. Il n'est n'est plus en prison. Sinon, il peut :
- émettre un ordre de PAY_PRISON, ce qui lui coûte 50. S'il fait ça, il avance de son score, il n'est plus en prison.
- émettre un ordre IDLE, il est toujours en prison.

Ces choix s'offrent à lui pour les deux prochains tours. Au 3e tour en prison s'il ne sort pas via les dés, il est obligé de payer.

#### Case départ

Quand un joueur passe par la case départ, il gagne 200.

#### Gares

Le loyer d'une gare est calculé en fonction du nombre de gare possédé par le joueur qui possède la gare : 

| Nombre de gares possédées | Loyer |
|---------------------------|-------|
| 1                         | 25    |
| 2                         | 50    |
| 3                         | 100   |
| 4                         | 200   |

### Livrable 4 : Construction et loyers adéquats

Les joueurs peuvent construire des maisons pour leurs propriétés en émettant un ordre BUILD à leur tour. Cet ordre a un paramètre `propertyName` : le nom de la propriété sur laquelle construire.

Une propriété a cinq niveaux de construction. Voici la spécification des loyer et prix de construction en fonction des propriétés :

| Propriété                                                    | Cout de construction | Loyer "1 Maison" | Loyer "2 Maisons" | Loyer "3 Maisons" | Loyer "4 Maisons" | Loyer "Hotel" |
|--------------------------------------------------------------|----------------------|------------------|-------------------|-------------------|-------------------|---------------|
| <format color="SaddleBrown">Rue Raspail</format>             | 50                   | 10               | 30                | 90                | 160               | 250           |
| <format color="SaddleBrown">Rue Victor Hugo</format>         | 50                   | 20               | 60                | 180               | 320               | 450           | 
| <format color="LightBlue">Rue Jean Jaurès</format>           | 50                   | 30               | 90                | 270               | 400               |               |
| <format color="LightBlue">Boulevard Maxime Gorki</format>    | 50                   | 30               | 90                | 270               | 400               |               |
| <format color="LightBlue">Rue Youri Gagarine</format>        | 50                   | 40               | 100               | 300               | 450               |               |
| <format color="RosyBrown">Avenue Louis Aragon</format>       | 100                  | 50               | 150               | 450               | 625               |               | 
| <format color="RosyBrown">Avenue de la République</format>   | 100                  | 50               | 150               | 450               | 625               |               |
| <format color="RosyBrown">Avenue de Stalingrad</format>      | 100                  | 60               | 180               | 500               | 700               |               |
| <format color="Orange">Allée Berlioz</format>                | 100                  | 70               | 200               | 550               | 750               |               |
| <format color="Orange">Rue du Moulin de Saquet</format>      | 100                  | 70               | 200               | 550               | 750               |               |
| <format color="Orange">Sentier de la Commune</format>        | 100                  | 80               | 220               | 600               |                   |               |
| <format color="Red">Rue Pascal</format>                      | 150                  | 90               | 250               | 700               |                   |               |
| <format color="Red">Rue Blanqui</format>                     | 150                  | 90               | 250               | 700               |                   |               |
| <format color="Red">Rue Rosa Luxembourg</format>             | 150                  | 100              | 300               | 750               |                   |               |
| <format color="Yellow">Rue de Bretagne</format>              | 150                  | 110              | 330               | 800               |                   |               |
| <format color="Yellow">Rue René Hamon</format>               | 150                  | 110              | 330               | 800               |                   |               |
| <format color="Yellow">Rue Guy Môquet</format>               | 150                  | 120              | 360               | 850               |                   |               |
| <format color="Green">Rue Henri Barbusse</format>            | 200                  | 130              | 390               | 900               |                   |               |
| <format color="Green">Rue Ambroise Croizat</format>          | 200                  | 130              | 390               | 900               |                   |               |
| <format color="Green">Rue de Verdun</format>                 | 200                  | 150              | 450               | 1000              |                   |               |
| <format color="Blue">Avenue de Paris</format>                | 200                  | 175              | 500               | 1100              |                   |               |
| <format color="Blue">Avenue Paul Vaillant Couturier</format> | 200                  | 200              | 600               | 1400              |                   |               |


### Livrable 5 : Jeu en réseau avec client en ligne de commande

### Livrable 6 (Bonus) : Interface graphique pour le client