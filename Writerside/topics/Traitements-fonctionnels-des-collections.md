# Traitements fonctionnels des collections


Les fonctions d'ordre supérieur sont des fonctions sur les collections qui permette de faire des traitements de données usuels beaucoup plus simplement, en utilisant une approche orientée fonction, ainsi que la syntaxe fonctions lambdas. Les opérations qui permettent ces traitements sont les opérateurs fonctionnels.

## Interface `Stream<T>`

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

## Opérateurs

### Opérateurs de filtrage

#### `filter`


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

#### `limit`

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

#### `skip`

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

### Opérateurs de transformation

#### `map`

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

#### `flatMap`

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

### Opérateurs terminaux

#### Collecter sous forme de liste (`toList`)

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

#### `findFirst`

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

#### `allMatch`

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

#### `anyMatch`

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

#### `count()`

Donne le nombre d'éléments dans le `Stream<T>`

#### `min()` et `max()`

Donne le minimum et le maximum du `Stream<T>` à partir d'un `Comparator<T>`.