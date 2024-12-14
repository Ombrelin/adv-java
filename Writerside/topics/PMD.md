# PMD

[PMD](https://pmd.github.io) est un analyseur statique de code ; un programme qui permet de vérifier de manière que notre code est écrit de façon conforme à des règles de formatage.
Cela nous permet de facilement avec un code plus uniforme et qui suite certaines bonnes pratiques de programmation.

Cela nous permettra à tous de gagner de temps en aller-retour de correction pour le projet.

## Ensemble de règle

PMD prend en paramètre deux choses :

- Un ensemble de règles que l'on veut vérifier, elles sont décrites dans le fichier `ruleset.xml` à la racine du module Gradle.
- Notre code.

On construit ce fichier `ruleset.xml` avec ce squellette :

```xml
<?xml version="1.0"?>

<ruleset name="Custom Rules"
    xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">

    <description>
        My custom rules
    </description>


    <!-- Vos règles apparaitront ici -->

</ruleset>

```

Et on peut le remplir avec les règles qui nous intéressent en regardant [la référence de toutes les règles pour le Java](https://docs.pmd-code.org/latest/pmd_rules_java.html) et en reportant leur nom. Par example :

```xml
<?xml version="1.0"?>

<ruleset name="Custom Rules"
    xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
    xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">

    <description>
        My custom rules
    </description>


  <rule ref="category/java/errorprone.xml/EmptyCatchBlock" />

</ruleset>

```

## Intégration Gradle

PMD est intégré à notre outil de build Gradle grâce à un plugin. On peut donc en configurer l'utilisation dans notre script de build Gradle :

```groovy

plugins {
    ...
      id("pmd")
}

...

pmd {
    ruleSetFiles = files("ruleset.xml")
    ruleSets = listOf()
    toolVersion = "7.5.0"
}

```

Une fois ceci fait, on peut invoquer la vérification de nos règles PMD via Gradle en invoquant la commande Gradle `check` :

```bash
./gradlew check
```

Ou via l'interface Gradle de l'IDE.

## Références du cours

- [Documentation PMD](https://docs.pmd-code.org)