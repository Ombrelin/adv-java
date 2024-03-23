# Cours 7 : Programmation Graphique

## Programmation graphique et événementielle

## JavaFX

![](https://upload.wikimedia.org/wikipedia/fr/c/cc/JavaFX_Logo.png)

[JavaFX](https://openjfx.io/) est une librairie graphique pour Java un peu plus moderne que sa prédécesseuse Swing, l'usage de cette dernière est tout de même resté assez répandu.

### Ajouter JavaFX à votre projet Gradle

Pour commencer, ajouter le plugin Gradle JavaFX à la section `plugins` de script de build (`build.gradle`) de votre application : 

```Groovy
plugins {
    id 'application'
    id 'org.openjfx.javafxplugin' version '0.1.0'
}
```

Ensuite, ajoutez à votre script de build la configuration de ce plugin : 

```Groovy
javafx {
    version = "21.0.1"
    modules = [ 'javafx.controls' ]
}
```

### Première Application JavaFX

Ensuite, le point d'entrée d'une application JavaFX est une classe qui étend la classe abstraite `Application`, et en redéfinit la méthode `start` : 

```Java
public class App extends Application {
    @Override
    public void start(Stage stage) {

    }
}
```

Ensuite, dans cette méthode, nous allons décrire notre interface. Le type `Scene` permet de créer une fenêtre graphique, dans laquelle nous pouvons passer des contrôles d'interface graphique : 

```Java
public class App extends Application {
    @Override
    public void start(Stage stage) {
        Scene scene = new Scene(
            new StackPane(new Text("Hello World")),
            1280,
            720
        );
    }
}
```

- `1280` et `720` sont les dimensions en largeur et hauteur de notre fenêtre
- `StackPanel` est un contrôle d'interface graphique qui permet de positionner des éléments en ligne ou en colonne.
- `Text` est un contrôle d'interface graphique qui permet d'affiche du texte.

Ensuite, il ne nous reste plus qu'à demander l'affichage de notre fenêtre, via le `Stage` fourni par la méthode `start` :

```Java
public class App extends Application {
    @Override
    public void start(Stage stage) {
        Scene scene = new Scene(new FlowPane(new Text("Hello World")), 640, 480);
        stage.setScene(scene);
        stage.show();
    }

    public static void main(String[] args) {
        launch();
    }
}
```

Enfin, on peut instancier la classe, et lancer l'application via sa méthode `launch` dans le point d'entrée (la méthode `main`) de notre application : 

```Java
    public static void main(String[] args) {
        final var app = new App();
        applaunch();
    }
```

On obtient une fenêtre avec notre "Hello World" : 

![](jfx-hello-world.png)

### Contrôle d'application

Pour toute application graphique, on a besoin de contrôle de base pour construire son interface : des boutons, des champs d'entrée, etc

JavaFX fournit notamment les contrôles suivant : 

- `Button` : un bouton qui, quand on clique dessus, déclenche un événement
```Java
var final button = new Button("Click me !");;
button.setOnAction(event -> System.out.println("Button clicked !")); 
```
- `TextField` : un champ text qui permet de donner du texte en entrée 

### Exemple d'application : compteur

On veut créer une application simple avec un bouton et un texte, le texte affiche le nombre de fois qu'on a appuyé sur le bouton.

On commence par créer notre `Label` et notre `Button` : 

```Java
final var counterText = new Label("0");
final var increaseCounterButton = new Button("Increment counter");

final var pane = new FlowPane(Orientation.VERTICAL, counterText, increaseCounterButton);
final var scene = new Scene(pane, 800, 600);
```

![](counter.png)

On peut ensuite ajouter notre logique de comptage, en retenant notre valeur dans un champ : 

```Java
public class App extends Application {
    private Integer counter = 0;

    @Override
    public void start(Stage stage) {
        final var counterText = new Label("0");
        final var increaseCounterButton = new Button("Increment counter");

        increaseCounterButton.setOnAction(event -> {
            counter++;
            counterText.setText(counter.toString());
        });

        final var pane = new FlowPane(Orientation.VERTICAL, counterText, increaseCounterButton);
        final var scene = new Scene(pane, 800, 600);

        stage.setScene(scene);
        stage.show();
    }
}
```

![](counter.gif)

### Exemple d'application : convertisseur de texte en casse alternée

On veut développer une application qui va transformer un texte, en le même têxte, mais en casse alternée, exemple : "bonjour" devient "bOnJoUr".

On va utiliser le contrôle d'interface `TextArea`, qui est comme un `TextField`, mais en plus grand.

```Java
    public void start(Stage stage) {
        TextArea textArea = new TextArea();
        Text result = new Text();
        textArea.textProperty().addListener((observable, oldValue, newValue) -> {
            String s = convertToAlternateCase(newValue);
            result.setText(s);
        });

        Scene scene = new Scene(
                new FlowPane(
                        Orientation.VERTICAL,
                        new Text("Alternate case converter"),
                        textArea,
                        new Text("Result : "),
                        result
                ),
                640,
                480
        );
        stage.setScene(scene);
        stage.show();
    }
```

### Liaisons de données

La liaison de données (*databinding* en anglais) et un *pattern*, qui se base sur le *pattern [observer](https://refactoring.guru/design-patterns/observer)* et qui permet de lier des événements entre elles afin de propager les données en cascade de l'une à l'autre, pour simplifier et standardiser la gestion d'événements.

JavaFX offre des propriétés réactives afin de faire de la liaison de donnée. Ces propriétés réactives enveloppent un type de base dans une implémentation du *pattern observer*, par exemple le type `StringProperty` nous permet d'avoir une `String` réactive, à laquelle on va pouvoir attacher des événements, mais surtout lier des données.

Les propriétés réactives de JavaFX ont deux méthodes particulièrement intéressantes : 

- `addListener` : permet de gérer les changements de valeur de la propriété
- `bind` : permet de lier la valeur de la propriété à celle d'une autre (éventuellement en utilisant un convertisseur, en utilisant la classe `Bindings`)
- `bindBidirectional` : permet de lier la valeur de la propriété à cette d'une autre et réciproquement

Ainsi, en utilisant la liaison de donnée, on peut refactor le convertisseur de texte en casse alternée de la façon suivante : 

```Java
    public void start(Stage stage) {
        TextArea textArea = new TextArea();
        Text result = new Text();
        result
                .textProperty()
                .bind(
                        Bindings.createStringBinding(
                                () -> convertToAlternateCase(textArea.textProperty().get()),
                                textArea.textProperty()
                        )
                );

        Scene scene = new Scene(
                new FlowPane(
                        Orientation.VERTICAL,
                        new Text("Alternate case converter"),
                        textArea,
                        new Text("Result : "),
                        result
                ),
                640,
                480
        );
        stage.setScene(scene);
        stage.show();
    }
```

### Le pattern MVVM

Le *pattern MVVM* signifie : 

- *Model* : votre logique métier
- *View* :  votre interface graphique
- *ViewModel* : la logique de l'interface graphique

Le but du *pattern* est de séparer ces trois aspects, notamment en abstrayant la logique de l'interface graphique de la déclaration de cette dernière, afin de pouvoir plus facilement la tester de façon unitaire.

Prenons l'exemple d'une page de login basique avec deux champs, pour le nom d'utilisateur et le mot de passe, ainsi qu'un bouton pour valider. Je vais avoir différentes classes pour les trois couches du *pattern* : 

Les classes de la couche de logique métier (*Model*)

```Java
public record User(String username, String userId) {
}

public interface UserService {
    User authenticate(String username, String password);
}

// L'implémentation de UserService, DefaultUserService

```

Le *ViewModel*, qui est ducoup l'abstraction de mon interface graphique : les données qu'elle contient et la logique d'interaction, et utilise des propriétés réactives pour pouvoir se lier aux contrôles de l'interface graphique : 

```Java
public class LoginViewModel {

    private final StringProperty username;
    private final StringProperty password;
    private final StringProperty loggedInUser;
    private final UserService userService;

    public LoginViewModel(UserService userService) {
        this.userService = userService;
        username = new SimpleStringProperty();
        password = new SimpleStringProperty();
        loggedInUser = new SimpleStringProperty();
    }

    public void handleLoginClick(){
        final var user = userService.authenticate(this.username.getValue(), this.password.getValue());
        loggedInUser.setValue(user.username());
    }
    
    ublic StringProperty usernameProperty() {
        return username;
    }
    
    public StringProperty passwordProperty() {
        return password;
    }
    
    public StringProperty loggedInUserProperty() {
        return loggedInUser;
    }
}
```

La classe d'interface graphique va ensuite lier le *ViewModel* à une *View* : 

```Java
public class LoginView extends FlowPane {

    public LoginView(LoginViewModel loginViewModel){
        this.setOrientation(Orientation.VERTICAL);

        final var usernameField = new TextField();
        usernameField.textProperty().bindBidirectional(loginViewModel.usernameProperty());

        final var passwordField = new PasswordField();
        passwordField.textProperty().bindBidirectional(loginViewModel.passwordProperty());

        final var loggedInUser = new Text();
        loggedInUser.textProperty().bindBidirectional(loginViewModel.loggedInUserProperty());


        final var submitButton = new Button("Login");
        submitButton.setOnAction((event) -> loginViewModel.handleLoginClick());

        this.getChildren().add(usernameField);
        this.getChildren().add(passwordField);
        this.getChildren().add(submitButton);
        this.getChildren().add(loggedInUser);
    }

}
```

Enfin, on peut lier tout cela fans la classe `Application` : 

```Java
    public void start(Stage stage) {
        Scene scene = new Scene(
                new LoginView(new LoginViewModel(new DefaultUserService()))
        );
        stage.setScene(scene);
        stage.show();
    }
```

Ainsi, on a bien une séparation des responsabilités dans notre application, le *ViewModel* peut être testé de façon unitaire, pour tester la logique de l'interface, sans pour autant avoir besoin de mettre en place des tests sur l'interface graphique elle-même, qui sont en général beaucoup plus complexe. 

### Threading et interfaces graphiques

Dans une application graphique, on peut avoir besoin de faire des appels réseau, ce qui peut prendre du temps. Pour éviter de bloquer l'interface graphique, il ne faut pas faire ces appels sur le thread qui la gère, le thread UI.

L'interface graphique en JavaFX n'est pas *thread safe* : il ne faut donc jamais la manipuler depuis un autre thread que le thread UI.

Il faut donc utiliser la programmation asynchrone afin d'exécuter toute opération bloquante dans un thread en arrière-plan, puis utiliser le résultat sur le thread UI.

Reprenons notre exemple précédent, en implémentant `UserService` comme un appel à une API ReST (on utilise la librairie JAX-RS client pour gérer l'appel). Je me suis aussi créé une fausse API locale en utilisant [Mockoon](https://mockoon.com/)  . On modifie notre interface de service pour avoir un appel asynchrone grâce à `CompletableFuture` : 

```Java
public interface UserService {

    CompletableFuture<User> authenticate(String username, String password);
}

public record LoginRequest(String username, String password) {
}

public class RestUserService implements UserService {

    private final Client client = ClientBuilder.newClient();
    
    @Override
    public CompletableFuture<User> authenticate(String username, String password) {
        return CompletableFuture.supplyAsync(() -> client
                .target("http://localhost:3000")
                .path("users/login")
                .request(MediaType.APPLICATION_JSON)
                .post(
                        Entity.entity(new LoginRequest(username, password), MediaType.APPLICATION_JSON),
                        User.class
                ));
    }
}
```

On adapte ensuite notre *ViewModel* pour qu'il gère l'asynchrone correctement : 

```Java
    public void handleLoginClick() {
        userService
                .authenticate(this.username.getValue(), this.password.getValue())
                .thenAccept(result -> {
                    loggedInUser.setValue(result.username());
                });
    }
```

Rappel sur l'asynchrone : 

- `supplyAsync` exécute le code sur une *thread pool* donc de façon asynchrone, en arrière-plan
- `thenAccept` exécute une continuation sur le thread courant (ici le thread UI)

## Références du cours

- [Documentation JavaFX](https://openjfx.io/openjfx-docs/)
- [Site communautaire FXDocs](https://fxdocs.github.io/docs/html5/)