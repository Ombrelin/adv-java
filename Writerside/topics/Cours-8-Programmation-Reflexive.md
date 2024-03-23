# Cours 8 : Programmation Réflexive

La programmation réflexive ou méta-programmation est la capacité d'un programme à interagir avec ses propres concepts au moment de l'exécution.

## La classe `Class`

Au moment de l'exécution d'un programme Java, chaque classe est modélisée par une instance de la classe `Class`. On peut obtenir une référence à cette instance via : 

- Méthode `getClass` : `(new ArrayList()).getClass()`
- `.class` : `ArrayList.class`
- Méthode `Class.forname(String className)` : `Class.forName("java.util.ArrayList")`

Cette instance est créée au moment du chargement de la classe dans le runtime Java (premier appel de la classe).

À partir d'une référence à la classe `Class` on peut notamment : 

- Récupérer les constructeurs de la classe avec `getConstructors` et instancier la classe avec `Constructor.newInstance(Object... args)`
- Récupérer les champs de la classe avec `getFields`, on peut en modifier la valeur (même s'ils sont privés !) avec les méthodes `Field.get(Object obj)` et `Field.set(Object obj, Object value)`.
- Récupérer les méthodes de la classe avec `getMethods`, on peut les appeler avec `Method.invoke(Object obj, Object... args)`

On peut aussi accéder la visibilité de chaque de ces éléments avec les méthodes de la class `Modifier` : `isPublic`,`isPrivate`, etc...

## Références du cours 

- [JavaDoc de la classe `Class`](https://docs.oracle.com/javase/8/docs/api/java/lang/Class.html)