# Écrire du code testable

L'un des concepts de programmation qui est le plus important pour écrire du code testable, c'est l'injection de dépendance. Cela permet aussi d'obtenir un code plus modulaire, avoir des couplages moins forts, donc plus facile à maintenir et à refactorer. On en reparlera aussi dans le contexte [du cours sur la qualité logicielle](Cours-3-Qualite-Logicielle.md)

L'injection de dépendance consiste à inverser la dépendance entre le code le plus abstrait qui va définir les règles métier de l'application, et le code technique qui fait le lien avec l'infrastructure. On veut que le concret dépende de l'abstrait.

Cela va se traduire, lors de la conception des classes et des paquets, par l'externalisation sous forme de dépendance de tout le code dont le niveau d'abstraction ne correspond pas à celui qu'on veut donner à la classe. La plupart du temps, on va également vouloir créer des interfaces pour ces dépendances, afin de minimiser la surface de contact, rendre le contrat de service le plus simple dans le but de réduire au maximum le couplage.

Prenons l'exemple simple d'un programme en ligne de commande, qui demande une suite de nombres à l'utilisateur, puis en fournit la moyenne quand l'utilisateur entre "finished".

```Java
public class AverageCalculator {

    public static void main(String[] args) throws IOException {
        BufferedReader buffer = new BufferedReader(
            new InputStreamReader(System.in)
        );
        
        String input = null;

        List<Integer> numbers = new LinkedList<>();

        while (!Objects.equals(input, "finished")) {
            input = buffer.readLine();
            try {
                numbers.add(Integer.parseInt(input));
            } catch (NumberFormatException ignored) {
            }
        }

        var sum = 0;
        for (var number : numbers) {
            sum += number;
        }

        System.out.print("The average is :" + sum / numbers.size());
    }
}
```

