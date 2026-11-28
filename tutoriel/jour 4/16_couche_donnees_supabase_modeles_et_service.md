# Étape 16 : Couche Données — Modèles Supabase et SupabaseService

Maintenant que notre base de données PostgreSQL est configurée et sécurisée sur Supabase, nous allons connecter notre code Dart à ce backend.

Dans cette étape, nous allons étudier :
1. Les modèles de données Supabase (DTO) situés dans `lib/features/data/services/supabase/models/`.
2. L'implémentation complète de `DbService` avec `SupabaseService` dans `lib/features/data/services/supabase/supabase_service.dart`.

---

## 1. Pourquoi créer des Modèles dédiés à Supabase ?

Les tables Supabase renvoient des dictionnaires `Map<String, dynamic>` avec des clés en format SQL (`snake_case`, ex: `turbine_id`, `custom_name`, `created_at`).

Pour respecter la Clean Architecture, nos entités du Domaine restent pures. Nous créons des **modèles DTO (Data Transfer Objects)** qui héritent de ces entités et implémentent un constructeur factory nommé `.fromMap(...)` :

```text
Entité Pure (Domain) : Turbine
         ▲
         │ hérite de
Modèle Supabase (Data) : TurbineSupabaseModel.fromMap(map: json)
```

---

## 2. Les 4 Modèles Supabase

### A. `PositionSupabaseModel`
Créez [lib/features/data/services/supabase/models/position_supabase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/supabase/models/position_supabase_model.dart) :
```dart
import 'package:windenergy/features/domain/entities/position.dart';

class PositionSupabaseModel extends Position {
  const PositionSupabaseModel({super.latitude, super.longitude});

  factory PositionSupabaseModel.fromMap({required Map<String, dynamic> map}) {
    return PositionSupabaseModel(
      latitude: map["latitude"] as double,
      longitude: map["longitude"] as double,
    );
  }
}
```

### B. `ProfileSupabaseModel`
Créez [lib/features/data/services/supabase/models/profile_supabase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/supabase/models/profile_supabase_model.dart) :
```dart
import 'package:windenergy/features/domain/entities/profile.dart';

class ProfileSupabaseModel extends Profile {
  const ProfileSupabaseModel({super.id, super.email, super.fullName, super.createdAt});

  factory ProfileSupabaseModel.fromMap({required Map<String, dynamic> map}) {
    return ProfileSupabaseModel(
      email: map["email"],
      fullName: map["full_name"],
      createdAt: DateTime.parse(map["created_at"]),
      id: map["id"],
    );
  }
}
```

### C. `PairingCodeSupabaseModel`
Créez [lib/features/data/services/supabase/models/pairing_code_supabase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/supabase/models/pairing_code_supabase_model.dart) :
```dart
import 'package:windenergy/features/domain/entities/pairing_code.dart';

class PairingCodeSupabaseModel extends PairingCode {
  const PairingCodeSupabaseModel({
    super.turbineId,
    super.codeHash,
    super.createdAt,
    super.expiresAt,
    super.status,
    super.validatedAt,
  });

  factory PairingCodeSupabaseModel.fromMap({required Map<String, dynamic> map}) {
    return PairingCodeSupabaseModel(
      turbineId: map["turbine_id"] as int,
      codeHash: map["code_hash"],
      createdAt: DateTime.parse(map["created_at"]),
      expiresAt: DateTime.parse(map["expires_at"]),
      status: map["status"] == "valid" ? PairingStatus.valid : PairingStatus.invalid,
      validatedAt: map["validated_at"] != null ? DateTime.tryParse(map["validated_at"]) : null,
    );
  }
}
```

### D. `TurbineSupabaseModel`
Créez [lib/features/data/services/supabase/models/turbine_supabase_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/supabase/models/turbine_supabase_model.dart) :
```dart
import 'package:windenergy/features/data/services/supabase/models/position_supabase_model.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';

class TurbineSupabaseModel extends Turbine {
  const TurbineSupabaseModel({
    super.id,
    super.customName,
    super.position,
    super.serialNumber,
    super.createdAt,
    super.status,
  });

  factory TurbineSupabaseModel.fromMap({required Map<String, dynamic> map}) {
    return TurbineSupabaseModel(
      id: map["turbine_id"] as int,
      customName: map["custom_name"] as String,
      position: PositionSupabaseModel.fromMap(map: map),
      serialNumber: map["serial_number"] as String,
      createdAt: DateTime.parse(map["created_at"]),
      status: map["status"] == "active" ? TurbineStatus.active : TurbineStatus.inactive,
    );
  }
}
```

