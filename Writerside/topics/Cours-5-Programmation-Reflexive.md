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
public static <T1, T2, ..., Tn> typeRetour nomMéthode(){ ... }
```

## Programmation Réfléxive

### La classe `Class`

Au moment de l'exécution d'un programme Java, chaque classe est modélisée par une instance de la classe `Class`. On peut obtenir une référence à cette instance via : 

- Méthode `getClass` : `(new ArrayList()).getClass()`
- `.class` : `ArrayList.class`
- Méthode `Class.forname(String className)` : `Class.forName("java.util.ArrayList")`

Cette instance est créée au moment du chargement de la classe dans le runtime Java (premier appel de la classe).

À partir d'une référence à la classe `Class` on peut notamment : 

- Récupérer les constructeurs de la classe avec `getConstructors` et instancier la classe avec `Constructor.newInstance(Object... args)`
- Récupérer les champs de la classe avec `getFields`, on peut en modifier la valeur (même s'ils sont privés !) avec les méthodes `Field.get(Object obj)` et `Field.set(Object obj, Object value)`.
- Récupérer les méthodes de la classe avec `getMethods`, on peut les appeler avec `Method.invoke(Object obj, Object... args)`

On peut aussi accéder la visibilité de chaque de ces éléments avec les méthodes de la class `Modifier` : `isPublic`,`isPrivate`, etc.

### Notion de chargeur de classe

## Références du cours 

- [Tutoriel JavaDoc sur les génériques](https://docs.oracle.com/javase/tutorial/java/generics/index.html)