> Un [`BufferedReader`](https://docs.oracle.com/javase/8/docs/api/java/io/BufferedReader.html) est une classe fournie par Java permettant de lire un flux d'entrée. Ici, on l'utilise pour lire ligne par ligne le flux d'entrée [`System.in`](https://docs.oracle.com/javase/8/docs/api/java/lang/System.html#in), qui correspond à [l'entrée standard (STDIN)](https://en.wikipedia.org/wiki/Standard_streams#Standard_input_(stdin))

Cette version fonctionne, mais est très difficile à tester, mais aussi pas facile à lire et comprendre, toutes les responsabilités sont mélangée.

Créons donc une classe pour modéliser notre application :

```Java
public class AverageCalculatorApplication {
    public void run(){
        BufferedReader buffer = new BufferedReader(
            new InputStreamReader(System.in)
        );

        List<Integer> numbers = new LinkedList<>();

        while (!Objects.equals(input, "finished")) {
            input = buffer.readLine();
            try {
                numbers.add(Integer.parseInt(input));
            } catch (NumberFormatException ignored) {
            }
        }

        var sum = 0;
        for (var number : numbers) {
            sum += number;
        }

        System.out.printf("The average is : " + sum / numbers.size());
    }
}
```

La chose la plus évidente à extraire pour rendre ça plus testable, ce sont les entrées/sorties, avec une interface afin d'avoir un contract minimal et de pouvoir remplacer la dépendance facilement si besoin :

```Java
public interface IO {
    String readLine() throws IOException;
    void print(String text);
}
```

Et ajoutons la dépendance à notre classe :

```Java
public class AverageCalculatorApplication {
    private final IO io;
        
    public AverageCalculatorApplication(IO io) {
        this.io = io;
    }

    public void run() throws IOException {
        String input = null;
        List<Integer> numbers = new LinkedList<>();
        while (!Objects.equals(input, "finished")) {
            input = io.readLine();
            try {
                numbers.add(Integer.parseInt(input));
            } catch (NumberFormatException ignored) {
            }
        }

        var sum = 0;
        for (var number : numbers) {
            sum += number;
        }

        io.print(
            String.format("The average is : " + sum / numbers.size())
        );
    }
}
```

Et l'implémentation des entrées/sorties :

```Java
public class ConsoleIO implements IO {
    private final BufferedReader buffer = new BufferedReader(
        new InputStreamReader(System.in)
    );

    @Override
    public String readLine() throws IOException {
        return buffer.readLine();
    }

    @Override
    public void print(String text) {
        System.out.println(text);
    }
}
```

Ce qui nous donne une méthode "main" ultra simplifiée, qui sert simplement à injecter les dépendances :

```Java
public class Main {
    public static void main(String[] args) throws IOException {
        final var app = new AverageCalculatorApplication(new ConsoleIO());
        app.run();
    }
}
```

On peut déjà commencer à tester automatiquement en utilisant une fausse dépendances :

```Java
public class FakeIO implements IO {

    private final Stack<String> givenInput;
    private final List<String> output = new LinkedList<>();

    public List<String> getOutput(){
        return Collections.unmodifiableList(output);
    }

    public FakeIO(List<String> givenInput) {
        this.givenInput = new Stack<String>();
        for (var inputLine : givenInput) {
            this.givenInput.push(inputLine);
        }
    }

    @Override
    public String readLine() throws IOException {
        return givenInput.pop();
    }

    @Override
    public void print(String text) {
        this.output.add(text);
    }
}
```

Cette fausse dépendance d'entrée sortie nous permet de :

- Donner des lignes qui seront passées comme entrée aux appels de `readLine`
- Enregistrer les sorties de l'application passées à `print`

On peut donc écrire un test automatisé :

```Java
@Test
public void run_whenMultipleNumbers_printsCorrectOutput() throws IOException {
    // Given
    final var input = List.of("1","3", "finished");

    final var fakeIO = new FakeIO(input);
    final var app = new AverageCalculatorApplication(fakeIO);

    // When
    app.run();

    // Then
    assertEquals(1, fakeIO.getOutput().size());
    var outputLine = fakeIO.getOutput().getFirst();
    assertEquals("The average is : 2\n", outputLine);
}
```

Ensuite, on poursuit la modularisation de l'application, en extrayant la responsabilité du calcul de la moyenne. Cela nous permet de tester ce mécanisme indépendamment :

```Java
public class AverageCalculator {

    public int computeAverage(List<Integer> numbers) {
        var sum = 0;
        for (var number : numbers) {
            sum += number;
        }

        return sum / numbers.size();
    }

}
```

C'est maintenant une dépendance de notre application. Ici pas besoin d'interface, car la cohésion métier entre les deux classes, -l'application qui gère le fait de calculer une moyenne et la classe qui fait effectivement le calcul- est très forte fonctionnellement, et il s'agit d'un calcul qui est très rapide, dans ce contexte ça n'aurait pas d'intérêt ni en termes de modélisation, ni pour les tests de remplacer cette dépendance, on n'a donc pas besoin d'interface :

```Java
public class AverageCalculatorApplication {

    private final IO io;
    private final AverageCalculator averageCalculator;

    public AverageCalculatorApplication(
        IO io, 
        AverageCalculator averageCalculator
    ) {
        this.io = io;
        this.averageCalculator = averageCalculator;
    }

    public void run() throws IOException {
        String input = null;
        List<Integer> numbers = new LinkedList<>();
        while (!Objects.equals(input, "finished")) {
            input = io.readLine();
            try {
                numbers.add(Integer.parseInt(input));
            } catch (NumberFormatException ignored) {
            }
        }

        final var average = averageCalculator.computeAverage(numbers);
        io.print(String.format("The average is :" + average));
    }
}
```

Notre code est maintenant beaucoup plus simple à lire en plus d'être testable !
On doit aussi rajouter l'injection de la dépendance dans la méthode "main" :

```Java
public class Main {
    public static void main(String[] args) throws IOException {
        final var app = new AverageCalculatorApplication(
            new ConsoleIO(),
            new AverageCalculator()
        );
        app.run();
    }
}
```

Et dans le test de l'application :

```Java
@Test
public void run_whenMultipleNumbers_printsCorrectOutput() throws IOException {
    // Given
    final var input = List.of("1","3", "finished");

    final var fakeIO = new FakeIO(input);
    final var app = new AverageCalculatorApplication(
        fakeIO, 
        new AverageCalculator()
    );

    // When
    app.run();

    // Then
    assertEquals(1, fakeIO.getOutput().size());
    var outputLine = fakeIO.getOutput().getFirst();
    assertEquals("The average is : 2\n", outputLine);
}
```

On peut donc faire des tests spécifiquement pour le calcul de la moyenne :

```Java
public class AverageCalculatorTests {

    @Test
    public void computeAverage_nominalCase_returnsCorrectResult(){
        // Given
        final var numbers = List.of(0, 20);
        final var calculator = new AverageCalculator();

        // When
        final var result = calculator.computeAverage(numbers);

        // Then
        assertEquals(10, result);
    }

    @Test
    public void computeAverage_oneNumber_returnsCorrectResult(){
        // Given
        final var numbers = List.of(20);
        final var calculator = new AverageCalculator();

        // When
        final var result = calculator.computeAverage(numbers);

        // Then
        assertEquals(20, result);
    }
}
```
