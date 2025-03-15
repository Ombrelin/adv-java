# Qualité d'écriture du code


## Qualité d'écriture du code

Quand on écrit du code, on l'écrit pour la machine, pour qu'elle fasse ce qu'on veut qu'elle fasse, mais pas seulement. On écrit aussi notre code pour qu'il soit lu par d'autres humains ; nous, nos collègues, co-contributeurs open-source...

Ainsi, pour écrire du code de qualité, il faut que le code communique les intentions de l'auteur, afin qu'il soit lisible et compréhensible par quelqu'un au fur et à mesure de la lecture. Il faut que le code se lise presque comme un texte.

### Nommer les éléments pour révéler l'intention

Pour révéler son intention, il faut utiliser des noms précis et complets quand on nomme les symboles de notre code : classes, méthodes, champs, variables...

Cela veut dire, pour les noms :

- Ne pas faire d'abréviations
- Ne pas utiliser d'acronymes
- Toujours décrire l'objectif du symbole dans son nom
- Ne pas avoir peur d'avoir des noms de symboles longs
- Utiliser des noms en anglais
- Utiliser des noms prononçables
- Ne pas utiliser de nombres magiques

Spécifiquement les noms de :

- *Classes* doivent être des noms ou des phrases nominales : `Customer`, `WikiPage`, `Customer`, `AddressParser`
- *Méthodes* doivent être des verbes ou des phrases verbales : `postPayment`, `deletePage`, `save`

Exemple :

```java
public List<int[]> getThem(){
    List<int[]> list1 = new ArrayList<int[]>();
    for(int[] x : theList){
        if(x[0] == 4){
            list1.add(x);
        }
    }
    return list1;
}
```

Cette méthode ne fait rien de très compliqué, elle n'est pas trop longue, son indentation est correcte, mais elle est très difficile à lire, car les noms des symboles ne donnent aucune information.

On peut améliorer cela :

```java
public List<int[]> getFlaggedCells(){
    List<int[]> flaggedCells = = new ArrayList<int[]>();
    for(int[] cell : gameboard){
        if(isFlagged(cell)){
            flaggedCells.add(cell);
        }
    }
    return flaggedCells;
}
```

Juste en changeant des noms et des nombres magiques, on obtient une méthode qui communique de l'information, si bien que même sans avoir trop de contexte, on comprend tout de suite de quoi il retourne.

### Utilisations des méthodes/fonctions pour révéler l'intention

Les méthodes/fonctions doivent être le plus courtes possible. Il est tout à fait normal de faire des méthodes/fonctions qui ne sont appelées qu'à un seul endroit, donc pour autre chose que pour mutualiser du code, simplement parce qu'en extrayant et remplaçant une méthode/fonction d'un bloc de code, on donne un nom au bloc en question, donc on révèle l'intention qu'il y a dérrière, mais aussi, on cache les détails qui ne sont pas nécessairement importants à la compréhension.

Une méthode/fonction ne devrait pas faire plus de 20 lignes, elle en fait idéalement moins de 10.

Lorsqu'on implémente un algorithme, une logique, c'est normal de tout écrire d'une traite, c'est plus facile pour écrire, mais ensuite, il faut refactorer pour faciliter la lecture, en repérant les blocs de code qui ont du sens et les extraire sous forme de méthode/fonction. La fonctionnalité de l'IDE "Refactorer : extraire en tant que méthode" est très utile pour faire cela rapidement.

Par exemple, la méthode suivante évalue une expression mathématique :

```java
public double compute(String polishNotationExpression) {
    var computeStack = new Stack<Double>();

    String[] tokens = polishNotationExpression.split(" ");

    for (var token : tokens) {
        if (!OPERATORS.contains(token)) {
            try {
                computeStack.push(Double.parseDouble(token));
            } catch (NumberFormatException ignored) {
                throw new IllegalArgumentException();
            }
        } else {
            if (!OPERATORS.contains(token)) {
                throw new IllegalArgumentException();
            }

            computeStack.push(switch (token) {
                case "*" -> computeStack.pop() * computeStack.pop();
                case "/" -> computeStack.pop() / computeStack.pop();
                case "+" -> computeStack.pop() + computeStack.pop();
                case "-" -> computeStack.pop() - computeStack.pop();
                default -> throw new IllegalArgumentException();
            });
        }
    }

    if (computeStack.size() > 1) {
        throw new IllegalArgumentException();
    }

    return computeStack.pop();
}
```

La méthode `compute()` est trop longue et pourrait être divisée pour une meilleure lisibilité, simplement par l'extraction de blocs en tant que méthodes privées de la classe :

```java
    public double compute(String polishNotationExpression) {
        var computeStack = new Stack<Double>();
        String[] tokens = polishNotationExpression.split(" ");

        for (var token : tokens) {
            if (!isOperator(token)) {
                addOperandOnStack(token, computeStack);
            } else {
                executeOperation(token, computeStack);
            }
        }

        ensureExpressionIsValid(computeStack);
        return computeStack.pop();
    }
```

La logique de l'algorithme apparait de façon beaucoup plus évidente, et le code de la méthode se lit comme un texte qui décrit cet algorithme :

*For each token, if not is operator, then add as an operand on the stack, else execute an operation*.

Les règles à retenir :

- Méthodes/fonctions courtes : pas plus de 20 lignes, 10 lignes idéalement
- Chaque méthode/fonction doit faire une seule chose
- Séparer les Commandes et les Requêtes, une méthode/fonction est soit l'un, soit l'autre, par les deux :
    - Requête : calculer une valeur
    - Commande : Faire une action
- Utiliser les méthodes/fonctions et leur nom pour décrire des blocs logiques
- Pas plus de 4 arguments pour méthode/fonction