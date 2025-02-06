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
  subtitle: [Cours 3 : Qualité Logicielle],
  authors: ([Arsène Lapostolet & Nada Nahle])
)


#new-section-slide("Code générique")


#slide(title: "Concept")[

Prendre des types en paramètre.

- Avoir une vérification plus robuste du typage à la compilation
- Eviter à avoir à faire des casts explicites
- Implémenter des algorithmes génériques


    #code(
  lang: "Java",
```java
var strings = new ArrayList<String>();
```
)

 Liste de `String`, la classe `ArrayList` est paramétrisée par le type `String`

]

#slide(title: "Classe Générique")[
    #code(
  lang: "Java",
```java
public class Pair<L, R> {
    private final L left;
    private final R right;

    public Pair(L left, R right){
        this.left = left;
        this.right = right;
    }

    public L getLeft(){ return left;}
    public R getRight(){ return right;}
}
```
)

    #code(
  lang: "Java",
```java
final var pair = new Pair<String, Integer>("test", 42);
```
)

_Les types primitifs ne peuvent pas être utilisés comme paramètre de type, il faut utiliser leur équivalent en type référence (ex ici : Integer pour int)_

]

#slide(title: "Méthode générique")[
    #code(
  lang: "Java",
```java
public <T> List<T> fromArrayToList(T[] array) {
    return Arrays.stream(array).collect(Collectors.toList());
}
```
)

]


#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#new-section-slide("Contraintes de paramètres de types")

#slide(title: "Contraintes de paramètre de type")[
    #code(
  lang: "Java",
```java
public abstract class Animal {

    public abstract void eat();
}

class Dog extends Animal {
    public void eat() { }
}

class Cat extends Animal {
    public void eat() { }
}
```
)
]

#slide(title: "Contraintes de paramètre de type")[

Méthode polymorphe : 

    #code(
  lang: "Java",
```java
public static void addAnimals(Collection<Animal> animals)
```
)

❌ Ne compile pas :

    #code(
  lang: "Java",
```java
List<Cat> cats = new ArrayList<Cat>();
cats.add(new Cat());
addAnimals(cats);
```
)

]

#slide(title: "Contraintes de paramètre de type")[

En changeant la méthode avec une contrainte :

    #code(
  lang: "Java",
```java
public static <T extends Animal> void addAnimals(Collection<T> animals)
```
)
]

#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]
