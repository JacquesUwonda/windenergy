# Étape 8 : Couche Domaine — L'Entité Turbine

Après avoir modélisé le technicien (`Profile`), le code d'enregistrement (`PairingCode`) et la position géographique (`Position`), nous arrivons à l'élément central de notre application : **l'éolienne** (`Turbine`).

Dans cette étape, nous allons étudier et reproduire le fichier `lib/features/domain/entities/turbine.dart`.

---

## 1. Les besoins métier autour d'une éolienne

Dans une station d'énergie éolienne, chaque turbine possède :
1. Un identifiant unique en base de données (`id`).
2. Un numéro de série constructeur (`serialNumber`) gravé sur le mât ou la nacelle de l'éolienne (ex: `"SN-VESTAS-2026-X9"`).
3. Un nom personnalisé (`customName`) choisi par l'équipe d'exploitation pour la repérer facilement sur le terrain (ex: `"Éolienne Crête Nord 01"`).
4. Des coordonnées géodésiques précises (`position`).
5. Un statut opérationnel (`status`) permettant de savoir si l'éolienne est active et produit de l'énergie ou si elle est inactive/arrêtée.
6. Une date de mise en service ou d'enregistrement (`createdAt`).

---

## 2. Le code source : `lib/features/domain/entities/turbine.dart`

Ouvrez ou créez le fichier [lib/features/domain/entities/turbine.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/turbine.dart) :

```dart
import 'package:equatable/equatable.dart';
import 'package:windenergy/features/domain/entities/position.dart';

enum TurbineStatus { active, inactive }

class Turbine extends Equatable {
  final int id;
  final String serialNumber;
  final String customName;
  final Position position;
  final TurbineStatus status;
  final DateTime? createdAt;

  const Turbine({
    this.id = 0,
    this.serialNumber = "",
    this.customName = "",
    this.position = const Position(),
    this.status = TurbineStatus.inactive,
    this.createdAt,
  });

  @override
  List<Object?> get props => [id];
}
```

---

## 3. Analyse des concepts pour débutant

### A. L'énumération `TurbineStatus { active, inactive }`
- Pourquoi pas un booléen `bool isActive` ? Comme nous l'avons appris avec `PairingStatus`, une éolienne industrielle est un équipement complexe. Aujourd'hui nous distinguons `active` et `inactive`. Demain, nous pourrons facilement enrichir cet enum avec `maintenance`, `error` ou `calibrating` sans casser l'architecture.

### B. Composition d'objets (`Position position`)
- Remarquez la ligne :
  ```dart
  final Position position;
  ```
  C'est le principe de **composition** en programmation orientée objet : plutôt que d'alourdir la classe `Turbine` avec des coordonnées éparpillées, elle embarque une instance de notre classe `Position`.
- Dans le constructeur : `this.position = const Position()`. Grâce au constructeur `const` de `Position`, si aucune coordonnée n'est fournie, une instance immuable par défaut `(0.0, 0.0)` est assignée sans surcoût mémoire.

### C. La distinction `serialNumber` vs `customName`
- Le `serialNumber` est la clé matérielle immuable de l'appareil (associée à l'usine et au certificat d'appairage).
- Le `customName` est le libellé convivial modifiable par l'exploitant du parc.

### D. La comparaison `Equatable` basée sur `[id]`
```dart
@override
List<Object?> get props => [id];
```
- En Clean Architecture, une éolienne est une **Entité** (au sens DDD) : son identité dans le monde réel est déterminée par son identifiant unique `id`. Même si son nom ou son statut change, il s'agit toujours de la même turbine physique.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que le fichier existe dans [lib/features/domain/entities/turbine.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/turbine.dart).
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur de compilation.
   - L'entité centrale `Turbine` est prête à être connectée à la télémétrie de monitoring.

Passons à la mesure de l'énergie et de la production dans l'[Étape 9 : Couche Domaine — Télémétrie et Monitoring](file:///d:/PROJECT2026/windenergy/tutoriel/09_couche_domaine_entites_telemetrie_et_monitoring.md).
