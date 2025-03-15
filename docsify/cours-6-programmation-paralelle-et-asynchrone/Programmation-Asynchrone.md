# Programmation Asynchrone

## Définition

La programmation asynchrone est une technique qui consiste à utiliser une abstraction en plus des threads pour organiser le parallèlisme de façon plus optimisée :

- En utilisant moins de threads pour faire la même chose : on passe moins de temps et de mémoire à créer des threads.
- En utilisant des entrées/sorties non bloquantes pour utiliser au maximum le temps CPU

On peut même faire de la programmation asynchrone sur un seul thread, pour les curieux, c'est d'ailleurs [comme ça que fonctionne Node JS](https://nodejs.org/en/guides/event-loop-timers-and-nexttick).

Ce paradigme de programmation être très utile dans plusieurs cas courants :

- Serveur d'application qui doit gérer de façon concurrente des requêtes de clients tout en intéragissant avec des systèmes externes
- Application graphique qui a besoin de faire des tâches prenant du temps en arrière-plan, sans pour autant bloquer l'interface graphique

Les abstractions au-dessus des threads propres à la programmation asynchrone sont les suivantes :

- Promesse : une promesse est une tâche qui va être réalisée de façon asynchrone, dont on aura la confirmation de la résolution plus tard dans le futur. Elle peut avoir ou non une donnée en résultat.
- Continuation : une continuation est le code qui doit s'exécuter lorsque la promesse a été résolue : elle  implémente de la logique pour réagir au succès ou à l'échec de l'opération, ou alors consommée une donnée produite par la promesse