---

## 3. L'implémentation `SupabaseService`

Ouvrez ou créez [lib/features/data/services/supabase/supabase_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/supabase/supabase_service.dart) :

```dart
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/data/services/supabase/models/pairing_code_supabase_model.dart';
import 'package:windenergy/features/data/services/supabase/models/profile_supabase_model.dart';
import 'package:windenergy/features/data/services/supabase/models/turbine_supabase_model.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class SupabaseService extends DbService {
  final SupabaseClient supabaseClient;

  SupabaseService({required this.supabaseClient});

  @override
  FutureResult<String> signIn({String email = "", String password = ""}) async {
    try {
      final response = await supabaseClient.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return Success<String>(value: response.session!.user.id);
    } on AuthException catch (e) {
      String reason = "";
      switch (e.code) {
        case "invalid_credentials":
          reason = "invalid credentials";
      }
      throw ServerException(reason: reason);
    }
  }

  @override
  FutureResult<String> signUp({
    String fullName = "",
    String email = "",
    String password = "",
  }) async {
    try {
      final response = await supabaseClient.auth.signUp(
        email: email,
        password: password,
        data: {"full_name": fullName},
      );
      return Success<String>(value: response.session!.user.id);
    } on AuthException catch (e) {
      String reason = "";
      switch (e.code) {
        case "email_exists":
          reason = "email address already exists in the system";
      }
      throw ServerException(reason: reason);
    }
  }

  @override
  FutureResult<dynamic> signOut() async {
    try {
      await supabaseClient.auth.signOut();
      return Success();
    } catch (e) {
      throw ServerException(reason: "");
    }
  }

  @override
  FutureResult<Profile> readProfile({String userId = ""}) async {
    try {
      final response = await supabaseClient
          .from("profiles")
          .select()
          .eq("id", userId)
          .single();
      final profile = ProfileSupabaseModel.fromMap(map: response);
      return Success(value: profile);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<int> readCount({String userId = ""}) async {
    try {
      final response = await supabaseClient
          .from("turbines")
          .select()
          .eq("profile_id", userId)
          .count();
      return Success<int>(value: response.count);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<double> readTotalPowerW({String userId = ""}) async {
    try {
      final response = await supabaseClient
          .from("total_power_view")
          .select()
          .eq("profile_id", userId)
          .single();
      final totalPowerW = double.parse(response["power_w"]);
      return Success(value: totalPowerW);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<List<Turbine>> readTurbines({String userId = ""}) async {
    try {
      final responseList = await supabaseClient
          .from("turbines_with_status")
          .select()
          .eq("user_id", userId);
      final ret = <Turbine>[];
      for (final response in responseList) {
        ret.add(TurbineSupabaseModel.fromMap(map: response));
      }
      return Success(value: ret);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<int> createTurbine({
    String userId = "",
    String serialNumber = "",
    String customName = "",
    Position position = const Position(),
  }) async {
    try {
      final response = await supabaseClient.from("turbines").insert({
        "serial_number": serialNumber,
        "profile_id": userId,
        "custom_name": customName,
        "latitude": position.latitude,
        "longitude": position.longitude,
      }).select().single();
      final newTurbineId = response["id"] as int;
      return Success<int>(value: newTurbineId);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) async {
    try {
      final response = await supabaseClient
          .from("pairing_codes_with_status")
          .select()
          .eq("turbineId", turbineId)
          .single();
      final pairingCode = PairingCodeSupabaseModel.fromMap(map: response);
      return Success(value: pairingCode);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> readTurbineActivation() async {
    try {
      return Success();
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> updateTurbine({
    int turbineId = 0,
    String customName = "",
    Position position = const Position(),
  }) async {
    try {
      await supabaseClient.from("turbines").update({
        "custom_name": customName,
        "latitude": position.latitude,
        "longitude": position.longitude,
      }).eq("turbine_id", turbineId);
      return Success();
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) async {
    try {
      await supabaseClient.from("turbines").delete().eq("id", turbineId);
      return Success();
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }
}
```

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que les modèles Supabase et `SupabaseService` sont bien créés dans `lib/features/data/services/supabase/`.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur de compilation.
   - Votre application possède désormais une implémentation fonctionnelle complète de sa source de données Cloud avec Supabase !

Passons à la préparation de l'interface utilisateur dans l'[Étape 17 : Introduction à la Couche UI et ViewModel](file:///d:/PROJECT2026/windenergy/tutoriel/jour%204/17_introduction_couche_ui_et_viewmodel.md).
