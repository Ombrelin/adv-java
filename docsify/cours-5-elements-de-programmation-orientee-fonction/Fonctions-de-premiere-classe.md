# Fonctions de première classe (first-class functions)

## Définitions

Les fonctions de première classe sont une fonctionnalité d'un langage de programmation qui permet de manipuler des fonctions comme n'importe quel autre type de variable du langage. Les fonctions peuvent ainsi être stockées dans des références, et passées comme paramètres d'autres fonctions, on parle donc pour ces variables et paramètres qui contiennent des fonctions, de *références de méthodes* (car en Java, toutes les fonctions sont des méthodes).

Java est "purement orienté objet", donc cette fonctionnalité, issue du paradigme de programmation dit "orienté fonction", a été implémentée en introduisant la notion d'*Interfaces Fonctionnelle*.

## Interfaces Fonctionnelles

Les interfaces fonctionnelles sont des interfaces spéciales qui permettent de typer des références de méthodes en Java. Une interface fonctionnelle est une interface qui contient une seule méthode. Elle type des références de méthode à la signature équivalente à la méthode qu'elle contient.

Le langage fournit différentes interfaces fonctionnelles pour désigner les fonctions en Java. Quelques exemples :

- `Runnable` : fonction sans paramètres ni valeur de retour
- `Consumer<T>` : fonction qui accepte un paramètre de type `T` et sans valeur de retour
- `Function<T,R>` : fonction qui accepte un paramètre de type `T` et retourne une valeur de type `R`
- `Predicate<T>` : fonction qui accepte un paramètre de type `T` et retourne un booléen.

Liste exhaustive des interfaces fonctionnelles existantes à retrouver sur [la documentation de la spécification Java](https://docs.oracle.com/javase/8/docs/api/java/util/function/package-summary.html).

## Fonctions Lambda

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

## Référencer une méthode

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
