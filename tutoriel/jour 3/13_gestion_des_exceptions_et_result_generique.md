# Étape 13 : Gestion des Exceptions et Typage Générique de `Error<T>`

Au fur et à mesure que notre application **WindEnergy** prend vie, nous devons raffiner la frontière entre les **exceptions techniques d'infrastructure** (le réseau qui coupe, la base de données qui renvoie une erreur 500) et les **résultats fonctionnels** manipulés par notre logique métier.

Dans cette étape, nous allons étudier :
1. La création de la classe `ServerException` dans `lib/utils/exceptions.dart`.
2. L'évolution de `Error<T>` dans `lib/utils/result.dart` pour le rendre générique.

---

## 1. Exception technique vs Résultat fonctionnel : Quelle différence ?

Un développeur débutant peut se demander : *"Pourquoi créer `ServerException` alors qu'on a déjà notre classe `Error` dans `result.dart` ?"*

### C'est une distinction fondamentale en Clean Architecture :
- **La couche Data (Infrastructure, services SQL, Supabase, HTTP)** vit dans le monde impur des entrées/sorties : elle peut planter, lever des exceptions réseau, des timeouts, des erreurs SQL. Dans cette couche technique, il est normal qu'un service lève une `ServerException` lorsqu'un serveur ne répond pas.
- **La couche Domaine (et les Repositories)** doit protéger le reste de l'application : elle attrape ces exceptions techniques (`catch (e)`) et les convertit en **objets de résultat sûrs** (`Result<T>`) afin que les ViewModels et l'interface graphique ne crashent jamais.

---

## 2. Création de `lib/utils/exceptions.dart`

Créez le fichier [lib/utils/exceptions.dart](file:///d:/PROJECT2026/windenergy/lib/utils/exceptions.dart) :

```dart
class ServerException implements Exception {
  final String reason;
  ServerException({this.reason = ""});
}
```

### Analyse pédagogique :
- `implements Exception` : En Dart, implémenter l'interface native `Exception` permet d'utiliser notre classe avec la clause `on ServerException catch (e)`.
- `final String reason` : Porte un message d'explication lisible sur la cause du problème serveur (ex: `"Délai d'attente dépassé"`, `"Erreur 500 Supabase"`).

---

## 3. Évolution de `lib/utils/result.dart` : Rendre `Error<T>` générique

Ouvrez [lib/utils/result.dart](file:///d:/PROJECT2026/windenergy/lib/utils/result.dart) et observez l'amélioration apportée :

```dart
import 'package:equatable/equatable.dart';

abstract class Result<T> extends Equatable {}

class Success<T> extends Result<T> {
  final T? value;

  Success({this.value});

  @override
  List<Object?> get props => [value];
}

class Error<T> extends Result<T> {
  final String reason;

  Error({this.reason = ""});

  @override
  List<Object?> get props => [reason];
}

typedef FutureResult<T> = Future<Result<T>>;
```

### Pourquoi passer de `class Error extends Result<String>` à `class Error<T> extends Result<T>` ?

1. **Cohérence du système de types Dart** :
   Si une méthode déclare retourner un `FutureResult<Profile>` (c'est-à-dire `Future<Result<Profile>>`) :
   - Avant : `Error` héritait de `Result<String>`. Pour Dart, un `Result<String>` n'est pas un sous-type strict de `Result<Profile>`. Cela pouvait poser des problèmes de typage statique ou nécessiter des casts maladroits.
   - Maintenant : `Error<T>` hérite de `Result<T>`. Si `T` vaut `Profile`, nous pouvons retourner `Error<Profile>(reason: "...")` qui est parfaitement et rigoureusement un `Result<Profile>`.
2. **Précision dans les tests unitaires** :
   Dans vos tests, vous pouvez désormais vérifier l'égalité de type avec une précision chirurgicale :
   ```dart
   expect(result, Error<Profile>());
   ```

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que [lib/utils/exceptions.dart](file:///d:/PROJECT2026/windenergy/lib/utils/exceptions.dart) existe.
2. Vérifiez que [lib/utils/result.dart](file:///d:/PROJECT2026/windenergy/lib/utils/result.dart) contient bien `class Error<T> extends Result<T>`.
3. Lancez l'analyse statique :
   ```bash
   flutter analyze
   ```
4. **Ce que vous devez observer :**
   - Aucune erreur de compilation.
   - Les outils de gestion des pannes sont prêts pour l'implémentation concrète des Repositories.

Passons à l'[Étape 14 : Implémentation réelle des Repositories et DbService](file:///d:/PROJECT2026/windenergy/tutoriel/jour%203/14_implementation_reelle_repositories_et_dbservice.md).
