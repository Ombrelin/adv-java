# Threads en Java

## Notion de Thread

Un thread (*thread* veut dire fil en anglais) est un fil d'exécution de code. Les différents threads d'un processus sont différents fils d'exécution parallèles (ils s'exécutent en même temps) tout en partageant la mémoire. Lors du démarrage d'un programme, ce dernier possède un thread dit principal, et il est possible de lancer de nouveaux threads au sein du programme.

Attention : la notion de thread est une abstraction issue du système d'exploitation, et non la JVM. Quand on crée un thread en Java, il y a un appel au système d'exploitation, qui va créer un thread. Cette opération est couteuse. C'est pourquoi, lorsqu'on souhaite utiliser de la parallèlisation pour accélérer l'exécution d'une tâche, il faut bien pondérer si cela vaut le coup ou non : si le temps d'exécution économisé par la parallèlisation des tâches est supérieur au temps nécessaire pour lancer le nombre de threads requis.

## Threads en Java

Pour créer un thread en Java, on utilise la classe `Thread` et son constructeur qui prend en argument l'interface fonctionnelle `Runnable`. On peut donc passer au thread son code à exécuter, en utilisant au choix :

- Une lambda
- Une référence de méthode
- Une classe qui implémente l'interface `Runnable`

Pour lancer le thread, il suffit d'appeler la fonction méthode `start`. Par exemple, si on veut faire deux threads qui comptent en même temps, l'un compte les nombre impairs (*odd*) l'autre les nombres pairs (*even*) :

```Java
var oddThread = new Thread(() -> {
    IntStream
            .range(0, 100)
            .filter(number -> number % 2 != 0)
            .forEach(System.out::println);
});

var evenThread = new Thread(() -> {
    IntStream
            .range(0, 100)
            .filter(number -> number % 2 == 0)
            .forEach(System.out::println);
});

evenThread.start();
oddThread.start();

Thread.sleep(5000);
```

`Thread.sleep` permet d'endormir le thread courant pour un certain temps. Ici, on l'utilise pour endormir le thread principal en attendant que nos deux threads aient fini de s'exécuter. Si l'on ne fait pas ça, le thread principal se finirait immédiatement (lui a fini son travail), et on ne verrait pas les résultats de nos deux threads qui comptent.
