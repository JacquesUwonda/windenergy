# Étape 11 : Couche Données — Services Abstraits

Dans notre architecture, les Repositories ne manipulent pas directement les SDKs externes (comme Supabase ou le GPS du téléphone). Ils délèguent les opérations bas niveau à des **Services techniques** spécialisés situés dans `lib/features/data/services/`.

Dans cette étape, nous allons étudier et concevoir les deux abstractions de services :
1. `PositionService` : Le service d'acquisition des coordonnées GPS.
2. `DbService` : L'interface unifiée de communication avec la base de données.

---

## 1. Pourquoi abstraire la base de données via `DbService` ?

Dans notre projet, Supabase est notre solution de stockage et d'authentification. Mais si nous écrivions des appels `supabaseClient.from(...)` directement dans nos repositories :
- Le repository deviendrait dépendant de la syntaxe propriétaire de Supabase.
- Il serait très difficile de tester le repository de façon isolée.
- En introduisant l'interface `DbService`, nos repositories dépendent d'un contrat technique clair. Nous pourrons créer un `SupabaseService` en production, et un `MockDbService` dans nos tests unitaires !

---

## 2. Le contrat `PositionService`

Ouvrez ou créez le fichier [lib/features/data/services/position_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/position_service.dart) :

```dart
import 'package:windenergy/utils/result.dart';

abstract class PositionService {
  FutureResult<List<double>> getPosition();
}
```

### Analyse :
- `getPosition()` : Retourne une liste de deux coordonnées `[latitude, longitude]`.
- Enveloppé dans un `FutureResult`, cela permet de gérer proprement les cas où le technicien désactive son GPS ou refuse les permissions de l'application.

---

## 3. Le contrat `DbService`

Ouvrez ou créez le fichier [lib/features/data/services/db_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/db_service.dart) :

```dart
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/result.dart';
import 'package:windenergy/features/domain/entities/profile.dart';

abstract class DbService {
  FutureResult<String> signIn({String email, String password});
  FutureResult<String> signUp({String fullName, String email, String password});
  FutureResult signOut();
  FutureResult<Profile> readProfile({String userId});
  FutureResult<int> readCount({String userId});
  FutureResult<double> readTotalPowerW({String userId});
  FutureResult<List<Turbine>> readTurbines({String userId});
  FutureResult<int> createTurbine({
    String userId,
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

### Analyse pédagogique :
- `signIn` et `signUp` retournent `FutureResult<String>` : la chaîne retournée correspond à l'identifiant unique de l'utilisateur (`userId` ou `UUID`) généré par le système d'authentification.
- Les méthodes de lecture (`readProfile`, `readCount`, `readTotalPowerW`, `readTurbines`, `createTurbine`) prennent explicitement le paramètre `String userId` : le service technique exécute la requête ciblée sur cet utilisateur précis.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que [lib/features/data/services/position_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/position_service.dart) et [lib/features/data/services/db_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/db_service.dart) sont conformes.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur.
   - Les contrats de services techniques sont établis.

Vous avez terminé le **Jour 2** ! Passons au **Jour 3** avec l'implémentation de la session et des repositories.
