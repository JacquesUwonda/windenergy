# Étape 10 : Couche Domaine — Contrats des Repositories

Dans une application conçue selon les principes de la **Clean Architecture**, la couche Domaine ne doit dépendre d'aucune technologie concrète (pas de Supabase, pas de SQL, pas de Bluetooth). Elle déclare uniquement des **contrats abstraits** définissant ce que l'application doit être capable de faire.

Dans cette étape, nous allons étudier les 3 repositories abstraits du projet :
1. `AuthentificationRepository` (Gestion de session et sécurité).
2. `ProfileRepository` (Données du technicien).
3. `TurbineRepository` (Enregistrement, comptage et surveillance des éoliennes).

---

## 1. Pourquoi trois repositories distincts ? Le principe ISP de SOLID

Le principe **ISP** (*Interface Segregation Principle* ou Ségrégation des Interfaces) stipule qu'il vaut mieux plusieurs petites interfaces spécialisées plutôt qu'une seule interface monolithique "fourre-tout".

- Un écran d'authentification n'a pas besoin de connaître les méthodes de pilotage d'éoliennes.
- Un widget de carte d'éolienne n'a pas besoin de connaître le mot de passe de l'utilisateur.

---

## 2. Le contrat `AuthentificationRepository`

Ouvrez ou créez [lib/features/domain/repositories/authentification_repository.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/repositories/authentification_repository.dart) :

```dart
import 'package:windenergy/utils/result.dart';

abstract class AuthentificationRepository {
  FutureResult signIn({String email, String password});
  FutureResult signUp({String fullName, String email, String password});
  FutureResult signOut();
}
```

### Analyse pédagogique :
- `abstract class` : Empêche toute instanciation directe. Ce n'est qu'un cahier des charges.
- `FutureResult` : Toutes les méthodes retournent un résultat asynchrone sécurisé (`Result<T>`) sans risquer de lever une exception non gérée.
- `signIn`, `signUp`, `signOut` : Les 3 opérations indispensables pour sécuriser l'accès au parc éolien.

---

## 3. Le contrat `ProfileRepository`

Ouvrez ou créez [lib/features/domain/repositories/profile_repository.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/repositories/profile_repository.dart) :

```dart
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/utils/result.dart';

abstract class ProfileRepository {
  FutureResult<Profile> readProfile();
}
```

### Analyse pédagogique :
- `FutureResult<Profile>` : Garantit que l'appel renvoie soit une instance typée de notre entité `Profile`, soit une erreur explicative (`Error`).

---

## 4. Le contrat `TurbineRepository`

Ouvrez ou créez [lib/features/domain/repositories/turbine_repository.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/repositories/turbine_repository.dart) :

```dart
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/result.dart';

abstract class TurbineRepository {
  FutureResult<int> readCount();
  FutureResult<double> readTotalPowerW();
  FutureResult<List<Turbine>> readTurbines();
  FutureResult createTurbine({
    String serialNumber,
    String customName,
    Position position,
  });
  FutureResult<PairingCode> readPairingCode({int turbineId});
  FutureResult readTurbineActivation();
  FutureResult updateTurbine({
    int turbineId,
    String customName,
    Position position,
  });
  FutureResult deleteTurbine({int turbineId});
}
```

### Analyse des opérations d'enregistrement et de monitoring :
- **Monitoring global du parc** :
  - `readCount()` : Nombre total d'éoliennes sous supervision.
  - `readTotalPowerW()` : Puissance totale combinée générée par toutes les turbines en service.
  - `readTurbines()` : Récupération de la liste complète des éoliennes.
- **Enregistrement et gestion d'une éolienne** :
  - `createTurbine(...)` : Déclaration d'une nouvelle éolienne sur le site (numéro de série, nom, coordonnées GPS).
  - `readPairingCode({int turbineId})` : Récupération du code d'appairage sécurisé pour associer l'appareil.
  - `readTurbineActivation()` : Vérification de l'activation effective de la turbine.
  - `updateTurbine(...)` et `deleteTurbine(...)` : Maintenance et désaffectation.

---

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que les 3 fichiers existent dans `lib/features/domain/repositories/`.
2. Lancez le linter :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Le compilateur Dart valide la cohérence des types.
   - Les contrats du Domaine sont parfaitement définis et prêts à être implémentés par la couche Data.

Passons aux abstractions des services techniques dans l'[Étape 11 : Couche Données — Services Abstraits](file:///d:/PROJECT2026/windenergy/tutoriel/11_couche_donnees_services_abstraits.md).
