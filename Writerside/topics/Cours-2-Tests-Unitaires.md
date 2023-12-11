# Cours 2 : Tests Unitaires



## Les tests automatiques

Les tests automatiques ou le code auto-testant ([self-testing code](https://martinfowler.com/bliki/SelfTestingCode.html)) consiste à écrire du code pour vérifier que le code d'une application fonctionne comme prévu.

Ainsi, vous pouvez, en une seule commande, exécuter un ensemble de test, qui vous dit si votre application contient ou non des bugs majeurs. Cela permet de réduire radicalement le nombre de bugs présent dans le code livré en production.

Mais surtout, on peut développer et ajouter de nouvelles fonctionnalités, ou refactorer du code sans avoir peur d'introduire des régressions majeures dans le code. Il devient donc beaucoup plus facile d'itérer sur du code pour l'enrichir et enn améliorer la qualité. 

Les tests automatiques permettent donc, de manière générale, d'augmenter la qualité et la fiabilité des logiciels pour un investissement en temps raisonnable.

## Les tests unitaires

Les tests unitaires sont les tests automatiques comportant le plus fin niveau de granularité, ils sont très proches des détails d'implémentation. Un test unitaire va tester une *Unité* de code spécifique. Une unité peut être, une méthode, une classe, ou un petit groupe de classe ayant un fort lien logique. 

L'objectif des tests unitaire est donc de vérifier de façon précise le comportement du code dans les différent cas d'usage possible.

Cependant, les tests ne peuvent pas être exhaustifs. Ils aident à trouver les bugs, mais ne permettent
pas d’affirmer qu’il n’y a pas de bugs.

Un test unitaire se découpe en trois étapes : 

- Arrangement : mettre en place les conditions nécessaires à l'exécution du test
- Action : exécuter le code que l'on veut tester
- Affirmation : vérifier que le résultat est bien le bon

En suivant cette logique, les cas de test unitaire s'expriment sous une phrase telle que : 

*Etant donné **\<arrangement\>**, quand **\<action\>**, alors **\<affirmation\>***

Example :

Pour tester une méthode `countWords(String input)`, dont l'objectif est de compter le nombre de mots dans une chaine, un cas de test classique sera : 

***Etant donné** l'input "bonjour le monde" **quand** j'appelle `countWords`, **alors** sa valeur de retour devrait être 3*.

### Écrire des tests unitaires avec `junit-jupiter`

JUnit-Jupiter (ou JUnit 5) est la dernière version du framework de tests JUnit, le framework de tests unitaires de reference pour Java.

#### Classes de test

Avec JUnit, on structure les tests sous forme de suite en utilisant des classes. Chaque classe de test est une suite de tests spécifique à une *Unité*. L'unité étant la plus petite entité de code ayant un sens à être testée, étant donné un contexte. Le plus souvent, c'est une classe, mais cela peut aussi être un petit groupe de classe fortement liées logiquement. Par convention on appelle la classe de test avec le nom de la classe qu'elle teste, suivi de "Tests". 

Par exemple, j'ai une classe `App`, ma classe de test pour cette classe sera `AppTest`. Aussi, la classe de test se trouve dans le même paquet que la classe qu'elle teste, mais du côté de l'arboresence de fichiers sous le dossier `test` de votre projet Java.

Par exemple, voici l'arborescence du dossier source de votre projet Java, avec une classe et sa classe de test, à leur place dans l'arborescence : 

```
└── app
    ├── build.gradle 
    └── src
        ├── main
        │   └── java 
        │       └── demo
        │           └── App.java
        └── test
            └── java 
                └── demo
                    └── AppTest.java
```

#### Méthodes de test

Dans les classes de test, on a des méthodes de test. Chaque méthode correspond à un cas de test. Chaque méthode de test est anotée `@Test`. On peut avoir d'autre méthode utilitaires, qui ne sont pas des cas de test, et ne sont donc pas annotées.

Par exemple, dans la classe `App`, il existe une méthode `countWords` qu'il faut tester. Je peux donc créer le cas de test suivant dans `AppTests` : 

```Java
@Test
void wordCount_givenMultipleWords_thenReturnsRightCount(){

}
```

> En anglais :
> - *Given* signifie "étant donné"
> - *When* signifie "quand"
> - *Then* signifie "alors"

La méthode est nommée selon une convention qui reflète la phrase "EtantDonnée-Quand-Alors", ainsi le cas de test se lit comme une spécification.
Nous pouvons maintenant écrire notre test, en délimitant bien les trois étapes : 

```Java
@Test
void wordCount_whenMultipleWords_returnsRightCount(){
    // Given
    var input = "bonjour le monde";

    // When
    var result = App.countWords(input);

    // Then
    assertEquals(3, result);
}
```

`assertEquals` est une méthode d'assertion (ou vérification), qui permet de faire des vérifications sur le résultat, qui feront échouer le test si jamais la vérification échoue.

Vous pouvez exécuter le test en utilisant le petit bouton "Play" dans la marge de l'éditeur.

### Etablir des cas de test

### Les pseudo-entités

### La couverture de test

## Le développement dirigé par les tests

Références du cours : 

- [Le Bliki de Martin Fowler](https://martinfowler.com/bliki/)
- [*TDD by example* de Kent Beck](https://books.google.fr/books/about/Test_Driven_Development.html?id=zNnPEAAAQBAJ)