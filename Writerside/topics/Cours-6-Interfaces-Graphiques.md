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

### Le pattern MVVM

### Threading et interfaces graphiques