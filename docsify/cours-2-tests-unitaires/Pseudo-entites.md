# Pseudo-entités


Les pseudo-entités sont des outils permettant de faciliter l'écriture des tests, en replaçant les dépendances de l'unité que l'on teste par des dépendances fausses ou simulées. Ainsi, on peut manipuler facilement ces dépendances dans le contexte du test, afin de reproduire plus facilement des situations à tester, ou pour ignorer des choses qui ne sont pas pertinentes. Cela permet aussi d'accélérer la vitesse d'exécution des tests, en évitant des interactions inutiles dans ce contexte.

Par exemple, pour un système qui va, dans les étapes de son déroulement, envoyer un email, on ne voudrait pas que l'email soit effectivement envoyé pendant l'exécution des tests. On va donc vouloir remplacer la dépendance qui gère l'envoi des mails par une pseudo-entité.

Il existe deux types principaux de pseudo-entités : les faux (*fakes*) et les simulacres (*mocks*).

## Faux (*Fakes*)

Un faux (*fake*) est une pseudo entité qui va être une vraie implémentation de la dépendance, mais plus simpliste, et avec une encapsulation différente afin de faciliter le test. Un faux (*fake*) a un comportement cohérent. Exemples :

- Pour accès à une base de donnée : le faux peut consister à un simple stockage en mémoire

```java
public interface UsersRepository {
    User findByUsername(String username);
}

public class FakeUsersRepository implements UsersRepository {

    private final Map<String, User> data;
    
    public FakeUsersRepository(Map<String, User> data){
        this.data = data;
    }

    public User findByUsername(String username){
        return this.data.get(username);
    }
}

```

Utilisation dans un test, par exemple d'une classe d'application utilisant ce *repository* pour authentifier des utilisateurs :

```java
public void login_whenValidCredentials_isSuccessfull(){
    // Given
    final var username = "John Shepard";
    final var password = "4CMBGi6Mq8jEkL"
    
    final var fakeRepository = new FakeUsersRepository(
        Map.of(username, BCrypt.hashpw(passowrd))
    );
    final var application = new UsersApplication(fakeRepository);
    
    // When
    final bool userLoggedIn = application.login(username, password);
    
    // Then
    assertTrue(userLoggedIn);
}
```

- Pour une dépendance qui fourni le temps présent, et permet de déclencher un événement à un instant T : le faux sera surement une version pour laquelle on peut manipuler le temps

```java
public record Event(Runnable action,  LocalDateTime executionTime);

public interface Clock {
    LocalDateTime now();
    void enqueueEvent(Event event);
}

public class FakeClock implements Clock {

    private LocalDateTime currentTime;
    private final List<Event> events = new LinkedList<>();

    public FakeClock(LocalDateTime startingTime) {
        currentTime = startingTime;
    }

    public LocalDateTime now() {
        return currentTime;
    }

    public void enqueueEvent(Event event) {
        events.add(event);
    }

    public void advanceTimeBy(Duration duration) {
        currentTime = currentTime.plus(duration);
        executeEvents();
    }

    private void executeEvents() {
        for (var event : events) {
            if (event.executionTime().isBefore(currentTime)) {
                event.action().run();
                events.remove(event);
            }
        }
    }
}
```

Cela permet donc d'écrire des tests de classe qui vont dépendre de `Clock`, et d'utiliser le faux (*fake*) pour avancer artificiellement le temps de la `Clock`, et ainsi avoir des tests qui s'exécutent très rapidement, sans savoir besoin d'attendre le temps qu'il faudrait attendre avec une vraie implémentation qui utilise le temps réel.

## Simulacres (*mocks*)

Les simulacres (*mocks*) sont des pseudo-entités qui ne sont pas des implémentations réelles des dépendances, ce sont simplement des coquilles vides, dont on peut configurer les méthodes pour retourner des valeurs en dur, ou vérifier si elles ont été appelées, combien de fois et comment.

Un cas d'utilisation typique d'un simulacre (*mock*) est pour un appel à un client HTTP qui requête un système externe. On veut éviter que notre test dépende d'un vrai appel, pour des raisons de rapidité d'exécution du test, de stabilité du test, de coût, et de facilité d'écriture du test. Il est bien plus simple de pouvoir remplacer la réponse de client dans le contexte de notre test pour toujours tester un cas spécifique attendu.

### Simulacres en Java avec Mockito

Pour installer Mockito, ajouter la dépendance de test à votre projet Gradle :

```Groovy
testImplementation "org.mockito:mockito-core:3.+"
```
Etant donné une classe qui va compter le nombre d'étoiles github d'une personne avec la logique suivante :

```java
public class GithubStartsCounter {

    private final GithubApiClient githubApiClient;
    
    public GithubStartsCounter(GithubApiClient githubApiClient){
        this.githubApiClient = githubApiClient;
    }
    
    public int countGithubStars(String username){
        ...
    }
}
```

La dépendance étant la suivante :

```java
public interface GithubApiClient {
    List<GithubRepo> getUserRepository(String username);
}
```

Nous pouvons mocker la dépendance dans le test :

```java
public class GithubStartsCounterTests {

    @Test
    public void countGithubStars_whenMultipleRepos_computeRightCount(){
        // Given
        final var testUsername = "johnShepN7";
        final var apiClientMock = mock(GithubApiClient.class);
        
        when(apiClientMock.getUserRepository(testUsername))
            .thenReturn(
                List.of(
                    new GithubRepo("test repo 1", 32),
                    new GithubRepo("test repo 2", 12)
                )
            );
        
        final var counter = GithubStartsCounter(apiClientMock);
        
        // When
        final var result = counter.countGithubStars(testUsername)
        
        // Then
        assertEquals(44, result);
    }
}
```

Dans cet extrait de code :

- Avec la fonction `mock` on peut créer un mock d'un type
- avec les fonctions `when` et `thenReturn`, on peut configurer le mock pour que lorsqu'on appelle la méthode `getUserRepository` avec un paramètre spécifique, alors ce dernier retourne une liste prédéfinie.

On pourrait aussi vouloir configurer la valeur de retour pour n'importe quelle valeur d'argument en utilisant `any()`:

```java
when(apiClientMock.getUserRepository(any())
    .thenReturn(...);
```

## Faux, simulacre, ou vraie dépendance ?

Il faut utiliser les vraies dépendances si cela est possible, c'est-à-dire si elles ne font pas d'I/O qui pourrait ralentir ou rendre instable le test. De plus, il faut que la vraie dépendance ne rende pas le test pénible à écrire.

Si les conditions précédentes ne sont pas remplies, alors il convient d'utiliser une pseudo-entité. S'il est possible et que cela facilite les tests d'avoir une implémentation réelle simplifiée, ainsi, l'utilisation d'un faux (*fake*) est à préférer. Cependant, si écrire un faux (*fake*) s'avère trop complexe, que cela ne rend pas le test plus facile à écrire ou à comprendre, alors on se tournera vers l'utilisation d'un simulacre (*mock*).
