#import "@preview/polylux:0.3.1": *

#import themes.clean: *

#show: clean-theme.with(
  logo: image("images/efrei.jpg"),
  footer: [Arsène Lapostolet, EFREI Paris],
  short-title: [EFREI LSI L3 ALSI62-CTP : Java Avancé],
  color: rgb("#EB6237")
)

#title-slide(
  title: [Java Avancé],
  subtitle: [Cours 0 : Présentation],
  authors: ([Arsène Lapostolet]),
  date: [10 Février 2025],
)

#slide(title: [Qui suis-je ?])[
  - Arsène Lapostolet
  - Ingénieur en développement logiciel chez enercoop (fourniture et production d'énergie renouvelable)
  - EFREI LSI P2022
  - arsene\@lapostolet.fr

  #text(style: "italic", [2e année en tant qu'enseignant (n'hésitez pas à me faire des retours pour m'aider à m'améliorer !)])
]

#slide(title: [Objectifs du module])[
  1. Professionaliser la pratique du développement logiciel
    - Tests
    - Qualité logicielle
  2. Concepts avancés en Java
    - Programmation orientée fonction
    - Threads
    - Programmation réseau
]


#slide(title: [Retards])[
  - Tant que vous dérangez pas en arrivant (s'installer discrètement sans interrompre) je vous accepterai quel que soit le retard
  - Venez juste me voir à la pause pour que je vous mette présent sur SoWeSign
  - En revanche n'abusez pas : je vous mets pas présent avec + de 1h30 de retard
]


#slide(title: [Dites moi quand quelque chose ne va pas !])[
  - Ca va trop/pas assez vite
  - C'est pas clair
  - Vous avez une question

  A haute voix ou par chat Teams à tout moment.
]


#slide(title: [Evaluations])[
  1. Projet
    - En binôme
    - Revue de code
    - Découpés en plusieurs livrables
  2. Devoir Ecrit
    - Jeudi 15 mai 2025
    - Questions de cours + Exercice d'analyse avec code fourni
    - Pas d'écriture de code sur papier
]

#slide(title: [Séance type])[
 Chez vous, avant la séance : lire le cours sur le support principal du cours : 
 
 *#link("https://ombrelin.github.io/adv-java")*

 Pendant la séance : 
 1. Récap du cours
 2. Questions & Réponses sur le cours
 3. Travail autonome sur le projet, je suis dispo pour aider en cas de bloquage
]


#slide(title: [Prérequis])[
- Programmation impérative (variables, conditions, boucles, fonctions)
- Base de la programmation objet en Java (classese, encapsulation de données, interfaces, classes abstraites)
- Utilisation basique de git
- Utilisation basique d'un débogueur

**Des fiches d'aide sur ces prérequis sont disponible sur le site du module**
]

#focus-slide(background:  rgb("#EB6237"))[
  🗨️ Des questions ? 
]

#slide(title: [Et vous ?])[

  Je vous voudrais mieux vous connaître et avoir vos attentes sur le module :

  #figure(
    image("images//qr-code.png", width: 20%),
      caption: [
        https://s.42l.fr/efrei-adv-java
      ]
  )

]

#focus-slide(background:  rgb("#EB6237"))[
  ⏳ Pause de 10 minutes pour répondres au sondage.
]
