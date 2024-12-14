# Autres concepts fonctionnels intéressants


## Filtrage par motif (*pattern matching*)

Le *pattern matching* consiste à tester une expression, pour vérifier si elle a certaines caractéristiques. On peut l'utiliser en Java dans les switch-expression.

### Sur une valeur discrète

```java
public State PerformOperation(String command) {
	return switch (command) {
		case "SystemTest" -> runDiagnostics();
		case "Start" -> startSystem();
		case "Stop" -> stopSystem();
		case "Reset" -> resetToReady();
		default -> throw new IllegalArgumentException("Invalid string value for command");
	};
}
```

## Classes d'enregistrement (record class)

Classe qui représente des objets-valeur :

- Syntaxe plus concise
- `equals()`, `hashcode()` et `toString()` générés automatiquement
- Immutable

```java
record Rectangle(double length, double width) {

}
```