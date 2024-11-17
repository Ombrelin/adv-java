# Gradle

## Qu'est-ce que Gradle ?

Gradle est un outil de build (build tool), il permet de structurer notre projet, de définir comment un projet doit être compilé, packagé, exécuté, et testé.

Gradle est, avec Maven, l'un des outils de build de l'écosystème Java les plus utilisés, il a l'avantage d'être plus moderne que Maven. Il est très (parfois trop) puissant, mais il permet de gagner beaucoup de temps.

## Installer gradle

> Avoir une installation gradle locale n'est pas requise pour le travail sur le projet (une distribution gradle est packagée avec le code source du projet). Ces infos sont fournies à titre de référence si vous souhaitez, utiliser gradle par vous-même ou au travail.

<tabs>
<tab title="Windows">

1. Télécharger [la dernière distribution Gradle](https://gradle.org/releases)
2. Extraire l'archive à l'endroit où vous souhaitez l'installer (ex : C:/tools/gradle)
3. Configurer l'environment : ajoutez une variable d'environment système `GRADLE_HOME` à votre `PATH`, avec comme valeur le chemin du répertoire où vous avez extrait l'archive

</tab>
<tab title="MacOS (Homebrew)">

```Bash
brew install gradle
```

</tab>
<tab title="Linux">

1. Télécharger [la dernière distribution Gradle](https://gradle.org/releases)
2. Extraire l'archive à l'endroit où vous souhaitez l'installer (ex : /opt/gradle)
3. Configurer l'environment : ajoutez une variable `GRADLE_HOME` à votre `PATH`, avec comme valeur le chemin du répertoire où vous avez extrait l'archive

</tab>
</tabs>

Pour vérifier que Gradle fonctionne correctement :

```Bash
gradle -v
```

Le résultat devrait être :

```Bash
------------------------------------------------------------
Gradle 8.5
------------------------------------------------------------

Build time:   2023-03-03 16:41:37 UTC
Revision:     7d6581558e226a580d91d399f7dfb9e3095c2b1d

Kotlin:       1.8.10
Groovy:       3.0.13
Ant:          Apache Ant(TM) version 1.10.11 compiled on July 10 2021
JVM:          17.0.6 (Homebrew 17.0.6+0)
OS:           Mac OS X 13.2.1 aarch64
```

## Création d'un projet Java avec Gradle

Commencer par créer un dossier pour le projet, puis se positionner dans ce dossier :

```Bash
mkdir mon-projet
cd mon-projet
```

Ensuite, initialiser le projet avec :

```Bash
gradle init
```

Suivre le script d'installation avec les options suivantes :

1. Type de projet : `application`
2. Langage : `Java`
3. Sous-projets : `no`
4. Langage de script de build : `Groovy`
5. Framework de tests : `JUnit Jupiter`
6. Nom du projet : au choix
7. Nom du paquet : `fr.<votre prenom suivi de votre non de famille, en miniscule, sans accent, tout collé>`
8. Version de Java cible : 21
9. Nouvelles APIs : `no`

### Structure du projet Gradle

```
├── gradle 
│   ├── libs.versions.toml 
│   └── wrapper
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── gradlew 
├── gradlew.bat 
├── settings.gradle 
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

- Le dossier `gradle`, les scripts `gradlew` et `gradlew.bat` constituent le "wrapper" gradle. Il s'agit d'une version portable de votre application qui vit dans votre répertoire projet. Ainsi, vous contrôlez précisément la version de gradle utilisée, et les personnes qui vont télécharger votre projet n'auront pas besoin d'installer Gradle pour le construire.
- Le fichier `settings.gradle` est le fichier de méta-données du projet pour Gradle.
- Le dossier `app` est le module qui correspond à l'application. Un projet peut éventuellement contenir plusieurs modules.
    - Le fichier `app/build.gradle`, est le script de build de votre module. Il contient les instructions Gradle pour le compiler, exécuter et packager.
    - Le fichier `src` contient le code source de votre module ; le code de production et les tests.

Décortiquons un peu le contenu des fichiers spécifiques à Gradle.

#### `settings.gradle`

```Groovy
plugins {
    id 'org.gradle.toolchains.foojay-resolver-convention' version '0.4.0'
}

rootProject.name = 'mon-projet'
include('app')
```

Le fichier de méta-données du projet contient un ajout de plugin qui permet d'installer automatiquement un JDK en cas d'absence. Ce n'est pas requis dans notre cas (et dans la plupart des cas). C'est un élément rajouté par le template du script d'initialisation, et peut être supprimé sans soucis.

Les deux autres déclarations sont :

- `rootProject.name = 'mon-projet'` : déclaration du nom du projet
- `include('app')` : le projet contient un module, dans le dossier `app`. Gradle s'attend à trouver dans ce dossier un script de build pour le module nommé `build.gradle`

#### `app/build.gradle`

```Groovy
plugins {
    id 'application'
}

repositories {
    mavenCentral()
}

dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
    implementation 'com.google.guava:guava:31.1-jre'
}

java {
    toolchain {
        languageVersion = JavaLanguageVersion.of(21)
    }
}

application {
    mainClass = 'fr.arsenelapostolet.App'
}

tasks.named('test') {
    useJUnitPlatform()
}
```

- `plugins` : l'ajout du projet `application` permet de configurer le module comme une application console, c'est-à-dire un programme qui a un point d'entrée (une méthode main), exécutable en ligne de commande, par opposition par exemple à un module de type `library`, qui n'aurait pas de point d'entrée, et qui aurait vocation à être importée par un autre module qui en utiliserait les classes.
- `repositories` : avec `mavenCentral()` on désigne le dépôt depuis lequel les dépendances déclarées seront téléchargées comme MavenCentral. Ce dernier est le dépôt de paquets Java standard (un peu comme NPM / nuget / cargo, etc).
- `dependencies` : ici, on déclare les dépendances du projet. Plus de détail là-dessus dans la partie suivante.
- `java` : permet de déclarer la version de Java utilisée par le module.
- `application` : permet de déclarer la classe principale de l'application console, qui sert de point d'entrée pour l'exécution. C'est la classe qui contient la méthode `main`
- `tasks.named('test')` : permet de déclarer l'utilisation de JUnit pour les tests.

### Commandes de base

Le script wrapper `gradlew.bat` est à utiliser sous Windows, le script wrapper `gradlew`, est à utiliser sous MacOS et Linux.

Commandes :

- Pour exécuter l'application : `./gradlew run`
- Pour exécuter les tests : `./gradlew test`

## Gérer les dépendances avec Gradle

La plupart des projets Java ont besoin de dépendances, pour éviter de toujours réinventer la roue. Les dépendances sont gérées dans un script de build Gradle via :

1. La déclaration du dépôt de paquet. C'est toujours MavenCentral pour les librairies publiques. Mais des entreprises peuvent avoir des dépôts privés pour leurs propres paquets.

```Groovy
repositories {
    mavenCentral()
}
```

2. La déclaration des dépendances :

```Groovy
dependencies {
    testImplementation 'org.junit.jupiter:junit-jupiter:5.9.2'
    testRuntimeOnly 'org.junit.platform:junit-platform-launcher'
    implementation 'com.google.guava:guava:31.1-jre'
}
```

La déclaration de dépendance vers un paquet se divise en deux parties.

### Scope (portée) de la dépendance

La portée de la dépendance définit à quel moment du build la dépendance intervient :



- `compileOnly` : pour les dépendances qui sont utilisées seulement pour compiler le code de production, mais n'ont pas besoin d'être présent au moment de l'exécution
- `implementation` : pour les dépendances utilisées à la compilation et à l'exécution
- `runtimeOnly` : pour les dépendances utilisées uniquement à l'exécution
- `testCompileOnly` : équivalent de `compileOnly` pour les tests
- `testImplementation` : équivalent de `runtimeOnly` pour les tests


### Identifiant du paquet

L'identifiant du paquet (ex : `org.junit.jupiter:junit-jupiter:5.9.2`) désigne le paquet sur dépôt. Il se divise en trois parties, séparées par des `:` :

- L'identifiant du groupe, en gros la personne/entité autrice du paquet : `org.junit.platform`
- L'identifiant du paquet : `junit-jupiter`
- Le numéro de version : `5.9.2`

## Intégration entre IntelliJ et Gradle

Gradle étant un outil très important pour développer en Java, IntelliJ propose une intégration de l'outil.

### Intégration des scripts de build

Les scripts de build sont parsés et utilisés par IntelliJ pour rendre votre projet Gradle directement utilisable lorsque vous l'ouvrez dans l'IDE, notamment en téléchargeant et indexant les dépendances, et en adaptant sa configuration avec ce qui est déclaré dans les scripts.

Ainsi, à chaque fois que vous modifiez un script de build, l'IDE vous propose comme action contextuelle de re-parser votre script :

![](gradle-import.jpg)

Appuyez sur ce bouton à chaque fois que vous avez terminé vos changements de script de build afin qu'ils soient pris en compte par l'IDE.

### Intégration des commandes

Il est également possible d'exécuter des commandes Gradle directement depuis l'interface graphique de l'IDE, via l'outil Gradle qui est général en haut à droite :

![](ij-gradle-tasks.jpg)

Vous avez dans cette interface la liste des commandes disponibles dans chaque module, il suffit de double cliquer sur une commande pour l'exécuter dans l'interface graphique de l'IDE et avoir une mise en forme du résultat, notamment par exemple pour les tests :

![](ij-gradle-tests.jpg)

## Références du cours

- [Documentation Gradle](https://docs.gradle.org/current/samples/sample_building_java_applications.html)