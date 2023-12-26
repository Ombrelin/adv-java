# Projet

## Objectif

L'objectif du projet est, dans un premier temps, d'implémenter une simulation du jeu de société, le Monopoly. Une fois cette simulation mise en place, elle pourra être utilisée pour jouer au jeu entre plusieurs joueurs via le réseau, depuis une interface en ligne de commande d'abord, puis, si le temps le permet avec des éléments d'interface graphique.

## Démarrage du projet

## Livrables

### Livrable 1 : Jets de dés, plateau, déplacement

Les joueurs peuvent se déplacer sur le plateau. Pour l'instant les joueurs ne peuvent rien faire, jeu progresse quand il donne l'ordre IDLE, ce qui fait jeter les dés et déplacer le joueur suivant.

La composition du plateau est la suivante : 

- Case 0 : case départ
- Case 1 : Propriété, Marron 1, 

Voici les règles concernant les dés : on simule le jet de deux dés à six face, le score de déplacement est la somme des deux dés. Les dés ne sont pas testés par mes tests, ils sont remplacés par une pseudo entité, mais je corrigerai la validité de votre implémentation ainsi que comment vous l'avez testée.

### Livrable 2 : Argent, Achat, Loyers terrain nu, Taxes

Variante sans mise aux enchères systématique
- Edge case : gares et companies

### Livrable 3 : Prison, parc gratuit, case départ

### Livrable 4 : Construction et loyers adéquats

## Processus de livraison

1. Fusionner la branche *template/livrable-x* (ù *x* est le numéro du livrable) de mon dépôt dans la branche *master* de votre dépôt, afin d'avoir les tests d'intégration correspondant au livrable.
2. Sur votre dépôt, créer une nouvelle branche à partir de la branche master appelée *dev/livrable-x* en remplaçant *x* par le nom du livrable concerné.
3. Commiter sur cette branche les changements permettant de satisfaire les tests d'intégration du livrable
4. Créer une *merge request* de votre branche *dev/livrable-x*, vers votre branche *master*, en me mettant dans le champ *assignee* de la *merge request.

> ⚠ Vous ne devez jamais commiter/pousser directement sur la branche *master* de votre dépôt.
