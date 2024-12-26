#import "@preview/polylux:0.3.1": *
#import "@preview/sourcerer:0.2.1": code
#import themes.clean: *

#show: clean-theme.with(
  logo: image("images/efrei.jpg"),
  footer: [Arsène Lapostolet, EFREI Paris],
  short-title: [EFREI LSI L3 ALSI62-CTP : Java Avancé],
  color: rgb("#EB6237")
)

#title-slide(
  title: [Java Avancé],
  subtitle: [Cours 1 : Outillage],
  authors: ([Arsène Lapostolet]),
  date: [19 Janvier 2024],
)

#slide(title: [Les outils du module])[
  - Plateforme de développement : Machine Virtuelle Java (JVM)
  - Langage de programmation : Java 21
  - Environment de développement intégré : IntelliJ IDEA Community
  - Système de Gestion de Version : Git et GitLab
  - Système de build : Gradle
]

/*
#new-section-slide("Git")

#slide(title: [Qu'est ce que Git ?])[
  Système de Gestion de Version : 
  - Versionner le code : suivre précisement les changements
  - Naviguer entre les versions
  - Ne pas perdre de changements
  - Revenir en arrière
  - Coopération à plusieurs sur le même code
]

#slide(title: [Concepts importants])[
  - *Commit :* version du code sauvegardée à un instant T.
  - *Branche :* historiques de commits qui évoluent en parallèle

  Créer un dépôt local :

#code(
  lang: "Bash",
  ```bash
  mkdir dossierPourMonDepot
  cd dossierPourMonDepot
  git init
  ```
)
]

#slide(title: [Base d'un workflow Git])[

- Créer un commits
  1. `git add .` : ajouter tous les changements au suivi git
  2. `git commit -m "message de commit"` : crée un commit avec les changements trackés
- Créer une branche : 
  1. `git branch nomDeLaBranche` : créer la branche
  2. `git checkout nomDeLaBranche` : se positionner sur la branche
]

#slide(title: [Fusion])[
  Pour appliquer les changement présents sur une branche à une autre : 

#code(
  lang: "Bash",
  ```bash
git checkout brancheCible
git merge brancheAFusionner
  ```
)

On appliquer les changement des la branche `brancheAFusionner` sur la branche `brancheCible`.

Attention aux conflits !
]

#slide(title: [Dépôt distant])[

#code(
  lang: "Bash",
  ```bash
git remote add nomLocalDuDepotDistant urlDuDepotDistant
  ```
)
1. Sauvegarder son travail en lieu sur
2. Coopérer avec d'autres personnes

Intéraction : 

- `git push nomDelaBranche` : pousser une branche locale vers le dépôt
- `git pull nomDelaBranche` : récupérer une branche distante dans son dépôt local
]

#slide(title: [Récap des espaces])[
  #figure(image("images/espaces-git.png", width: 83%))
]

#slide(title: [Récap du workflow])[

1. Se positionner sur la branche principale : `git checkout master`
2. Mettre à jour la branche principale : `git pull origin master`
3. Créer une nouvelle branche à partir de la branche principale : `git branch maFeature`

4. Se positionner sur la nouvelle branche : `git checkout maFeature`

5. Faire des changements dans le code

6. Ajouter les changements à git : `git add .`

7. Créer un nouveau commit avec les changements : `git commit -m "message de commit"`

8. Pousser les changements : `git push origin maFeature`

9. Retourner sur master : `git checkout master`

10. Fusionner la branche de feature : `git merge maFeature`
]


#focus-slide(background:  rgb("#EB6237"))[
  Des questions ? 
]
*/



#new-section-slide("Jetbrains IntelliJ IDEA")

#slide(title: [Qu'est ce que IntelliJ ?])[

- Environment de développement intégré pour Java et langages JVM
- Standard depuis 15 ans
- Moderne
- Version community gratuite et open source
- Version ultimate payante mais gratuite pour étudiants

➡️ La version community suffit parfaitement pour le module
]

#new-section-slide("GitLab")

#slide(title: [Qu'est ce que GitLab ?])[

- Serveur git
- Open source
- Intègre un d'intégration continue
- Revue de code
- Très utilisé dans l'industrie
- Projets privés gratuits sur gitlab.com
]

#new-section-slide("Gradle")

#slide(title: [Qu'est ce que Gradle ?])[

- Outil de build
  - Structuer le projet
  - Décrire comment le compiler, packager, exécuter, tester 
]



#slide(title: [Structure d'un projet Gradle])[

#code(
  lang: "Bash",
  ```bash
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
)
]

#slide(title: [`settings.gradle`])[

#code(
  lang: "Groovy",
  ```Groovy
rootProject.name = 'mon-projet'
include('app')
  ```
)
]

#slide(title: [`app/build.gradle`])[

#code(
  lang: "Groovy",
  ```Groovy
plugins {
    id 'application'
}

repositories {
    mavenCentral()
}

application {
    mainClass = 'fr.arsenelapostolet.App'
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


tasks.named('test') {
    useJUnitPlatform()
}
  ```
)
]

#slide(title: [Commandes de base])[
    - Pour exécuter l'application : `./gradlew run`
    - Pour exécuter les tests : `./gradlew test`

    Sur windows : `./gradlew` est remplacé par `./gradlew.bat` 
]


#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#new-section-slide("PMD")

#slide(title: [Qu'est ce que PMD ?])[

- Analyseur statique de code
- Automatise une partie de la revue
- Avoir un code consistant 
]

#slide(title: [Comment ça marche ?])[

➡️ Un fichier `ruleset.xml`

#code(
  lang: "xml",
  ```xml
<?xml version="1.0" 
  xmlns="http://pmd.sourceforge.net/ruleset/2.0.0"
  xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
  xsi:schemaLocation="http://pmd.sourceforge.net/ruleset/2.0.0 https://pmd.sourceforge.io/ruleset_2_0_0.xsd">

  <ruleset name="Custom Rules">
  <description>My custom PMD rules  </description>
  <rule ref="category/java/errorprone.xml/EmptyCatchBlock" />
</ruleset>
  ```
)
]

#slide(title: [Intégration Gradle])[

➡️ Un fichier `ruleset.xml`

#code(
  lang: "Groovy",
  ```Groovy
plugins {
    ...
      id("pmd")
}

pmd {
    ruleSetFiles = files("ruleset.xml")
    ruleSets = listOf()
    toolVersion = "7.5.0"
}
  ```
)
]

#slide(title: [Tâche Gradle])[

➡️ Un fichier `ruleset.xml`

#code(
  lang: "bash",
  ```bash
./gradlew check
  ```
)
]

#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]