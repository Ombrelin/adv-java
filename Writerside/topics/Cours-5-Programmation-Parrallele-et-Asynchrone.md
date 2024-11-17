# Cours 6 : Programmation Parallèle et Asynchrone

## Programmation parallèle

La programmation parallèle permet aux ordinateurs d'avoir plusieurs tâches qui s'exécutent en même temps. Cela peut être utile au sein de d'une application dans plusieurs cas de figure.

- Améliorer la vitesse d'exécution d'une tâche qui prend beaucoup de temps et qui peut être découpée : découper la tâche en plusieurs sous parties, et exécuter ces différentes parties en parallèle
- Permettre des cas d'utilisations : par exemple permettre à un serveur de traiter les requêtes de clients en parallèle

### Notion de Thread

Un thread (*thread* veut dire fil en anglais) est un fil d'exécution de code. Les différents threads d'un processus sont différents fils d'exécution parallèles (ils s'exécutent en même temps) tout en partageant la mémoire. Lors du démarrage d'un programme, ce dernier possède un thread dit principal, et il est possible de lancer de nouveaux threads au sein du programme.

Attention : la notion de thread est une abstraction issue du système d'exploitation, et non la JVM. Quand on crée un thread en Java, il y a un appel au système d'exploitation, qui va créer un thread. Cette opération est couteuse. C'est pourquoi, lorsqu'on souhaite utiliser de la parallèlisation pour accélérer l'exécution d'une tâche, il faut bien pondérer si cela vaut le coup ou non : si le temps d'exécution économisé par la parallèlisation des tâches est supérieur au temps nécessaire pour lancer le nombre de threads requis.

### Threads en Java

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

### Synchronisation de threads

#### Joindre

Dans certaines situations, on peut avoir besoin de coordonner plusieurs threads en eux. Par exemple, un thread pourrait avoir besoin du résultat d'un autre pour continuer son travail, ou on peut vouloir ordonner certaines tâches pour avoir un résultat cohérent. Pour cela, la méthode `join` est utile : le thread courant, c'est-à-dire le thread qui exécute cet appel de méthode, va attendre que le thread sur lequel il appelle la méthode se termine pour continuer.


Par exemple, on peut modifier notre programme avec les deux threads compteurs afin que le thread principal n'attende plus les deux threads compteurs un temps donné (ce qui peut être risqué si l'opération prend finalement plus de temps que prévu), en utilisant `join` afin que le thread principal attendre forcément la terminaison des deux threads :

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

evenThread.join();
oddThread.join();
```

#### Ressource partagée et section critique

Une section critique est une partie de code que l'on veut toujours exécuter atomiquement pour un thread, c'est-à-dire qu'on veut éviter que cette partie de code soit exécutée par plusieurs threads en même temps, pour éviter d'avoir des incohérences dans nos données.

Typiquement, quand il y a un test et une modification en fonction de ce test d'une variable partagée entre plusieurs threads.

Par exemple, j'ai une classe `Hotel` qui compte des réservations, on ne doit pas valider plus de réservations de chambre que de chambres dans l'hôtel : 

```Java
public class Hotel {

    private final int roomsCount;
    private int bookedRoomsCount = 0;

    public Hotel(int roomsCount) {
        this.roomsCount = roomsCount;
    }

    public int getAvailableRoomCount(){
        return roomsCount - bookedRoomsCount;
    }

    public void bookRooms(int numberOfBookedRooms){
        if(getAvailableRoomCount() - numberOfBookedRooms < 0){
            throw new IllegalArgumentException("Not enough rooms available");
        }
        else {
            bookedRoomsCount += numberOfBookedRooms;
        }
    }
}
```

Faisons ensuite exécuter ces réservations par différents threads : 

```Java
var hotel = new Hotel(20);

var reservationThread1 = new Thread(() -> hotel.bookRooms(3));
var reservationThread2 = new Thread(() -> hotel.bookRooms(7));
var reservationThread3 = new Thread(() -> hotel.bookRooms(8));
var reservationThread4= new Thread(() -> hotel.bookRooms(8));


reservationThread1.start();
reservationThread2.start();
reservationThread3.start();
reservationThread4.start();

