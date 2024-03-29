# Cours 4 : Element de programmation orientée fonction


## Fonction de première classe (*first-class functions*)

### Définitions

Les fonctions de première classe sont une fonctionnalité d'un langage de programmation qui permet de manipuler des fonctions comme n'importe quel autre type de variable du langage. Les fonctions peuvent ainsi être stockées dans des références, et passées comme paramètres d'autres fonctions, on parle donc pour ces variables et paramètres qui contiennent des fonctions, de *références de méthodes* (car en Java, toutes les fonctions sont des méthodes).

Java est dogmatiquement "purement orienté objet", donc cette fonctionnalité, issue du paradigme de programmation dit "orienté fonction", a été implémentée en introduisant la notion d'*Interfaces Fonctionnelle*.

### Interfaces Fonctionnelles

Les interfaces fonctionnelles sont des interfaces spéciales qui permettent de typer des références de méthodes en Java. Une interface fonctionnelle est une interface qui contient une seule méthode. Elle type des références de méthode à la signature équivalente à la méthode qu'elle contient.

Le langage fournit différentes interfaces fonctionnelles pour désigner les fonctions en Java. Quelques exemples :

- `Runnable` : fonction sans paramètres ni valeur de retour
- `Consumer<T>` : fonction qui accepte un paramètre de type `T` et sans valeur de retour
- `Function<T,R>` : fonction qui accepte un paramètre de type `T` et retourne une valeur de type `R`
- `Predicate<T>` : fonction qui accepte un paramètre de type `T` et retourne un booléen.

Liste exhaustive des interfaces fonctionnelles existantes à retrouver sur [la documentation de la spécification Java](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html).

### Fonctions Lambda

Dans les langages qui supportent les fonctions de première classe, la syntaxe de fonction lambda ou fonction anonyme, est une syntaxe qui permet de déclarer des fonctions de façon anonyme, en tant qu'expression, que ce soit pour les passer en paramètre dans une autre fonction, ou de les référencer dans une variable.

```java
// Variables
Runnable printHelloWorld = () -> System.out.println("Hello World");

Consumer<String> printHelloName = (String name) -> System.out.println("Hello, " + name);

Function<Integer,Integer> square = (Integer number) -> number * number;

BiFunction<Integer, Integer,Integer> plus = (leftOperand, rightOperand) -> leftOperand + rightOperand;

// Paramètres
Calculator<Integer> calculator = new Calculator<Integer>();
calculator.addOperator(
		"+",
		(leftOperand, rightOperand) -> leftOperand + rightOperand
);

```

### Référencer une méthode

En Java, l'opérateur `::` permet de lire une référence de méthode à partir d'une méthode nommée existante dans une classe, afin de la manipuler : passer en paramètre, stocker dans une variable, etc.

Exemple :

```java

// Variables
BiFunction<Integer, Integer,Integer> bigDecimalPlus = Integer::add;

// Paramètres
calculator.addOperator(
		"+",
		Integer::add
);


```

## Traitements fonctionnels des collections

Les fonctions d'ordre supérieur sont des fonctions sur les collections qui permette de faire des traitements de données usuels beaucoup plus simplement, en utilisant une approche orientée fonction, ainsi que la syntaxe fonctions lambdas. Les opérations qui permettent ces traitements sont les opérateurs fonctionnels.

### Interface `Stream<T>`

L'interface `Stream<T>` est une abstraction d'une séquence de valeurs, et donc typiquement de tout type de collection (tableau, liste, dictionnaire, pile, etc...). Elle fournit la possibilité d'appliquer des opérateurs fonctionnels sur la collection. On peut transformer une collection en `Stream<T>` grâce à la méthode `.stream()`.

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106)
);

List<String> seniorNames = employees
		.stream()
		.filter(employee -> employee.getAge() >= 50) // Opérateur de filtrage
		.map(Employee::getName) // Opérateur de transformation
		.toList(); // opérateur terminal
    
// Resultat : { "Liara" }
```

Les opérateurs de filtrage et de transformation sont "lazy" ; ils ne font rien tant que l'on pas appliqué un opérateur terminal qui va, lui, procéder à l'*énumération* du `Stream<T>` et *matérialiser* un résultat en mémoire.

La liste exhaustive des opérateurs peut être trouvée dans [la JavaDoc de l'interface `Stream<T>`](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html)

### Opérateurs

#### Opérateurs de filtrage

##### `filter`


![Filter](filter.png)

Filtre les éléments à partir d'un prédicat, il conserve les éléments qui valident le prédicat.

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106)
);

Stream<Employee> seniors = employees
		.stream()
		.filter(employee -> employee.getAge() >= 50);

// Resultat : [ Employee {name = "Liara", age = 106} ]
```

