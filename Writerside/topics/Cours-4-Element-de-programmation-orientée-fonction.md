# Cours 4 : Element de programmation orientée fonction


## Fonction de première classe (*first-class functions*)

### Définitions

Les fonctions de première classe sont une fonctionnalité d'un langage de programmation qui permet de manipuler des fonctions comme n'importe quel autre type de variable du langage. Les fonction peut ainsi être stockées dans des références, et passées comme paramètres d'autres fonctions.

Java est dogmatiquement "purement orienté objet", donc cette fonctionnalités, issue de paradigme orienté fonction, a été implémentée en introduisant la notion d'*Interfaces Fonctionnelle*.

### Interfaces Fonctionnelles

Les interfaces fonctionnelles sont des interfaces spéciales qui permettent de typer des références de méthodes en Java. Une interface fonctionnelle est une interface qui contient une seule méthode. Elle type des références de méthode à la signature équivalente à la méthode qu'elle contient.

Le langage fournit différentes interfaces fonctionnelles pour désigner les fonctions en Java. Quelques exemples :

- `Runnable` : fonction sans paramètres ni valeur de retour
- `Consumer<T>` : fonction qui accepte un paramètre de type `T` et sans valeur de retour
- `Function<T,R>` : fonction qui accepte un paramètre de type `T` et retourne une valeur de type `R`
- `Predicate<T>` : fonction qui accepte un paramètre de type `T` et retourne un booléen.

Liste exhaustive des interfaces fonctionnelles existantes sur [la documentation de la sécification Java](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html).

### Fonctions Lambda

Dans les langages qui supportent les fonctions de première classe, la syntaxe de fonction lambda ou fonction anonyme, est une syntaxe qui permet de déclarer des fonctions de façon anonyme, en tant qu'expression, que ce soit pour les passer en paramètre dans une autre fonction, ou de les référencer dans une variables.

```java
// Variables
Runnable printHelloWorld = () -> System.out.println("Hello World");

Consumer<String> printHelloName = (String name) -> System.out.println("Hello, " + name);

Function<Integer,Integer> square = (Integer number) -> number * number;

// Parameters
Calculator<Integer> calculator = new Calculator<Integer>();
calculator.addOperator(
		"+",
		(leftOperand, rightOperand) -> leftOperand + rightOperand
);

```

### Référence de méthode

En Java, l'opérateur `::` permet de lire une référence de méthode, afin de la manipuler : passer en paramètre, sotcker dans une variable, etc...

Exemple :

```java

// Variables
BiFunction<Integer, Integer,Integer> bigDecimalPlus = Integer::add;

// Parameters
calculator.addOperator(
		"+",
		Integer::add
);


```

## Traitements fonctionnel des collections

Les fonctions d'ordre supérieur sont des fonctions sur les collections qui permette de faire des traitement de données usuels beaucoup plus simplement, en utilisant une approche orientée fonction, ainsi que la syntaxe fonctions lambdas. Les opérations qui permettent ces traitements sont les opérateurs fonctionnels.

### Interface `Stream<T>`

L'interface `Stream<T>` est une abstraction de toute colletion. Elle fournit la possibilité d'appliquer des opérateurs fonctionnels sur la collection. On peut transformer une collection en `Stream<T>` grâce à la méthode `.stream()`.

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

La liste exhaustive des opérateurs peut être trouvée dans  [la JavaDoc de l'interface `Stream<T>`](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html)

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
		.filter(employee -> employee.getAge() >= 18);

// Resultat : [ Employee {name = "Liara", age = 106} ]
```

##### `limit`

Prends seulement les n premiers éléments.

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

Mappe chaque élément à autre chose en utilisant une fonction.

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

Mappe chaque élément à une collection d'autre chose, puis applatis le résultat.

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
      "Second Team",ee(
      List.of(
          new Employee("Garrus", 27),
          new Employee("Kaidan", 34),	
          new Employee("Joker", 30)	
      );
    ),
);

Stream<String> employeesName = teams
		.stream()
		.flatMap(team -> team.getMembers().stream()) // Retourne Stream<Employee>
		.map(employee -> employee.getName());
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

Permet de vérifier si il existe au moins un élément du stream qui valide un prédicat.

```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106),
    new Employee("Tali",23)
);

boolean isSomeOneOlderThan100 = employees
  	.stream()
    .allMatch(employee => employee.getAge() > 100);

// Résultat : true
```

##### `count()`

Donne le nombre d'éléments dans le `Stream<T>`

##### `min()` et `max()`

Donne le minimum et le maximum du `Stream<T>` à partir d'un `Comparator<T>`.

##### `reduce`

## Filtrage par motif (*pattern matching*)

Le pattern matching consiste à tester une expression, pour vérifier si elle a certaines caractéristiques. On peut l'utiliser en Java dans les switch-expression.

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

## Référence du cours

- [JavaDoc : package java.util.function](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html)
- [JavaDoc : method references](https://docs.oracle.com/javase/tutorial/java/javaOO/methodreferences.html)
- [JavaDoc : streams](https://docs.oracle.com/javase/8/docs/api/java/util/stream/Stream.html)