reservationThread1.join();
reservationThread2.join();
reservationThread3.join();
reservationThread4.join();
```

Dans cette situation, on a un problème : on a aucune assurance qu'après l'exécution de la ligne `getAvailableRoomCount() - numberOfBookedRooms < 0` par un thread, pour vérifier qu'il y a assez de places, on ait la ligne `bookedRoomsCount += numberOfBookedRooms;` d'une autre thread qui soit exécuté, modifiant ainsi le nombre de places réservées sans que le premier thread puisse le savoir, ce dernier va donc procéder à l'incrémentation `bookedRoomsCount += numberOfBookedRooms;`, potentiellement en excédant la limite de places réservées de l'hôtel. On obtiendrait ainsi une situation logiquement incorrecte. La méthode `bookRooms` de l'hôtel est de ce fait une section critique, on veut que chaque thread exécute les deux instructions à la suite, sans intervention d'un autre thread entre temps.

Afin de protéger les sections critiques, Java fournit le mot-clé `synchronized` pour permet à un thread de "prendre la main" sur un objet le temps de la section critique. On peut donc protéger la section critique dans notre code pour garantir une exécution cohérente : 

```Java
var hotel = new Hotel(20);

var reservationThread1 = new Thread(() -> {
    synchronized (hotel) {
        hotel.bookRooms(3);
    }
});

var reservationThread2 = new Thread(() -> {
    synchronized (hotel) {
        hotel.bookRooms(7)
    }
});
var reservationThread3 = new Thread(() -> {
    synchronized (hotel) {
        hotel.bookRooms(8)
    }
});
var reservationThread4 = new Thread(() -> {
    synchronized (hotel) {
        hotel.bookRooms(8)
    }
});


reservationThread1.start();
reservationThread2.start();
reservationThread3.start();
reservationThread4.start();

reservationThread1.join();
reservationThread2.join();
reservationThread3.join();
reservationThread4.join();

System.out.println(hotel.getAvailableRoomCount());
```

Ainsi, quand un thread commence la section synchronisée d'un objet, il a la certitude qu'aucun autre thread n'aura accès à cet objet avant qu'il n'ait fini d'exécuter la section synchronisée.

Attention cependant ! La synchronisation coûte en performance, et limite le parallèlisme, donc il faut la restreindre uniquement aux situations où c'est nécessaire.

Aussi, ici la ressource partagée est un objet à nous (l'hôtel), mais si cette dernière est une structure de donnée comme une liste ou une map, Java fournit des équivalents de ces structures de donnée synchronisées aux endroits où il faut, par exemple : 

```Java
var synchronizedList = Collections.synchronizedList(new ArrayList<Integer>());
```

On dit d'un code qui gère bien la synchronisation pour assurer la cohérence des données qu'il est *thread safe*.

#### Synchroniser

Parfois, on peut avoir besoin de faire s'attendre dynamiquement des threads afin de coordonner leur action en fonction de ressources partagées. Les méthodes `wait` et `notify` sont présentes sur tous les objets Java, et permettent aux threads se passer des signaux concernant ces objets. Quand un thread exécute `wait` sur un objet, il indique qu'il attend d'être notifié que cet objet est disponible pour lui, il va donc attendre jusqu'à ce qu'un autre thread appelle `notify` sur cet objet.

Par exemple, on peut modifier notre programme avec les deux threads compteurs pour qu'ils soient coordonnées, et affichent les nombres dans l'ordre : 

```Java
var token = new Object();