> Un *prédicat*, en logique, c'est un fait énoncé concernant un sujet. En programmation, la traduction de ce concept est une fonction qui prend un objet en paramètre, et retourne un booléen. 

##### `limit`

Prends seulement les n premiers éléments.

![](limit.png)

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);

Stream<Employee> firstTwoEmployees = employees
    .stream()
	.limit(2);

// Resultat : [ Employee {name = "Shepard", age = 28}, Employee {name = "Liara", age = 106} ]
```

##### `skip`

Prends seulement les éléments après en avoir sauté n.

![](skip.png)

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);


Steam<Employee> skipTwoEmployees = users
    .stream()
	.skip(2);

// Resultat : [ Employee {name = "Tali", age = 23} ]
```

#### Opérateurs de transformation

##### `map`

Faire correspondre chaque élément à autre chose en utilisant une fonction.

![](map.png)

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);

Stream<String> employeesNames = employees
  	.stream()
    .map(employee -> employee.getName())
  
// Resultat : [ "Shepard","Liara","Tali" ]
```

##### `flatMap`

Mappe chaque élément à une collection d'autre chose, puis aplatis le résultat.

![](flatmap.png)

```java
List<Team> teams = List.of(
  	new Team(
      "First Team",
      List.of(
          new Employee("Shepard", 28),
          new Employee("Liara", 106),	
          new Employee("Tali", 23)	
      };
    ),
    new Team(
      "Second Team",
      List.of(
          new Employee("Garrus", 27),
          new Employee("Kaidan", 34),	
          new Employee("Joker", 30)	
      );
    ),
);

Stream<String> employeesName = teams
		.stream()
		.flatMap(team -> team.getMembers().stream()) // Retourne Stream<Employee> qui contient les 6 employés
		.map(Employee::getName);
```

#### Opérateurs terminaux

##### Collecter sous forme de liste (`toList`)

Enumère le `Stream<T>` sous forme d'une collection :

- une liste `Collectors.toList()`
- un ensemble `Collectors.toSet()`
- une map `Collectors.toMap`

Exemple :

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106)
);

List<String> seniorNames = employees
	.stream()
	.filter(employee -> employee.getAge() >= 50)
	.map(employee -> employee.getName()) 
	.toList();
```

##### `findFirst`

Récupère le premier élément du `Stream<T>`. Retourne un `Optionnal<T>` qui sera vide si le `Stream<T>` est vide.

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);

Employee tali = employees
		.stream()
		.filter(employee -> Objects.equals(employee.getName(), "Tali"))
		.findFirst()
		.get();
```

##### `allMatch`

Permet de vérifier si tous les éléments du `Stream<T>` valident un prédicat.

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);

boolean areAllEmployeesAdults = employees
  	.stream()
    .allMatch(employee -> employee.getAge() > 18);

// Resultat : true
```

##### `anyMatch`

Permet de vérifier s'il existe au moins un élément du stream qui valide un prédicat.

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);

boolean isSomeOneOlderThan100 = employees
  	.stream()
    .anyMatch(employee => employee.getAge() > 100);

// Résultat : true
```

##### `count()`

Donne le nombre d'éléments dans le `Stream<T>`

##### `min()` et `max()`

Donne le minimum et le maximum du `Stream<T>` à partir d'un `Comparator<T>`.

## Filtrage par motif (*pattern matching*)

Le *pattern matching* consiste à tester une expression, pour vérifier si elle a certaines caractéristiques. On peut l'utiliser en Java dans les switch-expression.

### Sur une valeur discrète

```java
public State PerformOperation(String command) {
	return switch (command) {
		case "SystemTest" -> runDiagnostics();
		case "Start" -> startSystem();
		case "Stop" -> stopSystem();
		case "Reset" -> resetToReady();
		default -> throw new IllegalArgumentException("Invalid string value for command");
	};
}
```

## Classes d'enregistrement (record class)

Classe qui représente des objets-valeur :

- Syntaxe plus concise
- `equals()`, `hashcode()` et `toString()` générés automatiquement
- Immutable

```java
record Rectangle(double length, double width) {

}
```

## Référence du cours

- [Mastering Lambdas : Java Programming in a MuliCore World](https://books.google.fr/books/about/Mastering_Lambdas.html?id=Zw5oBAAAQBAJ&source=kp_book_description&redir_esc=y)
- [JavaDoc : package java.util.function](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)
- [JavaDoc : method references](https://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html)
- [JavaDoc : streams](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html)