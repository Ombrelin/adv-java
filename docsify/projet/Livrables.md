# Livrables

## Livrable 1 : Jets de dés, plateau, déplacement

Les joueurs peuvent se déplacer sur le plateau. Pour l'instant les joueurs ne peuvent rien faire, le jeu progresse quand ils donnent l'ordre `IDLE` (ne rien faire), ce qui passe le tour, et déclenche le jeté les dés et le déplacement pour le joueur suivant. Les ordres incohérents avec la situation courante du jeu sont ignorés. Un ordre invalide peut être un ordre d'un joueur pour qui ce n'est pas le tour de jouer, ou alors un ordre qui n'est pas cohérent avec la situation courante du tour.

La composition du plateau est la suivante, elle est décrite dans le fichier de ressources `monopoly.csv` (sous `core/main/resources` dans le projet). Ce fichier est à parser pour créer une représentation en mémoire du plateau.

> Pour lire un fichier de ressource, on peut utiliser `getClass().getResourceAsStream("/chemin/du/fichier")`, le chemin à passer étant le chemin du fichier relativement au répertoire `resources` (le premier / est important).

![Le plateau de notre Monopoly "Villejuif"](../_images/board.png)

Voici les règles concernant les dés : on simule le jet de deux dés à six face, le score de déplacement est la somme des deux dés ; il faut donc faire deux générations aléatoires pour un lancer de dés. Les dés ne sont pas testés par mes tests, ils sont remplacés par une pseudo entité, mais je corrigerai la validité de votre implémentation ainsi que comment vous l'avez testée.

> Pour implémenter de l'aléatoire en Java, on peut utiliser la classe [`java.util.Random`](https://docs.oracle.com/javase/8/docs/api/java/util/Random.html)

En résumé, 3 tâches à faire pour ce livrable :

1. Parser le plateau depuis le fichier CSV et en faire une modélisation
2. Implémenter les dés
3. Combiner la modélisation du plateau dans votre simulation de Monopoly afin d'avoir la fonctionnalité de déplacement spécifiée par les tests fournis.

## Livrable 2 : Argent, Achat, Loyers terrain nu

> Notre variante de Monopoly n'utilise pas la mise aux enchères systématique.
> {style="note"}

Dans ce livrable, on va implémenter :

- Un système de gestion de l'argent des joueurs, et des transactions. Chaque joueur commence avec une somme de départ de 1500€.
- Possibilité pour les joueurs d'acheter des propriétés, gares et companies, en donnant un ordre de type `BUY` à son tour lorsqu'on est sur une localisation de ce type.
- Les joueurs doivent régler un loyer lorsqu'ils arrivent sur une propriété, gare ou compagnie, déjà possédée par un autre joueur.
- Les joueurs ne peuvent pas acheter une propriété, gare ou compagnie qui appartient déjà à quelqu'un d'autre.

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

> Ces prix de loyer sont disponibles dans le fichier de ressources founri dans le projet `rent.csv`, colonne "bare".
> {style="note"}

- Pour l'instant le loyer des gares est un prix fixe de 25.
- Le loyer des compagnies se calcule selon la logique suivante :
    - Si le propriétaire de la compagnie possède une seule des deux compagnies, alors le prix est le score du joueur locataire multiplié par quatre
    - Si le propriétaire de la compagnie possède les deux compagnies, alors le prix est le score du joueur locataire multiplié par dix

Si un joueur est confronté à un loyer qu'il ne peut pas payer, il est déclaré en banqueroute, il perd, et est supprimé des joueurs de la partie. Le joueur propriétaire percevant le loyer qui déclenche la banqueroute perçoit l'argent du joueur en banqueroute comme loyer, pas plus. Si la partie contient moins de 2 joueurs, elle s'arrête, c'est-à-dire que tout appel ultérieur à `submitOrder` jette une exception de type `GameFinishedException`.

## Livrable 3 : Prison, case départ, gares

### Prison

Si un joueur tombe sur la case "Aller en prison", il va en prison, et est déplacé sur la case "En prison".

Lors de son prochain tour, il peut :
- émettre un ordre de `PAY_PRISON`, ce qui lui coûte 50. S'il fait ça, il avance de son score, il n'est plus en prison.
- émettre un ordre `IDLE`, il est toujours en prison.

Ces choix s'offrent à lui pour les deux prochains tours. Au 3e tour, il est obligé de payer, et avance en fonction de son dernier jet de dés.

### Case départ

Quand un joueur passe par la case départ, il gagne 200.

### Gares

Le loyer d'une gare est calculé en fonction du nombre de gares possédées par le joueur qui possède la gare :

| Nombre de gares possédées | Loyer |
|---------------------------|-------|
| 1                         | 25    |
| 2                         | 50    |
| 3                         | 100   |
| 4                         | 200   |

## Livrable 4 : Construction, loyers adéquats et taxes

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
> {style="note"}

Les classes de taxes doivent débiter les joueurs qui tombent dessus du montant correspondant, qui peut être retrouvé dans la colonne `price` pour les localisations de type `tax` dans `monopoly.csv`.

## Livrable 5 : Jeu en réseau en mode client-serveur

Nous voulons maintenant utiliser notre simulation de Monopoly afin de jouer en réseau. Nous allons donc devoir créer deux nouveaux modules dans l'application, selon le modèle client-serveur :
- `client` : application en ligne de commande permettant aux joueurs de jouer au jeu en leur permettant d'envoyer leurs ordres à la simulation, mais aussi de lire des informations sur la situation courante du jeu.
- `server` : application qui fait tourner la simulation en mémoire, et intéragit via le réseau avec les clients pour le permettre de jouer ensemble.

Le client et le serveur devront implémenter un `main` qui permettra de jouer en condition réelles, via une interface en ligne de commandes.

### Manipulations préparatoires

<procedure>
<step>
Créer deux nouveaux modules gradle : `client` et `serveur`.
</step>
<step>Ajouter le plugin Gradle `application` au script de build de ces modules.</step>
<step>Créer une classe `App` contenant une méthode `main` dans chacun des modules.</step>
<step>
Ajouter la configuration du plugin application pour dire à Gradle quelle est la classe principale au script de build de ces modules :

```Groovy
application {
    mainClass = 'server.App'
} 
```

</step>
<step>
Ajouter la configuration run plugin application pour correctement câbler l'entrée standard au script de build de ces modules :

```Groovy
run {
    standardInput = System.in
}
```

</step>
<step> Ajouter les dépendances et références de projet requises au script de build de ces modules.</step>
<step>

Dans le module `client`, créez une classe de test qui étend `BaseMultiplayerMonopolyGameTests` et implémente les méthodes abstraites avec vos propres classes.

</step>
</procedure>

### Protocole

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

### Tests

Les interfaces `GameServer` et `GameClient` feront le lien entre votre client/serveur et mes tests d'intégration, de la même manière que l'interface `Monopoly` pour la simulation. Le module client doit contenir une implémentation du test d'intégration fourni qui valide le fonctionnement du système client-serveur.


Je ferai également quelques tests manuels pour vérifier que les mains de vos applications fonctionnent correctement et permettent de jouer.