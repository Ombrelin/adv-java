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
  subtitle: [Projet],
  authors: ([Arsène Lapostolet]),
  date: [19 Janvier 2024],
)

#slide(title: [Concept])[
  - Coder un Monopoly
  - Simulation des règles du domaine
  - Jeu en réseau
  - En bînomes
]


#slide(title: [Notation])[
  - 5 Livrables
  - 4 points par Livrables
    - 2 points complétion des fonctionnalités
    - 2 points qualité de code (tests unitaires, qualité logicielle, fonctionnalités du langage)
]


#slide(title: [Planning])[
  #table(columns: (auto, auto),
  inset: 8pt,
  align: horizon,
  [*Date*],[*Sujet*],
  [Lundi 10 Février 2025],[Démarrage du projet],
  [Dimanche 23 Février 2025],[Date limite de rendu du livrable 1],
  [Dimanche 23 Mars 2025],[Date limite de rendu du livrable 2],
  [Dimanche 5 Avril 2025],[Date limite de rendu du livrable 3],
  [Dimanche 20 Avril 2025],[Date limite de rendu du livrable 4],
  [Dimanche 4 Mai 2025],[Date limite de rendu du livrable 5],
  )
]

#slide(title: [Plagiat])[

- Interdit de partager du code à d'autres binômes
]

#slide(title: [Outils "IA" (LLMs)])[

- Pas fiable ➡️ inéfficace
- Utilisez plutôt documentation / stackoverflow / google.com
- Impacte écologique important

Si vous voulez vraiment : 

1. Vérifiez 
2. Comprenez
]

#slide(title: [Modalités])[

- Tests d'intégration fournis
  - Spécification du projet
  - Condition nécessaire mais pas suffisante pour valider un livrable
- Revue de code
  - Chaque livrable fait l'objet d'une revue de code par l'enseignant
  - Noté après application des recommendations de la revue
]

#slide(title: [Démarrage du projet])[
  1. Créer un compte GitLab
  2. Trouver son binôme
  3. Forker le projet sur GitLab
  4. Ajouter l'enseignant sur le dépôt GitLab
  5. Mettre son projet sur la feuille excel ainsi que son nom d'utilisateur
  6. Cloner son dépôt
  7. Créer son module
]

#slide(title: [Processus de livraison])[
  1. Créer une branche `dev/livrable-x`
  2. Mettre à jour sa branche de dev : Fusionner `template/livrable-x` de mon dépôt dans `dev/livrable-x` de votre dépôt
  3. Coder pour faire passer les tests d'intégration, commiter
  4. Pull request `dev/livrable-x` -> `master` (Assignee = enseignant)
  5. Je fais la revue, propose des améliorations
  6. Vous implémentez les améliorations suggérées, puis je valide la fusion
]

#focus-slide(background:  rgb("#EB6237"))[
  Des questions ? 
]

#focus-slide(background:  rgb("#EB6237"))[
  Description du template du projet
]

#slide(title: [Livrable 1 : Jets de dés, plateau, déplacement])[
  #side-by-side[
    - Les joueurs ne peuvent que passer leur tour
    - Les joueurs se déplacent par jet de dés
    - Données du plateau dans un fichier CSV de ressources
][
  #figure(image("./images/board.png", width:68%))
]
]
    
#focus-slide(background:  rgb("#EB6237"))[
  Présentation des tests d'intégration]

#focus-slide(background:  rgb("#EB6237"))[
  Go ! Lancez vous pour le setup du projet]
