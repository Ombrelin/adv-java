# Cours 4 : Programmation Générique

La programmation réflexive ou méta-programmation est la capacité d'un programme à interagir avec ses propres concepts au moment de l'exécution.

## Programmation Générique

### Concept

La programmation générique permet d'utiliser des types (classes ou interfaces) comme paramètre dans la définition d'une classe, interface ou méthode.

Cela permet : 

- D'avoir une vérification plus robuste du typage à la compilation
- D'éviter à avoir à faire des casts explicites
- D'implémenter des algorithmes génériques

L'exemple le plus basique de type générique sont les collections qui prennent en paramètre le type d'objet qu'elles contiennent. Cela permet d'avoir une collection qui ne connait pas à l'avance le type qu'elle va contenir. 

En Java, les paramètre des types sont passés en utilisant des chevrons : 

```java
var strings = new ArrayList<String>();
```

Ici, on définit une liste ***de*** `String`, la classe `ArrayList` est paramétrisée par le type `String`. 

### Définir une classe générique

La syntaxe pour définir une classe avec paramètre de type est : 

```Java
class name<T1, T2, ..., Tn> { ... }
```

On peut ensuite utiliser les type qu'on prend en paramètre dans le code de la classe.

Prenons l'exemple de l'implémentation d'une classe qui représente une paire d'éléments de types différents.

```Java
public class Pair<L, R> { 
    private final L left;
    private final R right;
    
    public Pair(L left, R right){
        this.left = left;
        this.right = right;
    }
    
    public L getLeft(){
        return left;
    }
    
    public R getRight(){
        return right;
    }
}
```

On peut ensuite l'instancier avec la syntaxe des chevrons : 

```Java
final var pair = new Pair<String, Integer>("test", 42);
```

> Les types primitifs ne peuvent pas être utilisés comme paramètre de type, il faut utiliser leur équivalent en type référence (ex ici : `Integer` pour `int`)

### Définir une méthode générique

La syntaxe pour définir une méthode avec paramètre de type est : 

```Java
public <T1, T2, ..., Tn> typeRetour nomMethode(){ ... }
```

Par exemple : 

```Java
public <T> List<T> fromArrayToList(T[] a) {   
    return Arrays.stream(a).collect(Collectors.toList());
}
```

### Contraintes de paramètre de type

Il est possible de décrire des contraintes sur les types.

- Contrainte `extends` : permet de contraindre à une classe ou une de ses classes filles
- Contrainte `super` : permet de contraindre à une classe ou une de classes parentes

La contrainte `extends`, est notamment utile pour permettre un polymorphisme plus confortable notamment quand on manipule des collections. 

Par exemple avec la hiérachie de classe suivante : 

```Java
public abstract class Animal {
    public abstract void eat();
}
class Dog extends Animal {
    @Override
    public void eat() {
    }
}

class Cat extends Animal {
    @Override
    public void eat() {
    }
}
```

Si je veux faire une méthode polymorphe qui manipule des collections d'`Animal` :

```Java
public static void addAnimals(Collection<Animal> animals)
```

Avec cette méthode le code suivant : 

```Java
List<Cat> cats = new ArrayList<Cat>();
cats.add(new Cat());
addAnimals(cats);
```

Ne fonctionne pas, la troisième ligne ne compile pas.
En revanche, si la méthode utile une contrainte `extends` :

```Java
public static <T extends Animal> void addAnimals(Collection<T> animals)
```

On peut combiner plusieurs contraintes avec l'opérateur `&`.

### *Wildcards* 

La syntaxe Wildcard permet de mentionner un type dans le contexte d'une expression de paramètre de type, sans être dans une classe ou une méthod avec un paramètre de type. Cette syntaxe est `?`. Cette syntaxe supporte les contraintes `super` et `extends`. 

Cela permet, dans le cas mentionné au-dessus de simplifier la syntaxe, si l'on a pas besoin de manipuler ce type explicitement dans la méthode : 

```Java
public static void addAnimals(Collection<? extends Animal> animals)
```

## Références du cours

- [Tutoriel JavaDoc sur les génériques](https://docs.oracle.com/javase/tutorial/java/generics/index.html)
- [Excellent stackoverflow post about Generics](https://stackoverflow.com/questions/30292959/understanding-bounded-generics-in-java-what-is-the-point)