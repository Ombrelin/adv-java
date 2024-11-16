# Cours 7 : Programmation Réseau

## Socket TCP

Les sockets sont les éléments du système d'exploitation qui permettent à plusieurs machines de communiquer par l'intermédiaire du réseau.

On peut lire et écrire sur une socket via des flux d'entrée/sortie, exactement comme pour les entrées/sorties console.

### Côté serveur

Pour créer une socket en écoute sur un port (ici le port 3000), on va utiliser la classe `ServerSocket` : 

```Java
final var serverSocket = new ServerSocket(3000);
```

La méthode `accept` de la `ServerSocket` va permettre d'attendre la connexion d'un client sur le port : 

```Java
final var connectedClientSocket = serverSocket.accept();
```

La méthode `accept` nous donne la socket pour communiquer spécifiquement avec le client qui s'est connecté. On peut récupérer les flux d'entrée/sortie pour communiquer avec lui via `getInputStream` pour l'entrée, et `getOutputStream`.

Pour l'entrée, c'est-à-dire le flux de données qui vient du client (envoyée au serveur par le client), on utilise un `BufferedReader` qui nous permet d'écrire simplement du texte ligne par ligne : 

```Java
final var streamFromClient = new BufferedReader(
    new InputStreamReader(
        connectedClientSocket.getInputStream()
    )
);
```

Pour la sortie, c'est-à-dire le flux de données qui sont envoyées par le serveur au client, on utilise un `PrintWriter`  qui nous permet de lire simplement du texte ligne par ligne :

```Java
final var streamToClient = new PrintWriter(socket.getOutputStream(), true);
```

> Ici le `true` dans le constructeur du `PrintWriter` permet d'activer l'auto-flush du buffer, afin de déclencher l'écriture dès qu'on fait un appel.

### Côté client

Dans notre application cliente, on peut maintenant utiliser la classe `Socket` pour se connecter : 

```Java
final var clientSocket = new Socket(3000, "localhost");
```

De la même façon que pour le serveur, on peut récupérer les flux entrée/sortie de la socket.

Pour l'entrée, c'est-à-dire le flux de données qui vient du serveur (envoyée au client par le serveur) :

```Java
final var streamFromClient = new BufferedReader(
    new InputStreamReader(clientSocket.getInputStream())
);
```

Pour la sortie, c'est-à-dire le flux de données qui sont envoyées par le client au serveur :

```Java
final var streamToClient = new PrintWriter(
    clientSocket.getOutputStream(),
    true
);
```

## Communications client-serveur

Pour communiquer sur les flux d'entrée/sortie des sockets, on fait des appels à `readLine` et `println`. Attention ! Comme l'appel à `accept` de la socket serveur, ces appels sont bloquant le temps de la communication : un `readLine` est bloquant tant qu'on a pas eu un `println` de l'autre côté et vice-versa.

Afin de gérer plusieurs clients en même temps, il faut donc recourir à de la programmation parallèle.

Voyons comment on peut faire ça en implémentant une application de chat basique

### Serveur de chat

```Java
public class ChatServer {

    private final int port;
    private final List<PrintWriter> connectedClientsOutputStreams =
     new ArrayList<>();

    public ChatServer(int port) {
        this.port = port;
    }

    public void start() throws IOException {
        final var serverSocket = new ServerSocket(port);

        System.out.println("Server is running, waiting for clients");
        while (true) {
            final var connectedClient = serverSocket.accept();
            connectedClientsOutputStreams.add(
                new PrintWriter(connectedClient.getOutputStream(), true)
            );
            
            new Thread(() -> listenForClientMessage(connectedClient))
                .start();
        }
    }
    
    ...

}
```

La logique du code est la suivante : on attend continuellement de recevoir un nouveau client via `accept`, lorsque cela arrive, on démarre un thread qui va gérer la communication avec le client, pour que le thread courant puisse continuer à être ouvert à de nouvelles connexions. On ouvre le flux de sortie sur le nouveau client pour le stocker afin qu'il soit accessible dans la méthode qui gère les intéractions client, afin de pouvoir diffuser les messages à tous.

Pour la gestion des interactions client :

```Java
    private void listenForClientMessage(Socket client) {
        System.out.println("New client is connected !");
        final BufferedReader messagesFromClientStream = new BufferedReader(
            new InputStreamReader(client.getInputStream())
        );
        
        while (true) {
            final var messageFromClient = messagesFromClientStream
                .readLine();

            for (final var connectedClientOutputStream : connectedClientsOutputStreams) {
                connectedClientOutputStream.println(messageFromClient);
            }
        }
    }
```

On ouvre le flux d'entrée du client, et on va continuellement attendre de nouveaux messages. Quand on reçoit un message du client, on va l'envoyer sur le flux de sortie de tous les clients actuellement connectés.

> Certaines gestions d'exception redondantes ont été omise pour une meilleure clarté des extraits de code

La méthode main du serveur est très simple : 

```Java
    public static void main(String[] args) throws IOException {
        new ChatServer(3000).start();
    }
```

### Client de chat

```Java
public class ChatClient {

    private final int port;
    private final String address;
    private final PrintWriter output;

    private BufferedReader messagesFromServerStream;
    private PrintWriter messagesToServerStream;

    public ChatClient(int port, String address, PrintWriter output) {
        this.port = port;
        this.address = address;
        this.output = output;
    }

    public void connect() throws IOException {
        final var socket = new Socket(address, port);
        messagesFromServerStream = new BufferedReader(
            new InputStreamReader(socket.getInputStream())
        );
        messagesToServerStream = new PrintWriter(
            socket.getOutputStream(),
            true
        );

        new Thread(this::listenForMessages).start();
    }

    ...
}
```

La méthode `connect` a une logique assez simple, se connecter au serveur via `Socket`, ouvrir les flux d'entrée/sortie, et lancer l'écoute du message sur un thread.

```Java
    private void listenForMessages(){
        while (true){
            try {
                final var message = messagesFromServerStream.readLine();
                output.println(message);
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
        }
    }

    public void sendMessage(String message){
        messagesToServerStream.println(message);
    }
```

La méthode exécutée par le thread va être à l'écoute des messages du serveur et les afficher sur le flux d'affichage. La méthode pour envoyer un message écrit ce dernier dans le flux de sortie vers le serveur.

Et enfin la méthode `main` : 

```Java
    public static void main(String[] args) throws IOException {
        final var client = new ChatClient(
            3000,
            "localhost",
            new PrintWriter(System.out, true)
        );
        
        client.connect();
        final var stdIn = new BufferedReader(new InputStreamReader(System.in));

        while(true){
            System.out.println("Entrez votre message à envoyer : ");
            final var message = stdIn.readLine();

            if(message.equals("exit")){
                return;
            }

            client.sendMessage(message);
        }
    }
```

La logique est de créer le client en lui fournissant comme flux d'affichage `System.in` puis d'attendre continuellement une entrée utilisateur pour envoyer des messages.

## Références du cours

- [Javadoc `Socket`](https://docs.oracle.com/javase/8/docs/api/java/net/Socket.html)
- [Javadoc `ServerSocket`](https://docs.oracle.com/javase/8/docs/api/java/net/ServerSocket.html)