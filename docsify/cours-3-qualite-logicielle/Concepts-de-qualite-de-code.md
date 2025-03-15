# Concepts de qualité de code

## Polymorphisme

Le polymorphisme est l'épine dorsale de la programmation orientée objet. Cela consiste à utiliser les contrats de service pour manipuler de façon transparente des classes différentes qui implémentent ces contrats de service. Autrement dit, cela permet à du code de manipuler facilement des concepts en ignorant totalement les détails de l'implémentation. Le code utilisateur dépend du contrat de service, plutôt que du code qui l'implémente.

C'est fondamentalement, car énormément de mécanisme qui permettent de mieux structurer le code, en le rendant plus facile à lire et à maintenir reposent sur le polymorphisme.

> Rappel : dans ce contexte, le terme "contrat de service" est interchangeable avec le concept d'interface en Java. C'est un contrat auquel une classe adhère pour garantir qu'elle peut fournir certains services.

Un exemple simple de polymorphismes est l'interface `List<T>` en Java, qui peut contenir une référence à une `ArrayList` ou à une `LinkedList` indistinctement, pourtant ce dont des implémentations de liste qui différent complétement. Cependant, grâce au polymorphisme apporté par l'utilisation de l'interface `List<T>`, du code utilisant une liste d'ignorer complétement sur quelle implémentation cette dernière repose.

```java
public int computeAverage(List<Integer> numbers) {
    var sum = 0;
    for (var number : numbers) {
        sum += number;
    }

    return sum / numbers.size();
}
```

Ici `numbers` pourrait contenir aussi bien une `ArrayList` qu'une `LinkedList`, cela ne change rien pour notre méthode. Cela permet beaucoup de chose :

- Quand on lit le code, on n'a même pas à se poser la question de l'implémentation de la liste, juste de savoir ce qu'une `List<T>` **peut** faire et non **comment** elle le fait. Cela rend le code plus simple à lire, car il contient moins d'information, et ce n'est pas grave, cette information n'est pas du tout utile au fonctionnement de la méthode.
- Si on rajoute un nouveau type de liste, qui implémente le contrat de service établi par l'interface `List<T>` avec une implémentation différente encore, on pourrait l'utiliser comme paramètre de cette méthode, sans la modifier.

## Inversion et injection de dépendances

L'inversion de dépendances est une technique de modularisation du code reposant sur le polymorphisme. Elle a déjà été évoquée dans la partie du cours sur les tests, mais elle est utile au délà du fait de produire du code testable. Elle aide beaucoup à diviser les problèmes en petites parties ayant chacune leurs responsabilités, et ayant entre elle un niveau de couplage adapté à leur cohésion fonctionnelle.

L'injection de dépendance consiste à fournir à une classe ses dépendances comme paramètres du constructeur. Elle permet une inversion de dépendance efficace : la classe ne se préoccupe pas de comment sont construites ses dépendances, car ce n'est pas sa responsabilité, c'est le code utilisateur de la classe qui doit s'en charger. Cela permet aussi de faciliter les tests de la classe, car on peut si besoin substituer ces dépendances injectées par des pseudo-entités dans le cadre des tests.

```java
public interface UsersRepository {
    User findByUsername(String username);
}

public class UserApplication {
  private final UsersRepository userRepository;
  
  public UserApplication(UsersRepository userRepository){
    this.userRepository = userRepository;
  }
  
  public bool login(String userName, String password){
    ...
  }
}
```

Ici, on injecte à la classe  `UserApplication` sa dépendance `UsersRepository` à qui elle délègue, on imagine, des intéractions de stockage des données. La classe `UserApplication` n'a pas à savoir comment sa dépendance `UsersRepository` stocke les données, juste de savoir quelles opérations elle supporte, ce que permet de contrat de service par interface.

> Quand on développe une application avec un niveau de qualité industrielle, on va souvent déléguer la gestion de l'injection de dépendance à ce qu'on appelle un conteneur d'inversion de dépendance (Inversion of Control Container ), qui va automatiser le fait de construire les objets auxquels on injecte ces dépendances, ainsi que gérer le cycle de vie des dépendances. En Java, on peut citer [Spring](https://spring.io/) qui est l'un des frameworks IoC les plus répendus ou encore [CDI (Context Dependency Injection)](https://jakarta.ee/specifications/cdi/), issu du standard [JakartaEE](https://jakarta.ee/).
