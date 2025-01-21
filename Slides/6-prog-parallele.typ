#import "@preview/polylux:0.3.1": *
#import "@preview/sourcerer:0.2.1": code
#import themes.clean: *

#show: clean-theme.with(
  logo: image("images/efrei.jpg"),
  footer: [Arsène Lapostolet, EFREI Paris],
  short-title: [EFREI LSI L3 ALSI62-CTP : Java Avancé],
  color: rgb("#EB6237")
)

#title-slide(
  title: [Java Avancé],
  subtitle: [Cours 5 : Programmation Parallèle et Asynchrone],
  authors: ([Arsène Lapostolet]),
  date: [28 Février 2025],
)

#new-section-slide("Introduction")

#slide(title: "Thread")[

*Thread* : fil d'exécution. Plusieurs en même temps possible.

- Améliorer la vitesse d'un process : attention à l'overhead
- Permettre un cas d'utilisation : ex modèle client-serveur

]

#slide(title: "Thread Java")[

- Classe `Thread`, construit à partir d'un `Runnable`
- Lancer avec la méthode `start()`

    #code(
  lang: "Java",
```java
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
```)

]


#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#new-section-slide("Synchronisation")

#slide(title: "Joindre")[

- Attendre la fin d'un thread

    #code(
  lang: "Java",
```java
evenThread.join();
oddThread.join();
```)

à la place de `Thread.sleep()`
]

#slide(title: "Ressource partagée et section critique")[

- Section critique : à excéuter atomiquement sinon problème
- `synchronized` : un seul thread à la fois sur la section
- Collections syncrhonisées : `Collections.synchronizedList(new ArrayList<>())`
- Attention au coût
- Section critiques synchronisées : *code thread-safe*

]

#slide(title: "Ressource partagée et section critique")[

    #code(
  lang: "Java",
```java
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
var hotel = new Hotel(20);
var reservationThread1 = new Thread(() -> hotel.bookRooms(3));
var reservationThread2 = new Thread(() -> hotel.bookRooms(7));

```)

]

#slide(title: "Ressource partagée et section critique")[

    #code(
  lang: "Java",
```java
public synchronized void bookRooms(int numberOfBookedRooms){
    if(getAvailableRoomCount() - numberOfBookedRooms < 0){
        throw new IllegalArgumentException("Not enough rooms available");
    }
    else {
        bookedRoomsCount += numberOfBookedRooms;
    }
}
```
    )

]

#slide(title: "Coordonner")[

- Coordonner des threads entre eux
- `wait` : attendre un signal
- `notify` : envoyer un signal
- Dans un bloc `synchronized`

]

#slide(title: "Coordonner")[

    #code(
  lang: "Java",
```java
var token = new Object();

var oddThread = new Thread(() -> {
    var oddNumbers = ...
    for (var oddNumber : oddNumbers) {
        synchronized (token) {
            token.wait();
            System.out.println(oddNumber);
            token.notify();
        }
    }
});
var evenThread = new Thread(() -> {
    var evenNumbers = ...
    for (var evenNumber : evenNumbers) {
        System.out.println(evenNumber);
        synchronized (token) {
            token.notify();
            token.wait();
        }
    }
});
```
    )

]


#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#new-section-slide("Programmation Asynchrone")

#slide(title: "Définition")[

- Abstraction au dessus des threads : tâches
- Mutualiser les threads
- Optimiser le temps CPU (I/O non bloquantes)

*Notions : *

- Promesse : tâche qui va être réalisée de façon asynchrone, on aura la résolution  dans le futur
- Continuation : s'exécute sur le résultat de la promesse
]

#slide(title: "Notion d'I/O non bloquantes")[

- CPU-bound : calculs, algos
- I/O-bound : attendre (appel réseau, système de fichiers)

_Attente I/O = Temps CPU gaché_

*Objectif* : le CPU fait autre chose quand il attend l'I/O

]

#slide(title: "Asynchrone en Java : ThreadPool")[

Groupe de threads qui vont traiter une série de tâches

    #code(
  lang: "Java",

```java
ExecutorService threadPool = Executors.newFixedThreadPool(4);

threadPool.submit(() -> {

  ...

} )
```)



]

#slide(title: "Promesse en Java : CompletableFuture")[

    #code(
  lang: "Java",

```java
CompletableFuture<String> task = CompletableFuture
.supplyAsync(() -> {
    var result = ... opération longue async...
    return result;
});

task.thenAccept((String result) -> println(result));

task.exceptionally(exception -> {
   exception.printStackTrace();
   return "";
});
```
    )
]