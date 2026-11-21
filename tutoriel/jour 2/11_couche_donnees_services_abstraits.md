# Étape 11 : Couche Données — Services Abstraits

Dans l'architecture de notre projet **WindEnergy**, les Repositories ne parlent pas directement aux bibliothèques tierces comme Supabase ou aux capteurs matériels du téléphone. Ils s'appuient sur des **Services** techniques dédiés situés dans `lib/features/data/services/`.

Dans cette étape, nous allons étudier :
1. `PositionService` : Le service d'acquisition des coordonnées GPS.
2. `DbService` : L'interface de communication avec la base de données.

---

## 1. Pourquoi créer une couche de Services techniques ?

Un débutant pourrait se demander : *"Pourquoi ne pas mettre le code Supabase ou le GPS directement dans le Repository ?"*

### La réponse de l'ingénieur :
1. **Séparation des préoccupations (SoC)** : 
   - Le **Repository** a une responsabilité *métier* : il orchestre la logique (ex: avant de créer une turbine, récupérer la position GPS, valider les règles puis insérer en base).
   - Le **Service** a une responsabilité *technique unitaire* : interagir avec une source brute (exécuter une requête SQL Supabase ou interroger le module GPS du smartphone).
2. **Facilité de remplacement** :
   - Si nous passons d'un plugin GPS à un autre, ou de Supabase vers Firebase ou une base SQLite locale hors-ligne, seul le `DbService` ou le `PositionService` change. Les Repositories et le Domaine restent rigoureusement intacts !

---

## 2. Le contrat `PositionService`

Ouvrez ou créez le fichier [lib/features/data/services/position_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/position_service.dart) :

```dart
import 'package:windenergy/utils/result.dart';

abstract class PositionService {
  FutureResult<List<double>> getPosition();
}
```

### Analyse pédagogique :
- `getPosition()` : Retourne une liste de décimaux `[latitude, longitude]` enveloppée dans un `FutureResult`.
- Si le technicien refuse la permission GPS ou que le signal satellite est indisponible sous la tour de l'éolienne, le service retourne un `Error(reason: "Signal GPS introuvable")` au lieu de faire planter l'application.

---

## 3. Le contrat `DbService`

Ouvrez ou créez le fichier [lib/features/data/services/db_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/db_service.dart) :

```dart
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/result.dart';

abstract class DbService {
  FutureResult signIn({String email, String password});
  FutureResult signUp({String fullName, String email, String password});
  FutureResult signOut();

  FutureResult<Profile> readProfile();

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

### Analyse pédagogique :
- `DbService` regroupe l'ensemble des requêtes techniques adressées à la source de données distante (par exemple Supabase).
- Il fournit les briques élémentaires que les repositories vont consommer et coordonner.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que les deux fichiers existent dans [lib/features/data/services/](file:///d:/PROJECT2026/windenergy/lib/features/data/services/) :
   - `position_service.dart`
   - `db_service.dart`
2. Lancez la commande d'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur détectée.
   - Vos contrats de services techniques sont posés, prêts à être consommés par les implémentations de repositories.

Passons à la mise en œuvre des repositories dans l'[Étape 12 : Couche Données — Implémentations des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/12_couche_donnees_implementations_repositories.md).
