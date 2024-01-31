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
  date: [2 Février 2024],
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
```

]

#new-section-slide("Synchronisation")

#slide(title: "Joindre")[



]

#slide(title: "Ressource partagée et section critique")[



]

#slide(title: "Synchroniser")[



]

#new-section-slide("Programmation Asynchrone")

#slide(title: "Définition")[



]

#slide(title: "Notion d'E/S non bloquantes")[



]

#slide(title: "Asynchrone en Java")[

Thread Pool : 

```java
ExecutorService threadPool = Executors.newFixedThreadPool(4);
```

CompletableFuture :

```java
CompletableFuture<String> task = CompletableFuture.supplyAsync(() -> {
    var result = ... opération longue à exécuter de façon asynchrone...
    return result;
});

task.thenAccept((String result) -> System.out.println(result));

task.exceptionally(exception -> {
   exception.printStackTrace();
   return "";
});
```

]