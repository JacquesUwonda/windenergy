# Étape 7 : Couche Domaine — L'Entité Position (Géolocalisation)

Dans une station d'énergie éolienne, les turbines sont réparties sur de vastes étendues géographiques (parcs terrestres ou fermes offshore en mer). Savoir exactement où se situe chaque équipement est capital pour les interventions des techniciens.

Dans cette étape, nous allons concevoir l'entité `Position` dans `lib/features/domain/entities/position.dart`.

---

## 1. Pourquoi créer une classe `Position` au lieu de simples `double` ?

Un développeur débutant pourrait être tenté de mettre deux variables directement dans l'éolienne :
```dart
// ❌ Approche simpliste
class Turbine {
  final double latitude;
  final double longitude;
  // ...
}
```

### Pourquoi cette approche est sous-optimale ?
1. **Perte de sens métier (Primitive Obsession)** : Deux nombres décimaux (`double`) isolés ne représentent rien en eux-mêmes. En les regroupant dans un objet `Position`, on crée un **Value Object** (concept clé du *Domain-Driven Design* - DDD).
2. **Réutilisabilité** : Cette même classe `Position` pourra être réutilisée pour représenter la position GPS de l'opérateur mobile lorsqu'il se déplace sur le parc éolien.
3. **Encapsulation de la validation** : Demain, si nous devons calculer la distance entre le technicien et l'éolienne, ou vérifier que la latitude est bien comprise entre -90° et +90°, cette logique sera naturellement abritée dans la classe `Position`.

---

## 2. Le code source : `lib/features/domain/entities/position.dart`

Ouvrez ou créez le fichier [lib/features/domain/entities/position.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/position.dart) :

```dart
import 'package:equatable/equatable.dart';

class Position extends Equatable {
  final double latitude;
  final double longitude;

  const Position({this.latitude = 0.0, this.longitude = 0.0});

  @override
  List<Object?> get props => [latitude, longitude];
}
```

---

## 3. Analyse détaillée

### A. Constructeur constant avec valeurs par défaut
```dart
const Position({this.latitude = 0.0, this.longitude = 0.0});
```
- Le mot-clé `const` permet à Flutter et Dart d'optimiser l'allocation mémoire : si plusieurs éoliennes ou repères partagent la position par défaut `(0.0, 0.0)`, une seule instance sera conservée en mémoire vive.
- Les paramètres sont nommés et initialisés à `0.0`, ce qui évite les erreurs de valeur nulle (`null`).

### B. Égalité structurelle avec `Equatable`
```dart
@override
List<Object?> get props => [latitude, longitude];
```
- En géolocalisation, deux coordonnées sont identiques si et seulement si leur `latitude` et leur `longitude` coïncident.
- Grâce à `Equatable`, `Position(latitude: 48.85, longitude: 2.35) == Position(latitude: 48.85, longitude: 2.35)` renverra `true`.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez la présence du fichier dans [lib/features/domain/entities/position.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/position.dart).
2. Lancez l'analyse statique :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur sur le fichier `position.dart`.
   - L'entité géographique est prête à être intégrée par composition dans notre entité `Turbine`.

Passons à l'[Étape 8 : Couche Domaine — L'Entité Turbine](file:///d:/PROJECT2026/windenergy/tutoriel/08_couche_domaine_entite_turbine.md).
