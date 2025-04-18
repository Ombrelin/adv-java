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
  subtitle: [Cours 5 : Eléments de programmation orienté fonction],
  authors: ([Arsène Lapostolet & Nada Nahle])
)

#new-section-slide("Concepts")


#slide(title: "Définition")[

- *Fonction de première classe* : manipuler les fonction comme des variables
- *Référence de méthode* : variable / argument qui contient une méthode
- *Interface fonctionnelle* : interface Java qui type une référence de méthode
- *Lamba* : méthode anonyme déclarée en tant qu'expression

]

#slide(title: "Exemples")[

  #code(
  lang: "Java",
```java
Runnable printHelloWorld = () -> System.out.println("Hello World");

Consumer<String> printHelloName = (String name) -> System.out.println("Hello, " + name);

Function<Integer,Integer> square = (Integer number) -> number * number;

BiFunction<Integer, Integer,Integer> plus = (leftOperand, rightOperand) -> leftOperand + rightOperand;

Calculator<Integer> calculator = new Calculator<Integer>();

calculator.addOperator(
		"+",
		(leftOperand, rightOperand) -> leftOperand + rightOperand
);

BiFunction<Integer, Integer,Integer> bigDecimalPlus = Integer::add;

calculator.addOperator(
		"+",
		Integer::add
);
```
  )
]


#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#new-section-slide("Traitement fonctionnels des collections")


#slide(title: "Interface `Stream<T>`")[

  *`Stream<T>`* : abstraction d'une séquence d'éléments. On peut faire des opération fonctionnelles dessus.

  _`.stream()` permet de transformer n'importe quelle collection Java en `Stream<T>`_

]

#new-section-slide("Opérateurs de filtrage")

#slide(title: "filter")[

  Filtrer à partir d'un prédicat

    #code(
  lang: "Java",
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
  )
]


#slide(title: "limit")[

  Récupérer un certain nombre d'éléments

    #code(
  lang: "Java",
```java
List<Employee> employees = List.of(
  	new Employee("Shepard",28),
  	new Employee("Liara",106)
);

Stream<Employee> seniors = employees
		.stream()
		.limit(1);
```
  )
]

#slide(title: "skip")[

  Sauter des éléments
    #code(
  lang: "Java",
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
  )
]

#new-section-slide("Opérateurs de transformation")

#slide(title: "map")[

  Associer chaque élément à un nouvel élément

    #code(
  lang: "Java",
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
  )
]

#slide(title: "flatMap")[

  Applatir des collections

    #code(
  lang: "Java",
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
		.flatMap(team -> team.getMembers().stream()) 
// Retourne Stream<Employee> qui contient les 6 employés
```
  )
]

#new-section-slide("Opérateurs terminaux")

#slide(title: "Collecter sous formation de collection")[

  Enumère le Stream<T> sous forme d'une collection :

    - Une liste `toList()`
    - Un ensemble `toSet()`
    - Un dictionnaire `toMap()`

]

#slide(title: "findFirst")[

  Récupérer le premier élément de la série (retourne un `Optionnal<T>`).

    #code(
  lang: "Java",
```java
List<Employee> employees = List.of(
  	new Employee("Liara",106),
    new Employee("Tali",23)
);
Employee tali = employees
		.stream()
		.filter(employee -> Objects.equals(employee.getName(), "Tali"))
		.findFirst()
		.get();
```
  )
]


#slide(title: "allMatch et anyMatch")[

  Vérifie si les éléments valident un prédicats : 
  
  - `allMatch` vérifie tous les éléments valide le prédicat
  - `anyMatch` vérifie qu'au moins un élément  valide le prédicat

    #code(
  lang: "Java",
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

boolean isSomeOneOlderThan100 = employees
  	.stream()
    .allMatch(employee => employee.getAge() > 100);

// Résultat : true
```
  )
]

#slide(title: "Comptage")[

  - `count`
  - `min`
  - `max`

]


#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#new-section-slide("Autre outils fonctionnels")

#slide(title: "Pattern matching")[

Tester une expression, pour vérifier si elle a certaines caractéristiques.

    #code(
  lang: "Java",
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
)
]

#slide(title: "Record class")[

Classe qui représente des objets-valeur : 

  - Syntaxe plus concise 
  - `equals()`, `hashcode()` et `toString()` générés automatiquement
  - Immutable

    #code(
  lang: "Java",
```java
record Rectangle(double length, double width) {

 }
```
)
]

