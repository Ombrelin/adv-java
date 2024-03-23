# Pour aller plus loin

L'écosystème Java et JVM vous intéresse ? Vous voulez aller plus loin et aborder des sujets plus avancés avec ? Cette page vous donne des pistes et des ressources en lien.

## Applications Web & APIs Web en Java avec Spring

Spring est un framework d'application qui permet de développer facilement des applications web et des APIs web en Java. C'est un des frameworks les plus courants dans l'industrie.

Pour démarrer : [Le guide de démarrage rapide de Spring](https://spring.io/quickstart)

## Kotlin, le langage du futur pour l'écosystème JVM ? 

Kotlin est un langage moderne développé pour la JVM par JetBrains. Il compile en bytecode Java et peut donc cohabiter avec du code Java au sein d'un projet, et consommer des librairies Java. Cela permet de l'adopter petit à petit dans un projet existant sans migrer tout le code d'un coup.

Par rapport à Java, Kotlin propose une syntaxe pour concise et moderne, mais aussi beaucoup de fonctionnalités intéressantes, par exemple : 

- [Les types-référence nullables](https://kotlinlang.org/docs/null-safety.html)
- Une gestion moderne de l'asynchrone et de la concurrence structurée grâce à ses [coroutines](https://kotlinlang.org/docs/async-programming.html#coroutines)
- Support natif des [fonctions comme élément de première classe](https://kotlinlang.org/docs/lambdas.html#function-types) contrairement à Java et ses interfaces fonctionnelles
- Pas d'exception "checked"
- [Surcharge d'opérateurs](https://kotlinlang.org/docs/operator-overloading.html)

Kotlin est également très versatile et peut être utilisé dans différents contextes : 

- [Développement d'applications web backend](https://kotlinlang.org/docs/server-overview.html) avec [Ktor](https://ktor.io/) ou [Spring](https://spring.io)
- [Développement d'applications natives pour Android](https://kotlinlang.org/docs/android-overview.html) : [Kotlin est le langage mis en avant par Google pour le développement sur Android](https://developer.android.com/kotlin/first)
- [Développement d'applications graphiques multi-plateformes](https://kotlinlang.org/docs/multiplatform.html) avec [Compose Multiplatform](https://www.jetbrains.com/lp/compose-multiplatform/) : pour bureau (Windows, MacOS, Linux), Mobile (Android et iOS) et navigateur web (Kotlin compile également en Javascript ou en [WASM](https://webassembly.org/))
- [Développement d'applications compilées en binaires natif](https://kotlinlang.org/docs/native-overview.html), s'exécutant en dehors de la JVM (Kotlin compile en binaire natif via [LLVM](https://llvm.org))