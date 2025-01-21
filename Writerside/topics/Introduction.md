# Introduction

Le Monopoly est un jeu de société très connu. Il n'est pas très fun à jouer, mais il a un intérêt sur le plan pédagogique, car ses règles sont plutôt bien connues et intéressantes à implémenter sous forme de logiciel. Il nous permet aussi d'intégrer facilement les sujets qui nous occupent, dans ce module comme la programmation parallèle et la programmation réseau.

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

Au moment de la correction, si je remarque une erreur, j'écrirai un commentaire dans votre *merge request* de rendu qui décrit l'erreur, en fonction de la gravité de l'erreur, je la classerai parmi : 

- mineure : coûte 0.1 point (2.5% de la note du livrable)
- intermédiaire : coûte 0.3 point (7.5% de la note du livrable) 
- majeure : coûte 0.5 point (10% de la note du livrable)

À la fin de votre *merge request* de rendu, je mettrai un commentaire qui compile les erreurs s'ils y en a et qui donne la note du livrable.

## Plagiat

Le code écrit en binôme ne doit en aucun cas être partagé à d'autres binômes. Rien ne vous empêche de donner un coup de main à des camarades en difficulté en leur réexpliquant des concepts, mais en aucun cas en leur donnant du code. Toute tentative plagiat sera durement sanctionnée. S'il vous plaît, ne faîtes pas ça, j'ai autre chose à faire qu'assister à des conseils de discipline.

## Utilisation des outils dits d'"Intelligence Artificielle" générative type "LLM"

L'école interdit formellement l'utilisation des outils d'"Intelligence Artificielle" générative type "LLM" dans les rendus. Personnellement, je trouve que ce choix de la part de l'EFREI n'est pas une mauvaise idée. Pourquoi ?

Dans le cadre de mon métier d'ingénieur en développement logiciel, je trouve les outils d'"Intelligence Artificielle" générative type "LLM" inefficaces. En effet, à cause de leur fonctionnement statistique, on ne peut pas du tout faire confiance aux résultats qu'ils nous fournissent. Il est donc en général beaucoup plus fiable et rapide de chercher la réponse à une question qu'on se pose dans la documentation de notre outil, sur stackoverflow.com ou même sur un moteur de recherche (google.com ou autre). Le contenu qu'on trouve à ces endroits est normalement écrit par des humaines, et donc plus fiable.

Aussi les outils d'IA type LLM ont un impact écologique très important, car leur entraiment et leur utilisation consomme beaucoup d'électricité, ils ont donc un impact fort sur l'utilisation de ressources limitées ainsi que sur le climat de notre planète. Leur utilité assez marginale par rapport à ce fait les rend à mon avis nocif.