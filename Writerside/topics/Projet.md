# Projet

## Introduction

Le Monopoly est un jeu de société très connu. Il n'est pas très fun à jouer, mais il a un intérêt sur le plan pédagogique, car ses règles sont plutôt bien connues et intéressantes à implémenter sous forme de logiciel. Il nous permet aussi d'intégrer facilement les sujets qui nous occupent, dans ce module comme le threading et le réseau.

Pour la petite histoire, le Monopoly a été inventé au début du 20e siècle par [Lizzie Magie](https://en.wikipedia.org/wiki/Lizzie_Magie) pour montrer le problème de l'accumulation de la propriété foncière. Je recommande [cette vidéo](https://www.youtube.com/watch?v=tpQ9vyUkB4E) sur le sujet de l'origine du Monopoly si cela vous intéresse. 

## Objectif

L'objectif du projet est, dans un premier temps, d'implémenter une simulation du jeu de société, le Monopoly. Une fois cette simulation mise en place, elle pourra être utilisée pour jouer au jeu entre plusieurs joueurs via le réseau, depuis une interface en ligne de commande.

## Notation

La notation du projet est conçue pour ne pas être trop punitive pour ceux qui sont en difficulté et récompenser ceux qui s'investissent beaucoup. Je n'hésiterai cependant pas à sanctionner le manque de travail évident. Je n'aurai pas de problème à mettre 0 à quelqu'un qui n'a pas travaillé du tout, tout comme je n'hésiterai pas à mettre 20 à quelqu'un qui fourni un travail complet et de qualité.

Le barème est calculé par livrable, chaque livrable rapporte 4 points. Pour chaque livrable :
- 2 points pour la complétion des fonctionnalités du projet. Si votre code passe tous les tests d'intégration fournis, et que je ne repère pas de dysfonctionnement dans votre code à la revue, vous avez 2/2 sur cette partie.
- 2 points de qualité du code :
  - Implémentation de tests unitaires en plus des tests fournis
  - Application des pratiques de qualité logicielle vus en cours
  - Utilisation des fonctionnalités appropriées du langage selon le contexte

La réalisation du livrable bonus donnera un coup de pouce de +2 points sur la note à l'examen.

## Plagiat

Le code écrit en binôme ne doit en aucun cas être partagé à d'autres binômes. Rien ne vous empêcher de donner un coup de main à des camarades en difficulté en leur réexpliquant des concepts, mais en aucun cas en leur donnant du code. Toute tantative plagiat sera durement sanctionné sur votre note.

## Démarrage du projet

### Compte GitLab

Le projet se déroulera sur GitLab, vous aurez donc besoin de créer un compte dessus.

### Binômes

Ce projet est à faire par binôme. Une fois que vous avez choisi votre binôme, renseignez le sur le document Excel présent dans l'équipe Teams, pour me communiquer votre binôme, votre nom d'utilisateur GitLab ainsi que celui de votre binôme. 

### Forker le projet

Le projet est fourni sous forme de template dans [ce dépôt GitLab](https://gitlab.com/Ombrelin/efrei-adv-java-project), vous devez forker ce projet pour créer votre propre dépôt sur lequel vous allez travailler.

N'oubliez pas de créer votre projet en privé !

### Ajouter le prof & votre binôme

Ajoutez-moi ensuite sur votre projet (mon nom d'utilisateur est `Ombrelin`) avec le rôle "Maintainer".

> N'oubliez pas d'ajouter également votre binôme ! (rôle "Maintainer" également)

### Cloner le projet

Avec de cloner (avec la commande `git clone`) le projet n'oubliez pas de configurer votre compte git en local, en utilisant comme username votre username Gitlab, comme décrit [la section du cours à ce sujet](Git.md), via la command `git config`.

Vous pouvez ensuite ouvrir le dossier du dépôt que vous venez de clôner avec IntelliJ.

### Description du dossier du projet

Le projet est un projet Gradle voir [la section du cours à ce sujet](Cours-1-Outillage.md#gradle). Il contient un module appelé `core` qui va contenir du code que je fournis : 

1. Des tests d'intégration, qui vérifient de façon automatique que votre code implémente bien les spécifications requises.
2. Des abstractions (interfaces) qui permettent à mes tests de s'intégrer avec votre code

### Créer votre module

<procedure>
<p>
Avant de commencer, créer et positionnez-vous sur une nouvelle branche.

Pour commencer à travailler sur le projet il vous faut créer votre module, qui contiendra votre code de simulation :
</p>
<step>
Créer un nouveau module Gradle nommé `simulation` avec l'aide d'IntelliJ. En tant que "GroupId", saisissez `fr.&lt;votre nom&gt;&lt;nom binome&gt;.efrei.monopoly` :

![](ij-new-module.gif)

![](ij-new-module.png)

</step>
<step>
Mettre à jour la configuration Gradle de votre module (le module `simulation`, vous ne devez jamais modifier le module `core` par vous-même) :

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
    testImplementation "org.mockito:mockito-core:3.+"
    testImplementation 'org.assertj:assertj-core:3.24.2'
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

</step>
<step>

Créer votre paquet racine dans votre projet. Suggestion de nommage (dans `main/java` et `test/java`) : `fr.<votre nom><nom binome>.efrei.monopoly.simulation`.

</step>
<step>

Créer un paquet `fr.<votre nom><nom binome>.efrei.monopoly.simulation.integration` dans votre  dossier de test (`simulation/src/test/java`), et créer une classe `MonopolyTests` qui étend ma classe de test `BaseMonopolyTests`. Ainsi, vous pourrez pour le 1er livrable implémenter la méthode `createMonopoly` pour fournir votre propre implémentation de `Monopoly` afin de pouvoir exécuter mes tests avec. 

</step>
<p>
Vous avez terminé le setup pour le projet. Vous pouvez pousser votre branche pour que votre binôme puisse la récupérer de son côté.
</p>
</procedure>

### Note sur l'exécution locale des tests d'intégration fournis dans le projet

La technique utilisée pour permettre de vous fournir des tests que vous pourrez plugger directement à votre code cause un petit souci avec le système d'intégration des tests Gradle d'IntelliJ. Heureusement, il y a une solution de contournement simple.

Le problème est le suivant : si vous exécutez vos tests d'intégration en passant par l'icône dans la marge de la classe et que vous exécutez tous les tests, ou bien que vous exécutez la commande `gradle test` tout va bien, les tests s'exécutent :

![](test-bug-all-tests.png)

Cependant, si vous exécutez un test individuellement via la vue de test (par exemple parce que vous voulez débugger un test spécifique), une erreur apparait : 

![](test-bug-demo.gif)

C'est parce que le système utilise le mauvais nom de classe et de module pour exécuter le test, il les prend de la classe de tests abstraite. Pour résoudre le problème : 

1. Ouvrez la configuration d'exécution qui a été créée par l'essai que vous venez de faire :

![](test-bug-fix-1.gif)

2. Remplacez dans la commande du test : 
   - Le nom du module (`core` par `simulation`)
   - Le nom (complet) de la classe `fr.arsenelapostolet.efrei.monopoly.BaseMonopolyTests` par le nom (complet) de votre classe : `fr.<votre nom><nom binome>.efrei.monopoly.simulation.integration.MonopolyTest`. Pour être sûr d'avoir le bon, vous pouvez le copier-coller de la commande de la config de la classe entière. Faîtes bien attention à laisser le nom de la méthode de test à la fin de la commande.  

![](test-bug-fix-2.gif)

3. Le test devrait d'exécuter sans problème avec cette configuration, vous pouvez même la lancer en mode debug pour faire du pas à pas.

![](test-bug-fix-3.gif)

## Processus de livraison

Pour un livrable donné *x* :

1. Sur votre dépôt, créer une nouvelle branche à partir de la branche master appelée *dev/livrable-x* en remplaçant *x* par le nom du livrable concerné.
2. Fusionner la branche *template/livrable-x* (où *x* est le numéro du livrable) de mon dépôt dans la branche*dev/livrable-x* en question de votre dépôt, afin d'avoir les tests d'intégration correspondant au livrable (vous pouvez le faire via l'interface de GitLab en utilisant une merge request que vous validerez vous-même).
3. Commiter sur cette branche les changements permettant de satisfaire les tests d'intégration du livrable
4. Créer une *merge request* de votre branche *dev/livrable-x*, vers votre branche *master*, en me mettant dans le champ *assignee* de la *merge request*.
5. Je vais ensuite être notifié de la demande de revue, et vais procéder à une relecture de votre code, et éventuellement faire des commentaires, des recommendations d'amélioration. Une fois ces améliorations implémentée ou votre choix spécifique argumenté, je ferai une évaluation du code en l'état, qui servira pour la partie "qualité" de la notation. Je vais enfin procéder à la fusion de votre branche de livraison sur votre *master*, vous pouvez ainsi reprendre le processus du début, pour le prochain livrable.

> ⚠ Vous ne devez *jamais* commiter/pousser directement sur la branche *master* de votre dépôt.

## Planning du projet

| Date                     | Sujet                                      |
|--------------------------|--------------------------------------------|
| Vendredi 19 Janvier 2024 | Démarrage du projet                        |
| Dimanche 4 Février 2024  | Date limite de rendu du livrable 1         |
| Dimanche 18 Février 2024 | Date limite de rendu du livrable 2         |
| Dimanche 3 Mars 2024     | Date limite de rendu du livrable 3         |
| Dimanche 17 Mars 2024    | Date limite de rendu du livrable 4         |
| Dimanche 31 Mars 2024    | Date limite de rendu du livrable 5         |
| Dimanche 14 Avril 2024   | Date limite de rendu du livrable 6 (bonus) |

L'heure limite pour le rendu de chaque livrable est minuit. Si votre travail est prêt avant la date limite, n'attendez pas la dernière minute pour faire votre merge request de rendu. Plus vite vous avez une revue de votre code, plus vite vous pouvez passer à la suite et éventuellement prendre de l'avance.

## Interface publique de la simulation

Le jeu est modélisé par une interface `Simulation` fourni, qui est utilisée dans les tests d'intégration fournis. Votre simulation doit implémenter cette interface.

L'élément central de l'interface est la méthode `submitOrder`, elle permet à un joueur d'effectuer une action, ou de passer son tour (ordre `IDLE`). Cette méthode résout aussi la situation avant l'action à faire par le joueur suivant. 

En résumé `submitOrder` c'est : 

1. Résolution de l'action du joueur
2. Jet de dé pour le déplacement du joueur suivant
3. Résolution du déplacement du joueur suivant et des conséquences de ce déplacement

D'autres méthodes sur l'interface permettent de lire les informations sur la situation courante du jeu.

## Intégration continue

Sur le projet, deux processus d'intégration continue vont s'exécuter quand vous pousserez un commit sur le dépôt : 

- Analyse statique de code (`gradle check`) : qui vérifie via PMD que votre code est bien conforme aux règles que j'ai définies pour le projet.
- Tests (`gradle test`) : qui exécute tous les tests du projet, vos tests unitaires, mais aussi notamment mes tests d'intégration.

Pour qu'une *merge request* soit éligible à la revue par l'enseignant, ces deux processus doivent être en succès, ce qui est visible par des coches vertes en haut de la page de votre *merge request*.

## Livrables

### Livrable 1 : Jets de dés, plateau, déplacement

Les joueurs peuvent se déplacer sur le plateau. Pour l'instant les joueurs ne peuvent rien faire, le jeu progresse quand ils donnent l'ordre `IDLE` (ne rien faire), ce qui passe le tour, et déclenche le jeté les dés et le déplacement pour le joueur suivant. Les ordres incohérents avec la situation courante du jeu sont ignorés. Un ordre invalide peut être un ordre d'un joueur pour qui ce n'est pas le tour de jouer, ou alors un ordre qui n'est pas cohérent avec la situation courante du tour.

La composition du plateau est la suivante, elle est décrite dans le fichier de ressources `monopoly.csv` (sous `core/main/resources` dans le projet). Ce fichier est à parser pour créer une représentation en mémoire du plateau. 

> Pour lire un fichier de ressource, on peut utiliser `getClass().getResourceAsStream("/chemin/du/fichier")`, le chemin à passer étant le chemin du fichier relativement au répertoire `resources` (le premier / est important).

![Le plateau de notre Monopoly "Villejuif"](board.png)

Voici les règles concernant les dés : on simule le jet de deux dés à six face, le score de déplacement est la somme des deux dés ; il faut donc faire deux générations aléatoires pour un lancer de dés. Les dés ne sont pas testés par mes tests, ils sont remplacés par une pseudo entité, mais je corrigerai la validité de votre implémentation ainsi que comment vous l'avez testée.

> Pour implémenter de l'aléatoire en Java, on peut utiliser la classe [`java.util.Random`](https://docs.oracle.com/javase/8/docs/api/java/util/Random.html)

En résumé, 3 tâches à faire pour ce livrable : 

1. Parser le plateau depuis le fichier CSV et en faire une modélisation
2. Implémenter les dés
3. Combiner la modélisation du plateau dans votre simulation de Monopoly afin d'avoir la fonctionnalité de déplacement spécifiée par les tests fournis.

### Livrable 2 : Argent, Achat, Loyers terrain nu

> Notre variante de Monopoly n'utilise pas la mise aux enchères systématique.

Dans ce livrable, on va implémenter : 

- Un système de gestion de l'argent des joueurs, et des transactions. Chaque joueur commence avec une somme de départ de 1500€.
- Possibilité pour les joueurs d'acheter des propriétés, gares et companies, en donnant un ordre de type `BUY` à son tour lorsqu'on est sur une localisation de ce type
- Les joueurs doivent régler un loyer lorsqu'ils arrivent sur une propriété, gare ou compagnie, déjà possédée par un autre joueur
- Les joueurs ne peuvent pas acheter une propriété, gare ou compagnie qui appartient déjà à quelqu'un d'autre

> On utilise pour la modélisation de la monnaie le type [`BigDecimal`](https://docs.oracle.com/javase/8/docs/api/java/math/BigDecimal.html), c'est un type de la librairie standard Java qui permet de représenter des nombres décimaux signés à la précision arbitraire, et permet d'éviter des [erreurs de calcul lié à la virgule flottante](https://en.wikipedia.org/wiki/Floating-point_arithmetic#Accuracy_problems). C'est donc le type [recommandé pour manipuler des valeurs monétaires](https://wiki.sei.cmu.edu/confluence/display/java/NUM04-J.+Do+not+use+floating-point+numbers+if+precise+computation+is+required).

Les loyers terrain nu sont les suivants :

| Propriété                                                    | Loyer terrain nu |
|--------------------------------------------------------------|------------------|
| <format color="SaddleBrown">Rue Raspail</format>             | 2                |
| <format color="SaddleBrown">Rue Victor Hugo</format>         | 4                | 
| <format color="LightBlue">Rue Jean Jaurès</format>           | 6                |
| <format color="LightBlue">Boulevard Maxime Gorki</format>    | 6                |
| <format color="LightBlue">Rue Youri Gagarine</format>        | 8                |
| <format color="RosyBrown">Avenue Louis Aragon</format>       | 10               | 
| <format color="RosyBrown">Avenue de la République</format>   | 10               |
| <format color="RosyBrown">Avenue de Stalingrad</format>      | 12               |
| <format color="Orange">Allée Berlioz</format>                | 14               |
| <format color="Orange">Rue du Moulin de Saquet</format>      | 14               |
| <format color="Orange">Sentier de la Commune</format>        | 16               |
| <format color="Red">Rue Pascal</format>                      | 18               |
| <format color="Red">Rue Blanqui</format>                     | 18               |
| <format color="Red">Rue Rosa Luxembourg</format>             | 20               |
| <format color="Yellow">Rue de Bretagne</format>              | 22               |
| <format color="Yellow">Rue René Hamon</format>               | 22               |
| <format color="Yellow">Rue Guy Môquet</format>               | 24               |
| <format color="Green">Rue Henri Barbusse</format>            | 26               |
| <format color="Green">Rue Ambroise Croizat</format>          | 26               |
| <format color="Green">Rue de Verdun</format>                 | 28               |
| <format color="Blue">Avenue de Paris</format>                | 35               |
| <format color="Blue">Avenue Paul Vaillant Couturier</format> | 50               |

> Ces prix de loyer sont disponibles dans le fichier de ressources `rent.csv`, colonne "bare".

- Pour l'instant le loyer des gares est un prix fixe de 25.
- Le loyer des compagnies se calcule selon la logique suivante : 
  - Si le propriétaire de la compagnie possède une seule des deux compagnies, alors le prix est le score du joueur locataire multiplié par quatre
  - Si le propriétaire de la compagnie possède les deux compagnies, alors le prix est le score du joueur locataire multiplié par dix
  
Si un joueur est confronté à un loyer qu'il ne peut pas payer, il est déclaré en banqueroute, il perd, et est supprimé des joueurs de la partie. Le joueur propriétaire percevant le loyer qui déclenche la banqueroute perçoit l'argent du joueur en banqueroute comme loyer, pas plus. Si la partie contient moins de 2 joueurs, elle s'arrête, c'est-à-dire que tout appel ultérieur à `submitOrder` jette une exception de type `GameFinishedException`.

### Livrable 3 : Prison, case départ, gares

#### Prison

Si un joueur tombe sur la case "Aller en prison", il va en prison, et est déplacé sur la case "En prison".

Lors de son prochain tour, il peut :
- émettre un ordre de `PAY_PRISON`, ce qui lui coûte 50. S'il fait ça, il avance de son score, il n'est plus en prison.
- émettre un ordre `IDLE`, il est toujours en prison.

Ces choix s'offrent à lui pour les deux prochains tours. Au 3e tour, il est obligé de payer, et avance en fonction de son dernier jet de dés.

#### Case départ

Quand un joueur passe par la case départ, il gagne 200.

#### Gares

Le loyer d'une gare est calculé en fonction du nombre de gares possédées par le joueur qui possède la gare : 

| Nombre de gares possédées | Loyer |
|---------------------------|-------|
| 1                         | 25    |
| 2                         | 50    |
| 3                         | 100   |
| 4                         | 200   |

### Livrable 4 : Construction, loyers adéquats et taxes

Les joueurs peuvent construire des maisons pour leurs propriétés en émettant un ordre `BUILD` à leur tour. Cet ordre a un paramètre `propertyName` : le nom de la propriété sur laquelle construire.

Pour construire, un joueur de posséder toutes les propriétés d'un groupe de couleur.

Une propriété a cinq niveaux de construction. Voici la spécification des loyer et prix de construction en fonction des propriétés :

| Propriété                                                    | Cout de construction | Loyer "1 Maison" | Loyer "2 Maisons" | Loyer "3 Maisons" | Loyer "4 Maisons" | Loyer "Hotel" |
|--------------------------------------------------------------|----------------------|------------------|-------------------|-------------------|-------------------|---------------|
| <format color="SaddleBrown">Rue Raspail</format>             | 50                   | 10               | 30                | 90                | 160               | 250           |
| <format color="SaddleBrown">Rue Victor Hugo</format>         | 50                   | 20               | 60                | 180               | 320               | 450           | 
| <format color="LightBlue">Rue Jean Jaurès</format>           | 50                   | 30               | 90                | 270               | 400               | 550           |
| <format color="LightBlue">Boulevard Maxime Gorki</format>    | 50                   | 30               | 90                | 270               | 400               | 550           |
| <format color="LightBlue">Rue Youri Gagarine</format>        | 50                   | 40               | 100               | 300               | 450               | 600           |
| <format color="RosyBrown">Avenue Louis Aragon</format>       | 100                  | 50               | 150               | 450               | 625               | 750           | 
| <format color="RosyBrown">Avenue de la République</format>   | 100                  | 50               | 150               | 450               | 625               | 750           |
| <format color="RosyBrown">Avenue de Stalingrad</format>      | 100                  | 60               | 180               | 500               | 700               | 900           |
| <format color="Orange">Allée Berlioz</format>                | 100                  | 70               | 200               | 550               | 750               | 950           |
| <format color="Orange">Rue du Moulin de Saquet</format>      | 100                  | 70               | 200               | 550               | 750               | 950           |
| <format color="Orange">Sentier de la Commune</format>        | 100                  | 80               | 220               | 600               | 800               | 1000          |
| <format color="Red">Rue Pascal</format>                      | 150                  | 90               | 250               | 700               | 875               | 1050          |
| <format color="Red">Rue Blanqui</format>                     | 150                  | 90               | 250               | 700               | 875               | 1050          |
| <format color="Red">Rue Rosa Luxembourg</format>             | 150                  | 100              | 300               | 750               | 900               | 1100          |
| <format color="Yellow">Rue de Bretagne</format>              | 150                  | 110              | 330               | 800               | 975               | 1150          |
| <format color="Yellow">Rue René Hamon</format>               | 150                  | 110              | 330               | 800               | 975               | 1150          |
| <format color="Yellow">Rue Guy Môquet</format>               | 150                  | 120              | 360               | 850               | 1025              | 1200          |
| <format color="Green">Rue Henri Barbusse</format>            | 200                  | 130              | 390               | 900               | 1100              | 1275          |
| <format color="Green">Rue Ambroise Croizat</format>          | 200                  | 130              | 390               | 900               | 1100              | 1275          |
| <format color="Green">Rue de Verdun</format>                 | 200                  | 150              | 450               | 1000              | 1200              | 1400          |
| <format color="Blue">Avenue de Paris</format>                | 200                  | 175              | 500               | 1100              | 1300              | 1500          |
| <format color="Blue">Avenue Paul Vaillant Couturier</format> | 200                  | 200              | 600               | 1400              | 1700              | 2000          |

> Ces informations sont disponibles au format CSV dans le fichier `rent.csv`, dans les ressources de l'application.

Les classes de taxes doivent débiter les joueurs qui tombent dessus du montant correspondant, qui peut être retrouvé dans la colonne `price` pour les location de type `tax` dans `monopoly.csv`.

### Livrable 5 : Jeu en réseau en mode client-serveur

Nous voulons maintenant utiliser notre simulation de Monopoly afin de jouer en réseau. Nous allons donc devoir créer deux nouveaux modules dans l'application, selon le modèle client-serveur : 
- `client` : application en ligne de commande permettant aux joueurs de jouer au jeu en leur permettant d'envoyer leurs ordres à la simulation, mais aussi de lire des informations sur la situation courante du jeu.
- `server` : application qui fait tourner la simulation en mémoire, et intéragit via le réseau avec les clients pour le permettre de jouer ensemble.

Le client et le serveur devront implémenter un `main` qui permettra de jouer en condition réelles, via une interface en ligne de commandes.

#### Manipulations préparatoires

1. Créer deux nouveaux modules gradle : `client` et `serveur`
2. Ajouter le plugin Gradle `application` au script de build de ces modules
3. Créer une classe `App` contenant une méthode `main` dans chacun des  modules
4. Ajouter la configuration du plugin application pour dire à Gradle quelle est la classe principale au script de build de ces modules : 
```Groovy
application {
    mainClass = 'server.App'
} 
```
5. Ajouter la configuration run plugin application pour correctement câbler l'entrée standard au script de build de ces modules : 
```Groovy
run {
    standardInput = System.in
}
```
6. Ajouter les dépendances et références de projet requises au script de build de ces modules
7. Dans le module `client`, créez une classe de test qui étend `BaseMultiplayerMonopolyGameTests` et implémente les méthodes abstraites avec vos propres classes.

#### Protocole

Le protocole de jeu est le suivant :

1. Le serveur démarre avec en paramètre un certain nombre de joueurs attendus pour la partie. Quand un joueur se connecte, il envoie son pseudo.
2. Une fois le nombre de joueurs attendus connectés, le serveur crée une nouvelle simulation la partie démarre. Il envoie l'état initial de la simulation après création à tous les joueurs.
3. Le serveur entre en attente des envois d'ordre des joueurs. Les joueurs jouent chacun leur tour. Après chaque gestion d'ordre sur la simulation, le serveur envoie aux clients l'état courant de la partie.

L'envoie de l'état de la partie se fait sous la forme d'un format de sérialisation des informations. On envoie une ligne qui contient : 

- L'ordre exécuté et le joueur qui l'exécute au format`joueur:ordre` (et éventuellement un `:propriété` en cas de `BUILD`)
- La localisation des joueurs au format `joueur:location`, séparés par des virgules
- La balance des joueurs au format `joueur:balance`, séparés par des virgules
- L'état de propriété de toutes les cases du plateau au format : `case:propriétaire`, séparés par des virgules

Chaque partie est séparés par des `|`.

Exemple : 

```
player1:BUY|player1:Rue Victor Hugo,player2:Rue Victor Hugo|player1:1444,player2:1496|Départ:null,Rue Raspail:null,Caisse de Communauté:null,Rue Victor Hugo:player1,Impôts sur le revenu:null,Villejuif - Léo Lagrange:null,Rue Jean Jaurès:null,Chance:null,Boulevard Maxime Gorki:null,Rue Youri Gagarine:null,Prison:null,Avenue Louis Aragon:null,Electricité de Villejuif:null,Avenue de la République:null,Avenue de Stalingrad:null,Villejuif - Paul Vaillant-Couturier:null,Allée Berlioz:null,Caisse de Communauté:null,Rue du Moulin de Saquet:null,Sentier de la Commune:null,Rue Carpeaux:null,Rue Pascal:null,Chance:null,Rue Blanqui:null,Rue Rosa Luxembourg:null,Villejuif - Louis Aragon:null,Rue de Bretagne:null,Rue René Hamon:null,Boulangerie La Fabrique:null,Rue Guy Môquet:null,Allez en Prison !:null,Rue Henri Barbusse:null,Rue Ambroise Croizat:null,Caisse de Communauté:null,Rue de Verdun:null,Villejuif - Gustave Roussy:null,Chance:null,Avenue de Paris:null,Taxe foncière:null,Avenue Paul Vaillant Couturier:null
```

#### Tests

Les interfaces `GameServer` et `GameClient` feront le lien entre votre client/serveur et mes tests d'intégration, de la même manière que l'interface `Monopoly` pour la simulation. Le module client doit contenir une implémentation du test d'intégration fourni qui valide le fonctionnement du système client-serveur.


Je ferai également quelques tests manuels pour vérifier que les mains de vos applications fonctionnent correctement et permettent de jouer.

### Livrable 6 (Bonus) : Interface graphique pour le client

Ce livrable est beaucoup plus libre, l'idée est que le client offre une interface graphique qui montre :

- L'état de la partie en temps réel
- Des boutons permettant au joueur d'envoyer ses ordres

Je testerai manuellement cette interface graphique et validerai ou non le bonus en fonction de l'aboutissement du livrable.

### Livrable 6-bis (Bonus) : Créer son propre conteneur d'injection de dépendance

Ce livrable est beaucoup plus libre, l'idée est de développer un conteneur d'injection de dépendances et de l'utiliser dans les applications du livrable 5.

Créer un nouveau module Gradle de type "library" dans le projet qui implémente ce conteneur d'injection de dépendances.

L'interface du conteneur sera la suivante :

```Java
void registerSingleton(Class type)
void registerSingleton(Class interface, Class implementation)

void registerSingleUse(Class type)
void registerSingleUse(Class interface, Class implementation)

Object resolve(Class type);
```