# Étape 9 : Couche Domaine — Télémétrie et Monitoring

Maintenant que nos éoliennes sont enregistrées et géolocalisées, il est temps de modéliser le cœur opérationnel de l'application : **le monitoring énergétique**.

Dans cette étape, nous allons étudier et concevoir les deux entités de mesures :
1. `Telemetry` : La télémétrie instantanée (temps réel).
2. `TelemetryHourly` : Les données historiques agrégées par heure.

---

## 1. Pourquoi séparer la télémétrie instantanée et la télémétrie horaire ?

Dans les systèmes industriels de supervision (SCADA) :
- **La mesure instantanée (`Telemetry`)** arrive à haute fréquence (toutes les quelques secondes). Elle sert à afficher les cadrans en direct : rotation des pales, angle de giration face au vent et puissance électrique produite à la seconde.
- **La mesure agrégée (`TelemetryHourly`)** condense les milliers de points de données reçus sur une heure : puissance moyenne, puissance maximale, vitesse moyenne de rotation (RPM) et total d'énergie électrique injectée en Watt-heure (`energyWh`). Elle sert à afficher les graphiques d'historique et à calculer le rendement de la station.

---

## 2. L'Entité `Telemetry` (Temps Réel)

Ouvrez ou créez le fichier [lib/features/domain/entities/telemetry.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry.dart) :

```dart
import 'package:equatable/equatable.dart';

class Telemetry extends Equatable {
  final int turbineId;
  final double powerW;
  final double rotationDeg;
  final double orientationDeg;
  final DateTime? recordedAt;
  final DateTime? receivedAt;

  const Telemetry({
    this.turbineId = 0,
    this.powerW = 0.0,
    this.rotationDeg = 0.0,
    this.orientationDeg = 0.0,
    this.recordedAt,
    this.receivedAt,
  });

  @override
  List<Object?> get props => [turbineId, recordedAt];
}
```

### Analyse des champs de télémétrie :
- `turbineId` : Référence l'éolienne concernée par la mesure.
- `powerW` : Puissance électrique instantanée générée en Watts (W).
- `rotationDeg` : Angle de rotation instantané des pales (de 0° à 360°), utile pour animer la rotation de l'éolienne sur l'écran !
- `orientationDeg` : Angle de direction de la nacelle par rapport au Nord pour capter le vent optimal.
- `recordedAt` : Heure exacte de la mesure horodatée par le capteur de la turbine.
- `receivedAt` : Heure de réception du paquet réseau sur le serveur (permet de surveiller la latence réseau).

---

## 3. L'Entité `TelemetryHourly` (Historique et Statistiques)

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
- `maxPowerW` : Pic de puissance atteint durant l'heure (utile pour détecter les surtensions).
- `avgPowerW` : Puissance moyenne produite durant l'heure.
- `avgRpm` : Vitesse moyenne de rotation du rotor en tours par minute.
- `energyWh` : Énergie cumulée produite sur l'heure (en Watt-heure).
- `bucketStart` : Début du créneau horaire (ex: 2026-11-21 14:00:00).
- `props => [turbineId, bucketStart]` : Deux enregistrements pour la même turbine sur le même créneau horaire correspondent au même paquet statistique.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que les deux fichiers existent :
   - [lib/features/domain/entities/telemetry.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry.dart)
   - [lib/features/domain/entities/telemetry_hourly.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/telemetry_hourly.dart)
2. Exécutez :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Zéro avertissement.
   - Votre domaine dispose désormais de toute la modélisation mathématique et physique nécessaire pour superviser la station éolienne.

Passons aux contrats d'accès aux données dans l'[Étape 10 : Couche Domaine — Contrats des Repositories](file:///d:/PROJECT2026/windenergy/tutoriel/10_couche_domaine_contrats_repositories.md).