var oddThread = new Thread(() -> {
    var oddNumbers = IntStream
            .range(0, 100)
            .filter(number -> number % 2 != 0)
            .toArray();

    for (var oddNumber : oddNumbers) {
        synchronized (token) {
            try {
                token.wait();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
            System.out.println(oddNumber);
            token.notify();
        }
    }
});

var evenThread = new Thread(() -> {
    var evenNumbers = IntStream
            .range(0, 100)
            .filter(number -> number % 2 == 0)
            .toArray();

    for (var evenNumber : evenNumbers) {
        System.out.println(evenNumber);
        synchronized (token) {
            token.notify();
            try {
                token.wait();
            } catch (InterruptedException e) {
                throw new RuntimeException(e);
            }
        }
    }
});

evenThread.start();
oddThread.start();

evenThread.join();
oddThread.join();
```

Ici, les deux threads vont utiliser la ressource partager `token` pour s'attendre l'un l'autre à chaque fois qu'il affiche un nombre, chacun leur tour, afin de garantir que les numéros seront affichés bien dans l'ordre par les deux threads.

## Programmation Asynchrone

### Définition

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

## Entrées/Sorties Non Bloquantes

Dans un système, il y a deux types d'opération qui prennent beaucoup du temps : 

- Les opérations liées au temps de calcul (CPU-Bound) : temps passé par le CPU à calculer l'exécution d'algorithmes
- Les opérations liées aux entrées/sorties (IO-Bound) : temps passé par le CPU à attendre la réponse d'un système externe au processus comme un appel réseau, ou un appel au système de fichier.

Les entrées/sorties non bloquantes consistent à récupérer le temps "gâché" à attendre par les opérations IO-Bound pour faire autre chose en attendant.

Par exemple dans le cas assez courant d'un server HTTP qui gère des requêtes, et qui a besoin de faire des appels à une base de donnée pour honorer ces requêtes. Dans un modèle d'entrée/sorties bloquant, on va avoir un thread qui va gérer chaque nouvelle requête. Ce thread va être bloqué à ne rien faire à cause de l'entrée sortie d'abord au moment d'attendre que la requête du client lui soit transférée, puis à nouveau quand il attend la réponse du serveur de base de donnée. Au contraire, dans un modèle non bloquant, lorsqu'il doit attendre l'entrée/sortie, le thread, au lieu d'être bloqué et ne rien faire en attendant, va faire autre chose d'actif et d'utile, par exemple traiter une autre requête.

L'entrée sortie non bloquante est rendu possible par la programmation asynchrone, car ce modèle qui permet de déférer des traitements pour en consommer le résultat plus tard est bien adaptée à cette logique.

### Programmation Asynchrone en Java

Java ne fournit pas un support très avancé de la programmation asynchrone, mais fournit quand même des outils intéressants.

#### Thread Pool

Une *thread pool* est un petit groupe de threads à qui on peut soumettre des tâches à exécuter de façon asynchrone. Dans la *thread pool*, ces tâches sont organisées dans une file pour être traitées dans l'ordre. Cela permet de gérer le nombre de threads créés par l'application.

![](https://www.baeldung.com/wp-content/uploads/2016/08/2016-08-10_10-16-52-1024x572.png)

On peut créer une *thread pool* comme ceci : 

```Java
ExecutorService threadPool = Executors.newFixedThreadPool(4); // 4 est le nombre de threads dédiées à la pool
```

On peut ensuite lui soumettre des `Runnable` à exécuter en utilisant la méthode `submit`.

#### CompletableFuture

`CompletableFuture` est l'implémentation en Java du concept de promesse, il modélise une opération qui se résout de façon asynchrone.

On peut créer un `CompletableFuture` ainsi : 

```Java
CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> {
    var result = ... opération longue à exécuter de façon asynchrone...
    return result;
});
```

La méthode que l'on passe à `supplyAsync` sera exécutée de façon asynchrone sur une *thread pool* commune gérée par la JVM.

On peut ensuite interagir avec le `CompletableFuture` pour accrocher une continuation via les méthodes suivantes : 

- `thenAccept` : exécute une continuation sur le thread courant
- `thenAcceptAsync` : exécute une continuation sur la *thread pool* commune

```Java
task.thenAccept((String result) -> System.out.println(result));
```

On peut aussi gérer les erreurs avec `task.exceptionally` : 

```Java
task.exceptionally(exception -> {
   exception.printStackTrace();
   return "";
});
```

On peut aussi dans certains cas vouloir attendre le résultat d'un `CompletableFuture`, cela peut se faire en utilisant la méthode `get`, qui retourne le résultat, mais en bloquant le thread courant jusqu'à la résolution du `CompletableFuture`.

## Références du cours

- [Javadoc Thread](https://docs.oracle.com/javase/8/docs/api/java/lang/Thread.html)
- [Baeldung Async Programming](https://www.baeldung.com/java-asynchronous-programming#bd-asyncJava)