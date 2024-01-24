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
  subtitle: [Cours 3 : Qualité Logicielle],
  authors: ([Arsène Lapostolet]),
  date: [25 Janvier 2024],
)

#new-section-slide("Concepts")

#slide(title: "Polymorphisme")[

- Contrats de services (interfaces)
- Cacher les détails au code client

_ex : `List` avec `LinkedList`/`ArrayList`_

]

#slide(title: "Inversion et injection de dépendances")[
  *Injection de dépendances :* Externaliser des comportement dans des classes (dépendances), et les fournir en paramètre du constructeur.

  *Inversion de dépendance :* Abstraire les dépendance par un contrat de service (une interface)

  - Code modulaire
  - Couplages moins forts

  _-> Le code est plus facile et test, maintenir, refactorer_ 
]

#slide(title: "Conteneur d'injection de dépendance (IoC Container)")[
  Composant qui permet de d'automatiser : 
  
  - Construction des classes avec leur dépendances
  - Gestion de leur cycle de vie

  Exemple de librairies : 

  - Spring
  - Context Dependency Injection (standard JakartaEE)

]

#new-section-slide("Patrons de conception")

#slide(title: "Décorateur")[
#image("images/decorator.png", width: 60%)
]

#slide(title: "Fabrique")[

  - Création d'objet complexe
  - Découplage de création d'objet
]

#slide(title: "Etat")[
#image("images/state.png", width: 46%)
]

#new-section-slide("Ecriture du code")

#slide(title: "Nommage")[

  - Ne pas faire d'abréviations
  - Ne pas utiliser d'acronymes
  - Toujours décrire l'objectif du symbole dans son nom
  - Ne pas avoir peur d'avoir des noms de symboles longs
  - Utiliser des noms en anglais
  - Utiliser des noms prononçables
  - Ne pas utiliser de nombres magiques
]

#slide(title: "Fonctions / méthodes")[
    - Pas plus de 20 lignes, 10 lignes idéalement
    - Doit faire une seule chose
    - Séparer les Commandes et les Requêtes :
        - Requête : calculer une valeur
        - Commande : Faire une action
    - Utiliser les méthodes/fonctions et leur nom pour décrire des blocs logiques
    - Pas plus de 4 arguments pour méthode/fonction

]


#new-section-slide("Architecture")

#slide(title: "Architecture en couche")[
    #side-by-side[
  #image("images/clean-architecture.png", width: 94%)
    ][
      - Couche métier
          - Entité
          - Objet-valeur
          - Associations
          - Service
      - Couche application
      - Couche interface
      - Couche infrastructure
    ]
]