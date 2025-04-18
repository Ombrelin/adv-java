#import "@preview/polylux:0.3.1": *
#import "@preview/sourcerer:0.2.1": code
#import themes.clean: *

#show: clean-theme.with(
  logo: image("images/efrei.jpg"),
  footer: [EFREI Paris, Arsène Lapostolet & Nada Nahle],
  short-title: [EFREI LSI L3 ALSI62-CTP : Java Avancé],
  color: rgb("#EB6237")
)

#title-slide(
  title: [Java Avancé],
  subtitle: [Cours 6 : Programmation Réseau],
  authors: ([Arsène Lapostolet & Nada Nahle])
)

#new-section-slide("Introduction")

#slide(title: "Socket")[

*Socket* : flux d'entrée/sortie réseau.

- Même interface que les autres entrées/sortie (fichiers, console)
- Utilise les couches réseau TCP ou UDP pour communiquer avec d'autres machines
- Le cours couvre le cas des sockets TCP
]

#slide(title: "Socket Java")[

Modèle client-serveur.

Classes :

 - `ServerSocket` : se lie à un port sur la machine serveur
 - `Socket` : se connecte à un port sur une IP

`ServerSocket.accept` bloque jusqu'à la connexion d'un client et retourne une `Socket` ouverte vers le client à chaque connexion.

]

#slide(title: "Coté Serveur")[

Attente d'un client et ouverture des flux :

    #code(
  lang: "Java",
```java
final var serverSocket = new ServerSocket(3000);
final var socket = serverSocket.accept();

final var streamFromClient = new BufferedReader(
    new InputStreamReader(socket.getInputStream())
);

final var streamToClient = new PrintWriter(socket.getOutputStream(), true);
```)

]

#slide(title: "Coté Client")[

Connexion au serveur et ouverture des flux :

    #code(
  lang: "Java",
```java
final var clientSocket = new Socket(3000, "localhost");

final var streamFromClient = new BufferedReader(
    new InputStreamReader(clientSocket.getInputStream())
);

final var streamToClient = new PrintWriter(
    clientSocket.getOutputStream(),
    true
);
```)

]
#slide(title: "Socket et threads")[

`println` et `readLine` sont bloquants :

- Un `println` côté client bloque jusqu'au prochain `readLine` côté serveur
- Un `readLine` côté client bloque jusqu'au prochain `println` côté serveur

Et vice-versa.

_Il faut utiliser des threads !_

]

#slide(title: "Exemple : serveur de chat")[
    #code(
  lang: "Java",
```java
public class ChatServer {
  private final int port;
  private final List<PrintWriter> connectedClients;

  public ChatServer(int port) {
    this.port = port;
    this.connectedClients = new ArrayList<>();
  }




  public void start() {
      final var serverSocket = new ServerSocket(port);

      while (true) {
        final var client = serverSocket.accept();

        connectedClients.add(
          new PrintWriter(client.getOutputStream(),true)
        );

        new Thread(() -> listenForMessage(connectedClient))
                .start();
        }
  }
  private void listenForMessage(Socket client) {
    final BufferedReader messages = new BufferedReader(
        new InputStreamReader(client.getInputStream())
    );

    while (true) {
        final var message = messages.readLine();

        for (final var connectedClient : connectedClients) {
            connectedClient.println(messageFromClient);
        }
    }
}
```
    )

]

#slide(title: "Exemple : client de chat")[

    #code(
  lang: "Java",
```java
public class ChatServer {
  private final int port;
  private final String address;
  private BufferedReader messagesFromServerStream;
  private PrintWriter messagesToServerStream, output;

  public ChatClient(int port,String address,PrintWriter out){
        this.port = port;
        this.address = address;
        this.output = out;
  }

  public void connect() {
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

  private void listenForMessages(){
    while (true){
      final var message = messagesFromServerStream.readLine();
      output.println(message);
    }  
  }

  public void sendMessage(String message){
    messagesToServerStream.println(message); 
  }

}
```
    )
]
