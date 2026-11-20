# Étape 4 : Gestion fonctionnelle des erreurs (Pattern Result)

Dans une application industrielle comme **WindEnergy**, les opérations réseau et les validations peuvent échouer à tout moment : perte de signal 4G/5G au pied d'une éolienne, panne du serveur Supabase, code d'appairage expiré ou erroné.

Dans cette étape, nous allons concevoir une classe utilitaire fondamentale : le pattern **Result**.

---

## 1. Pourquoi éviter les exceptions `throw / try-catch` sauvages ?

Traditionnellement en programmation orientée objet, pour signaler une erreur, on utilise `throw Exception("Erreur")` :

```dart
// ❌ Mauvaise pratique courante
Turbine getTurbine(int id) {
  if (id <= 0) throw Exception("ID invalide");
  // ... appel réseau
}
```

### Les 3 défauts majeurs de cette approche :
1. **L'appelant peut oublier le `try/catch`** : La signature de la fonction `Turbine getTurbine(int id)` ne mentionne nulle part qu'elle peut échouer. Si le développeur oublie d'envelopper son appel dans un `try/catch`, l'application plante violemment en production (Crash).
2. **Les exceptions sont coûteuses** : En Dart, instancier et dérouler une pile d'appel (*stack trace*) lors d'une exception est une opération lourde.
3. **Une erreur métier n'est pas un bug** : Un code d'appairage invalide n'est pas une "exception" anormale du système, c'est un cas métier normal et prévisible que le code doit traiter couramment.

### La solution : Le Pattern Result (ou Either)
Au lieu de lever une exception, nos méthodes vont toujours renvoyer un objet contenant soit :
- Un **succès** contenant la donnée attendue (`Success<T>`).
- Un **échec** contenant le message d'erreur ou la cause (`Error`).

---

## 2. Création du fichier `lib/utils/result.dart`

Créez le fichier `lib/utils/result.dart` et écrivez le code suivant :

```dart
import 'package:equatable/equatable.dart';

/// Classe de base abstraite représentant le résultat d'une opération.
///
/// Elle est générique : [T] représente le type de donnée retournée en cas de succès.
/// Elle hérite de [Equatable] pour permettre des comparaisons faciles dans les tests.
abstract class Result<T> extends Equatable {}

/// Représente une opération qui a réussi.
///
/// Contient optionnellement ou obligatoirement la [value] de type [T].
class Success<T> extends Result<T> {
  final T? value;

  Success({this.value});

  @override
  List<Object?> get props => [value];
}

/// Représente une opération qui a échoué.
///
/// Contient une explication lisible [reason] décrivant la cause de l'échec.
class Error extends Result<String> {
  final String reason;

  Error({this.reason = ""});

  @override
  List<Object?> get props => [reason];
}

/// Raccourci syntaxique (typedef) très pratique pour les opérations asynchrones.
///
/// Écrire `FutureResult<Profile>` est plus concis et lisible que `Future<Result<Profile>>`.
typedef FutureResult<T> = Future<Result<T>>;
```

---

## 3. Analyse détaillée du code ligne par ligne

Décortiquons chaque mot-clé pour bien assimiler la mécanique Dart :

### `abstract class Result<T>`
- `abstract` : Empêche d'instancier directement `Result()`. On instanciera uniquement ses enfants `Success` ou `Error`.
- `<T>` : C'est un **type générique**. Si une opération charge un profil, elle retournera un `Result<Profile>`. Si elle charge la puissance d'une éolienne, elle retournera un `Result<double>`.

### `extends Equatable` et `get props`
- En Dart par défaut, `Success(value: 42) == Success(value: 42)` renvoie `false` car ce sont deux adresses mémoires distinctes.
- Grâce à `Equatable` et à la liste de propriétés retournée par `get props => [value]`, deux objets `Success` avec la même valeur seront considérés comme strictement égaux (`==`). Cela rend l'écriture des tests unitaires d'une simplicité enfantine !

### `typedef FutureResult<T>`
- Un `typedef` en Dart est un alias de type. Comme la majorité des opérations réseau et base de données sont asynchrones (`Future`), au lieu de taper partout `Future<Result<Turbine>>`, nous pourrons simplement écrire `FutureResult<Turbine>`.

---

## 4. Exemple d'utilisation concrète

Voici comment un ViewModel ou un composant consommera ce pattern de manière limpide :

```dart
final result = await turbineRepository.getTurbineDetails(turbineId: 101);

if (result is Success<Turbine>) {
  print("Éolienne connectée : ${result.value?.name}");
} else if (result is Error) {
  print("Impossible de joindre l'éolienne : ${result.reason}");
}
```
Remarquez la sécurité absolue : le compilateur Dart effectue une promotion de type (*Type Promotion*). Dès qu'on vérifie `result is Success<Turbine>`, Dart sait automatiquement que `result.value` est disponible et de type `Turbine`.

---

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que le fichier existe bien à l'emplacement [lib/utils/result.dart](file:///d:/PROJECT2026/windenergy/lib/utils/result.dart).
2. Lancez l'analyse statique du code depuis votre terminal :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Le linter ne signale aucune erreur ni avertissement sur `lib/utils/result.dart`.
   - Votre projet dispose désormais d'un socle unifié et robuste pour véhiculer données et erreurs.

Passons à la création de notre première entité métier dans l'[Étape 5 : Couche Domaine — L'Entité Profile](file:///d:/PROJECT2026/windenergy/tutoriel/05_couche_domaine_entite_profile.md).
