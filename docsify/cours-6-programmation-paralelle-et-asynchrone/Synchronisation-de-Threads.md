# Synchronisation de Threads

## Synchronisation de threads

### Joindre

Dans certaines situations, on peut avoir besoin de coordonner plusieurs threads en eux. Par exemple, un thread pourrait avoir besoin du résultat d'un autre pour continuer son travail, ou on peut vouloir ordonner certaines tâches pour avoir un résultat cohérent. Pour cela, la méthode `join` est utile : le thread courant, c'est-à-dire le thread qui exécute cet appel de méthode, va attendre que le thread sur lequel il appelle la méthode se termine pour continuer.


Par exemple, on peut modifier notre programme avec les deux threads compteurs afin que le thread principal n'attende plus les deux threads compteurs un temps donné (ce qui peut être risqué si l'opération prend finalement plus de temps que prévu), en utilisant `join` afin que le thread principal attendre forcément la terminaison des deux threads :

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

evenThread.join();
oddThread.join();
```

### Ressource partagée et section critique

Une section critique est une partie de code que l'on veut toujours exécuter atomiquement pour un thread, c'est-à-dire qu'on veut éviter que cette partie de code soit exécutée par plusieurs threads en même temps, pour éviter d'avoir des incohérences dans nos données.

Typiquement, quand il y a un test et une modification en fonction de ce test d'une variable partagée entre plusieurs threads.

Par exemple, j'ai une classe `Hotel` qui compte des réservations, on ne doit pas valider plus de réservations de chambre que de chambres dans l'hôtel :

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
```

Faisons ensuite exécuter ces réservations par différents threads :

```java
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

```java
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

```java
var synchronizedList = Collections.synchronizedList(new ArrayList<Integer>());
```

On dit d'un code qui gère bien la synchronisation pour assurer la cohérence des données qu'il est *thread safe*.

### Synchroniser

Parfois, on peut avoir besoin de faire s'attendre dynamiquement des threads afin de coordonner leur action en fonction de ressources partagées. Les méthodes `wait` et `notify` sont présentes sur tous les objets Java, et permettent aux threads se passer des signaux concernant ces objets. Quand un thread exécute `wait` sur un objet, il indique qu'il attend d'être notifié que cet objet est disponible pour lui, il va donc attendre jusqu'à ce qu'un autre thread appelle `notify` sur cet objet.

Par exemple, on peut modifier notre programme avec les deux threads compteurs pour qu'ils soient coordonnées, et affichent les nombres dans l'ordre :

```java
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