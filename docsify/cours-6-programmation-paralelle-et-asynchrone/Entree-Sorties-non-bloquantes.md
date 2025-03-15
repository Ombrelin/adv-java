# Entrée-Sorties non bloquantes


Dans un système, il y a deux types d'opération qui prennent beaucoup du temps :

- Les opérations liées au temps de calcul (CPU-Bound) : temps passé par le CPU à calculer l'exécution d'algorithmes
- Les opérations liées aux entrées/sorties (IO-Bound) : temps passé par le CPU à attendre la réponse d'un système externe au processus comme un appel réseau, ou un appel au système de fichier.

Les entrées/sorties non bloquantes consistent à récupérer le temps "gâché" à attendre par les opérations IO-Bound pour faire autre chose en attendant.

Par exemple dans le cas assez courant d'un server HTTP qui gère des requêtes, et qui a besoin de faire des appels à une base de donnée pour honorer ces requêtes. Dans un modèle d'entrée/sorties bloquant, on va avoir un thread qui va gérer chaque nouvelle requête. Ce thread va être bloqué à ne rien faire à cause de l'entrée sortie d'abord au moment d'attendre que la requête du client lui soit transférée, puis à nouveau quand il attend la réponse du serveur de base de donnée. Au contraire, dans un modèle non bloquant, lorsqu'il doit attendre l'entrée/sortie, le thread, au lieu d'être bloqué et ne rien faire en attendant, va faire autre chose d'actif et d'utile, par exemple traiter une autre requête.

L'entrée sortie non bloquante est rendu possible par la programmation asynchrone, car ce modèle qui permet de déférer des traitements pour en consommer le résultat plus tard est bien adaptée à cette logique.

## Programmation Asynchrone en Java

Java ne fournit pas un support très avancé de la programmation asynchrone, mais fournit quand même des outils intéressants.

### Thread Pool

Une *thread pool* est un petit groupe de threads à qui on peut soumettre des tâches à exécuter de façon asynchrone. Dans la *thread pool*, ces tâches sont organisées dans une file pour être traitées dans l'ordre. Cela permet de gérer le nombre de threads créés par l'application.

![](../_images/https://www.baeldung.com/wp-content/uploads/2016/08/2016-08-10_10-16-52-1024x572.png)

On peut créer une *thread pool* comme ceci :

```java
ExecutorService threadPool = Executors.newFixedThreadPool(4); // 4 est le nombre de threads dédiées à la pool
```

On peut ensuite lui soumettre des `Runnable` à exécuter en utilisant la méthode `submit`.

### CompletableFuture

`CompletableFuture` est l'implémentation en Java du concept de promesse, il modélise une opération qui se résout de façon asynchrone.

On peut créer un `CompletableFuture` ainsi :

```java
CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> {
    var result = ... opération longue à exécuter de façon asynchrone...
    return result;
});
```

La méthode que l'on passe à `supplyAsync` sera exécutée de façon asynchrone sur une *thread pool* commune gérée par la JVM.

On peut ensuite interagir avec le `CompletableFuture` pour accrocher une continuation via les méthodes suivantes :

- `thenAccept` : exécute une continuation sur le thread courant
- `thenAcceptAsync` : exécute une continuation sur la *thread pool* commune

```java
task.thenAccept((String result) -> System.out.println(result));
```

On peut aussi gérer les erreurs avec `task.exceptionally` :

```java
task.exceptionally(exception -> {
   exception.printStackTrace();
   return "";
});
```

On peut aussi dans certains cas vouloir attendre le résultat d'un `CompletableFuture`, cela peut se faire en utilisant la méthode `get`, qui retourne le résultat, mais en bloquant le thread courant jusqu'à la résolution du `CompletableFuture`.