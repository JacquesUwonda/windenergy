# Étape 4 : Gestion des erreurs avec le Pattern Result et ServerException

Dans une application connectée comme **WindEnergy**, les opérations de réseau et les interactions avec la base de données peuvent échouer (perte de connexion sur le parc éolien, mot de passe erroné, code d'appairage expiré).

Dans cette étape, nous allons concevoir une gestion d'erreurs robuste à travers deux fichiers complémentaires :
1. `lib/utils/exceptions.dart` : Pour signaler des erreurs techniques d'infrastructure.
2. `lib/utils/result.dart` : Pour transmettre de manière sûre les succès ou les échecs à la logique métier.

---

## 1. Pourquoi éviter les exceptions `throw / try-catch` sauvages dans l'interface ?

En programmation traditionnelle, quand une opération échoue, on lance une exception :
```dart
// ❌ Risqué dans l'UI ou les ViewModels
final turbine = await repository.getTurbine(12); // Si ça throw et qu'on oublie le catch -> Crash !
```

### Les risques majeurs :
1. **Crash inattendu** : Si le développeur oublie un bloc `try/catch` dans un widget, l'application plante violemment devant le technicien sur le terrain.
2. **Signature opaque** : Rien dans la signature de méthode `Future<Turbine> getTurbine()` n'indique qu'elle peut échouer.

### La solution : Séparer l'Exception technique du Résultat fonctionnel
- **Dans la couche Data (services)** : Une panne serveur lève une exception dédiée `ServerException`.
- **Dans les Repositories** : Le repository capture cette exception (`catch`) et la transforme en un objet de résultat sécurisé `Result<T>` (`Success<T>` ou `Error<T>`).
- **Dans les ViewModels et l'UI** : On inspecte simplement si le résultat est un succès ou une erreur, sans jamais risquer de crash inattendu.

---

## 2. Le fichier `lib/utils/exceptions.dart`

Créez le fichier [lib/utils/exceptions.dart](file:///d:/PROJECT2026/windenergy/lib/utils/exceptions.dart) :

```dart
class ServerException implements Exception {
  final String reason;
  ServerException({this.reason = ""});
}
```

### Analyse :
- `implements Exception` : Permet d'attraper spécifiquement cette classe avec la syntaxe `on ServerException catch (e)`.
- `final String reason` : Stocke le message d'erreur explicatif fourni par le service (ex: `"invalid credentials"` ou `"an error occurred on the server"`).

---

## 3. Le fichier `lib/utils/result.dart`

Ouvrez ou créez le fichier [lib/utils/result.dart](file:///d:/PROJECT2026/windenergy/lib/utils/result.dart) :

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

---

## 4. Analyse détaillée du code

### A. Le typage générique `<T>` sur `Result`, `Success` et `Error`
- `Result<T>` est une classe abstraite générique. Si une méthode charge un profil, elle retourne un `Result<Profile>`.
- `Success<T>` transporte la valeur `value` de type `T?`.
- `Error<T>` hérite également de `Result<T>`. Cela garantit que `Error<Profile>()` est rigoureusement compatible avec le type attendu `Result<Profile>`.

### B. Héritage de `Equatable` et `props`
- Grâce à `Equatable`, deux instances `Success<int>(value: 5)` sont considérées comme égales par valeur (`==`). Cela simplifie énormément l'écriture des tests unitaires (`expect(result, Success())`).

### C. Le raccourci `FutureResult<T>`
- L'instruction `typedef FutureResult<T> = Future<Result<T>>;` évite d'écrire des types à rallonge dans nos déclarations de méthodes asynchrones.

---

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que les fichiers [lib/utils/exceptions.dart](file:///d:/PROJECT2026/windenergy/lib/utils/exceptions.dart) et [lib/utils/result.dart](file:///d:/PROJECT2026/windenergy/lib/utils/result.dart) sont conformes.
2. Lancez l'analyse statique :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur sur ces deux fichiers.
   - Votre application dispose de son mécanisme universel de gestion des pannes et des résultats.

Passons à la première entité du domaine dans l'[Étape 5 : Couche Domaine — L'Entité Profile](file:///d:/PROJECT2026/windenergy/tutoriel/jour%201/05_couche_domaine_entite_profile.md).
