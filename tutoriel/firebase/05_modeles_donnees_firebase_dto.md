# Firebase Étape 5 : Modèles de Données DTO Firebase

Dans le projet, sous `lib/features/data/services/supabase/models/`, nous avons créé les modèles DTO spécifiques à Supabase (`TurbineSupabaseModel`, `ProfileSupabaseModel`...).

Dans cette étape, nous allons créer en miroir les modèles DTO spécifiques à Firebase dans un nouveau dossier :
`lib/features/data/services/firebase/models/`.

---

## 1. Pourquoi des modèles DTO distincts pour Firebase ?

Une des plus grandes erreurs en architecture est d'essayer de forcer un seul modèle à gérer les particularités de plusieurs bases différentes.

### Les spécificités de Firebase à gérer :
1. **Les Documents Firestore** : Firestore fournit un objet `DocumentSnapshot<Map<String, dynamic>>` qui contient à la fois les données (`snapshot.data()`) et l'identifiant du document (`snapshot.id`).
2. **Le type `Timestamp`** : Comme vu à l'étape 3, les dates dans Firestore sont des objets `Timestamp` de Google Cloud, et non des chaînes ISO 8601 comme dans Supabase.
3. **Les types numériques** : En Firestore, les entiers et les décimaux sont stockés sous forme de `num`, nécessitant des conversions sûres `.toDouble()` ou `.toInt()`.

---

## 2. Le Modèle `PositionFirebaseModel`

Créez le fichier [lib/features/data/services/firebase/models/position_firebase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/firebase/models/position_firebase_model.dart) :

```dart
import 'package:windenergy/features/domain/entities/position.dart';

class PositionFirebaseModel extends Position {
  const PositionFirebaseModel({super.latitude, super.longitude});

  /// Construit un objet à partir d'une sous-map ou de champs directs
  factory PositionFirebaseModel.fromMap({required Map<String, dynamic> map}) {
    return PositionFirebaseModel(
      latitude: (map["latitude"] as num?)?.toDouble() ?? 0.0,
      longitude: (map["longitude"] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "latitude": latitude,
      "longitude": longitude,
    };
  }
}
```

---

## 3. Le Modèle `ProfileFirebaseModel`

Créez le fichier [lib/features/data/services/firebase/models/profile_firebase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/firebase/models/profile_firebase_model.dart) :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windenergy/features/domain/entities/profile.dart';

class ProfileFirebaseModel extends Profile {
  const ProfileFirebaseModel({
    super.id,
    super.email,
    super.fullName,
    super.createdAt,
  });

  factory ProfileFirebaseModel.fromMap({required Map<String, dynamic> map, String id = ""}) {
    DateTime? parsedCreatedAt;
    
    // Gestion du type Timestamp spécifique à Firestore
    if (map["created_at"] is Timestamp) {
      parsedCreatedAt = (map["created_at"] as Timestamp).toDate();
    } else if (map["created_at"] is String) {
      parsedCreatedAt = DateTime.tryParse(map["created_at"]);
    }

    return ProfileFirebaseModel(
      id: id.isNotEmpty ? id : (map["id"] ?? ""),
      email: map["email"] ?? "",
      fullName: map["full_name"] ?? "",
      createdAt: parsedCreatedAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "email": email,
      "full_name": fullName,
      "created_at": createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
    };
  }
}
```

---

## 4. Le Modèle `PairingCodeFirebaseModel`

Créez le fichier [lib/features/data/services/firebase/models/pairing_code_firebase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/firebase/models/pairing_code_firebase_model.dart) :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';

class PairingCodeFirebaseModel extends PairingCode {
  const PairingCodeFirebaseModel({
    super.turbineId,
    super.codeHash,
    super.createdAt,
    super.expiresAt,
    super.status,
    super.validatedAt,
  });

  factory PairingCodeFirebaseModel.fromMap({required Map<String, dynamic> map}) {
    DateTime? parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    final expires = parseDate(map["expires_at"]);
    final validated = parseDate(map["validated_at"]);
    
    // Calcul dynamique du statut en miroir de la vue SQL pairing_codes_with_status
    PairingStatus calculatedStatus = PairingStatus.invalid;
    if (validated == null && expires != null && expires.isAfter(DateTime.now())) {
      calculatedStatus = PairingStatus.valid;
    } else if (map["status"] == "valid" || map["status"] == "VALID") {
      calculatedStatus = PairingStatus.valid;
    }

    return PairingCodeFirebaseModel(
      turbineId: (map["turbine_id"] as num?)?.toInt() ?? 0,
      codeHash: map["code_hash"] ?? "",
      createdAt: parseDate(map["created_at"]),
      expiresAt: expires,
      validatedAt: validated,
      status: calculatedStatus,
    );
  }
}
```

---

## 5. Le Modèle `TurbineFirebaseModel`

Créez le fichier [lib/features/data/services/firebase/models/turbine_firebase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/firebase/models/turbine_firebase_model.dart) :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:windenergy/features/data/services/firebase/models/position_firebase_model.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';

class TurbineFirebaseModel extends Turbine {
  const TurbineFirebaseModel({
    super.id,
    super.customName,
    super.position,
    super.serialNumber,
    super.createdAt,
    super.status,
  });

  factory TurbineFirebaseModel.fromMap({required Map<String, dynamic> map, dynamic id}) {
    DateTime? parseDate(dynamic value) {
      if (value is Timestamp) return value.toDate();
      if (value is String) return DateTime.tryParse(value);
      return null;
    }

    // Gestion de l'id : dans Firestore l'id peut être un int ou l'ID document String
    int parsedId = 0;
    if (id is int) {
      parsedId = id;
    } else if (id is String) {
      parsedId = int.tryParse(id) ?? (map["id"] as num?)?.toInt() ?? 0;
    } else if (map["id"] != null) {
      parsedId = (map["id"] as num).toInt();
    }

    // Calcul du statut actif/inactif basé sur last_seen_at (analogue à la vue SQL turbines_with_status)
    TurbineStatus computedStatus = TurbineStatus.inactive;
    final lastSeen = parseDate(map["last_seen_at"]);
    if (lastSeen != null) {
      final differenceInSeconds = DateTime.now().difference(lastSeen).inSeconds;
      if (differenceInSeconds < 30) {
        computedStatus = TurbineStatus.active;
      }
    } else if (map["status"] == "active" || map["status"] == "ACTIVE") {
      computedStatus = TurbineStatus.active;
    }

    return TurbineFirebaseModel(
      id: parsedId,
      customName: map["custom_name"] ?? "",
      serialNumber: map["serial_number"] ?? "",
      position: PositionFirebaseModel.fromMap(map: map),
      createdAt: parseDate(map["created_at"]),
      status: computedStatus,
    );
  }
}
```

---

## 6. Attendu final

Pour valider cette étape :
1. Créez le répertoire `lib/features/data/services/firebase/models/`.
2. Placez-y les 4 fichiers de modèles DTO Firebase.
3. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
4. **Ce que vous devez observer :**
   - Aucune erreur de typage.
   - Vos modèles sont prêts à transformer les documents Firestore bruts en entités du Domaine.

Passons maintenant à l'implémentation complète du service dans l'[Étape 6 : Implémentation Concrète de FirebaseService](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/06_implementation_concrete_firebase_service.md).
