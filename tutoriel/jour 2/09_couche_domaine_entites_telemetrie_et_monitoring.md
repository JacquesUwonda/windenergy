# Étape 9 : Couche Domaine — Entités Télémétrie et Monitoring

Maintenant que nos éoliennes sont modélisées et géolocalisées, nous devons concevoir les structures de données pour le **monitoring opérationnel**. Dans une station d'énergie éolienne, des capteurs mesurent en permanence l'énergie produite et l'état mécanique du rotor.

Dans cette étape, nous allons étudier et concevoir les deux entités de mesures :
1. `Telemetry` : La télémétrie instantanée (temps réel).
2. `TelemetryHourly` : Les données statistiques agrégées par heure.

---

## 1. Pourquoi distinguer la télémétrie instantanée et la télémétrie horaire ?

Dans un système industriel SCADA :
- **La mesure instantanée (`Telemetry`)** est envoyée à haute fréquence par l'automate de l'éolienne. Elle sert à afficher les jauges en direct dans l'application mobile : puissance actuelle générée et vitesse de rotation des pales.
- **La mesure agrégée (`TelemetryHourly`)** condense les milliers de mesures reçues au cours d'une heure : puissance moyenne, pic de puissance maximale, vitesse de rotation moyenne, et énergie totale produite en Watt-heure (`energyWh`). Elle sert à afficher les graphiques de production et à calculer le bilan énergétique.

---

## 2. L'Entité `Telemetry` (Temps Réel)

Ouvrez ou créez le fichier [lib/features/domain/entities/telemetry.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry.dart) :

```dart
import 'package:equatable/equatable.dart';

class Telemetry extends Equatable {
  final int turbineId;
  final double powerW;
  final double rotationRpm;
  final double orientationDeg;
  final DateTime? recordedAt;
  final DateTime? receivedAt;

  const Telemetry({
    this.turbineId = 0,
    this.powerW = 0.0,
    this.rotationRpm = 0.0,
    this.orientationDeg = 0.0,
    this.recordedAt,
    this.receivedAt,
  });

  @override
  List<Object?> get props => [turbineId, recordedAt];
}
```

### Analyse des attributs :
- `turbineId` : Référence numérique de la turbine concernée.
- `powerW` : Puissance électrique instantanée produite en Watts (W).
- `rotationRpm` : Vitesse de rotation des pales en tours par minute (RPM - *Rotations Per Minute*).
- `orientationDeg` : Angle d'orientation de la nacelle par rapport au Nord (0° à 360°).
- `recordedAt` : Date et heure précises de la mesure au niveau du capteur.
- `receivedAt` : Date et heure de réception par le serveur central.

---

## 3. L'Entité `TelemetryHourly` (Statistiques et Énergie)

Ouvrez ou créez le fichier [lib/features/domain/entities/telemetry_hourly.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry_hourly.dart) :

```dart
import 'package:equatable/equatable.dart';

class TelemetryHourly extends Equatable {
  final int turbineId;
  final double maxPowerW;
  final double avgPowerW;
  final double avgRpm;
  final double energyWh;
  final DateTime? bucketStart;

  const TelemetryHourly({
    this.turbineId = 0,
    this.maxPowerW = 0.0,
    this.avgPowerW = 0.0,
    this.avgRpm = 0.0,
    this.energyWh = 0.0,
    this.bucketStart,
  });

  @override
  List<Object?> get props => [turbineId, bucketStart];
}
```

### Analyse des indicateurs statistiques :
- `maxPowerW` : Puissance de crête (maximale) atteinte au cours de l'heure.
- `avgPowerW` : Puissance moyenne produite pendant l'heure.
- `avgRpm` : Vitesse de rotation moyenne du rotor.
- `energyWh` : Quantité totale d'électricité produite sur le créneau en Watt-heure ($E = P_{moyenne} \times 1\text{h}$).
- `bucketStart` : Début du créneau d'une heure (ex: 14:00:00).
- `props => [turbineId, bucketStart]` : Deux agrégations pour la même turbine sur la même tranche horaire représentent la même tranche statistique.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que [lib/features/domain/entities/telemetry.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry.dart) et [lib/features/domain/entities/telemetry_hourly.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry_hourly.dart) sont conformes.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur sur ces fichiers.
   - Les entités de télémétrie reflètent fidèlement la physique de la station éolienne.

Passons aux contrats d'accès aux données dans l'[Étape 10 : Couche Domaine — Contrats des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/10_couche_domaine_contrats_repositories.md).
