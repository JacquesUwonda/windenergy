# Firebase Étape 6 : Implémentation Concrète de `FirebaseService`

Nous arrivons au cœur technique de l'intégration : l'écriture de la classe `FirebaseService` qui implémente **strictement** notre contrat [DbService](file:///d:/PROJECT2026/windenergy/lib/features/data/services/db_service.dart), en parfaite symétrie avec `SupabaseService`.

---

## 1. Création du fichier `lib/features/data/services/firebase/firebase_service.dart`

Créez le fichier [lib/features/data/services/firebase/firebase_service.dart](file:///d:/PROJECT2026/windenergy/lib/features/data/services/firebase/firebase_service.dart) :

```dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:windenergy/features/data/services/db_service.dart';
import 'package:windenergy/features/data/services/firebase/models/pairing_code_firebase_model.dart';
import 'package:windenergy/features/data/services/firebase/models/profile_firebase_model.dart';
import 'package:windenergy/features/data/services/firebase/models/turbine_firebase_model.dart';
import 'package:windenergy/features/domain/entities/pairing_code.dart';
import 'package:windenergy/features/domain/entities/position.dart';
import 'package:windenergy/features/domain/entities/profile.dart';
import 'package:windenergy/features/domain/entities/turbine.dart';
import 'package:windenergy/utils/exceptions.dart';
import 'package:windenergy/utils/result.dart';

class FirebaseService extends DbService {
  final FirebaseAuth auth;
  final FirebaseFirestore firestore;

  FirebaseService({
    required this.auth,
    required this.firestore,
  });

  // ==========================================
  // AUTHENTIFICATION
  // ==========================================

  @override
  FutureResult<String> signIn({String email = "", String password = ""}) async {
    try {
      // Comparatif Supabase : supabaseClient.auth.signInWithPassword(...)
      final userCredential = await auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return Success<String>(value: userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      String reason = "";
      switch (e.code) {
        case "user-not-found":
        case "wrong-password":
        case "invalid-credential":
          reason = "invalid credentials";
          break;
        case "user-disabled":
          reason = "user disabled";
          break;
      }
      throw ServerException(reason: reason);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<String> signUp({
    String fullName = "",
    String email = "",
    String password = "",
  }) async {
    try {
      // Comparatif Supabase : supabaseClient.auth.signUp(..., data: {"full_name": fullName})
      final userCredential = await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      final userId = userCredential.user!.uid;

      // Dans Supabase, un trigger SQL créait le profil.
      // Dans Firebase, nous écrivons directement le document dans la collection 'profiles' :
      await firestore.collection("profiles").doc(userId).set({
        "id": userId,
        "email": email,
        "full_name": fullName,
        "created_at": FieldValue.serverTimestamp(),
      });

      return Success<String>(value: userId);
    } on FirebaseAuthException catch (e) {
      String reason = "";
      switch (e.code) {
        case "email-already-in-use":
          reason = "email address already exists in the system";
          break;
      }
      throw ServerException(reason: reason);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> signOut() async {
    try {
      // Comparatif Supabase : supabaseClient.auth.signOut()
      await auth.signOut();
      return Success();
    } catch (e) {
      throw ServerException(reason: "");
    }
  }

  // ==========================================
  // PROFIL TECHNICIEN
  // ==========================================

  @override
  FutureResult<Profile> readProfile({String userId = ""}) async {
    try {
      // Comparatif Supabase : supabaseClient.from("profiles").select().eq("id", userId).single()
      final docSnapshot = await firestore.collection("profiles").doc(userId).get();
      if (!docSnapshot.exists || docSnapshot.data() == null) {
        throw ServerException(reason: "profile not found");
      }
      final profile = ProfileFirebaseModel.fromMap(
        map: docSnapshot.data()!,
        id: docSnapshot.id,
      );
      return Success(value: profile);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  // ==========================================
  // GESTION ET MONITORING DES ÉOLIENNES
  // ==========================================

  @override
  FutureResult<int> readCount({String userId = ""}) async {
    try {
      // Comparatif Supabase : supabaseClient.from("turbines").select().eq("profile_id", userId).count()
      // Firestore utilise la méthode performante .count() pour ne pas charger les documents
      final aggregateQuery = await firestore
          .collection("turbines")
          .where("profile_id", isEqualTo: userId)
          .count()
          .get();
      return Success<int>(value: aggregateQuery.count ?? 0);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<double> readTotalPowerW({String userId = ""}) async {
    try {
      // Comparatif Supabase : lecture de la vue SQL "total_power_view"
      // Dans Firestore, nous pouvons calculer la somme des puissances des turbines du profil :
      final snapshot = await firestore
          .collection("turbines")
          .where("profile_id", isEqualTo: userId)
          .get();

      double total = 0.0;
      for (final doc in snapshot.docs) {
        final data = doc.data();
        total += (data["current_power_w"] as num?)?.toDouble() ?? 0.0;
      }
      return Success(value: total);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<List<Turbine>> readTurbines({String userId = ""}) async {
    try {
      // Comparatif Supabase : supabaseClient.from("turbines_with_status").select().eq("user_id", userId)
      final querySnapshot = await firestore
          .collection("turbines")
          .where("profile_id", isEqualTo: userId)
          .get();

      final list = <Turbine>[];
      for (final doc in querySnapshot.docs) {
        list.add(TurbineFirebaseModel.fromMap(map: doc.data(), id: doc.id));
      }
      return Success(value: list);
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
      // Comparatif Supabase : insert into turbines ... select id
      final docRef = await firestore.collection("turbines").add({
        "serial_number": serialNumber,
        "profile_id": userId,
        "custom_name": customName,
        "latitude": position.latitude,
        "longitude": position.longitude,
        "activated": false,
        "created_at": FieldValue.serverTimestamp(),
        "last_seen_at": FieldValue.serverTimestamp(),
      });

      // Dans Firestore, l'ID généré est un hash alphanumérique String.
      // Pour respecter notre contrat int, on extrait un hashcode ou un identifiant séquentiel :
      final newTurbineId = docRef.id.hashCode.abs();
      return Success<int>(value: newTurbineId);
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<PairingCode> readPairingCode({int turbineId = 0}) async {
    try {
      // Comparatif Supabase : from("pairing_codes_with_status").select().eq("turbineId", turbineId)
      final querySnapshot = await firestore
          .collection("pairing_codes")
          .where("turbine_id", isEqualTo: turbineId)
          .limit(1)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw ServerException(reason: "no pairing code found");
      }

      final pairingCode = PairingCodeFirebaseModel.fromMap(
        map: querySnapshot.docs.first.data(),
      );
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
      // Comparatif Supabase : from("turbines").update(...).eq("turbine_id", turbineId)
      final query = await firestore
          .collection("turbines")
          .where("id", isEqualTo: turbineId)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.update({
          "custom_name": customName,
          "latitude": position.latitude,
          "longitude": position.longitude,
        });
      }
      return Success();
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }

  @override
  FutureResult<dynamic> deleteTurbine({int turbineId = 0}) async {
    try {
      // Comparatif Supabase : from("turbines").delete().eq("id", turbineId)
      final query = await firestore
          .collection("turbines")
          .where("id", isEqualTo: turbineId)
          .get();

      if (query.docs.isNotEmpty) {
        await query.docs.first.reference.delete();
      }
      return Success();
    } catch (e) {
      throw ServerException(reason: "an error occurred on the server");
    }
  }
}
```

---

## 2. Attendu final

Pour valider cette étape :
1. Créez `lib/features/data/services/firebase/firebase_service.dart`.
2. Lancez l'analyse statique :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur de compilation.
   - `FirebaseService` respecte rigoureusement 100% des signatures de `DbService`.

Voyons maintenant comment changer de backend en une seule ligne dans l'[Étape 7 : Interchangeabilité Totale et Injection avec GetIt](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/07_interchangeabilite_et_injection_dans_get_it.md).
