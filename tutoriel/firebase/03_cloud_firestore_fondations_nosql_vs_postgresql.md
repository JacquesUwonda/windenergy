# Firebase Étape 3 : Cloud Firestore — Les Fondations NoSQL vs PostgreSQL

Dans cette étape, nous allons concevoir la base de données de notre application avec **Cloud Firestore**. C'est ici que s'opère le changement de paradigme le plus important : **passer de la pensée relationnelle SQL (PostgreSQL) à la pensée orientée documents NoSQL**.

---

## 1. Comprendre l'architecture de Cloud Firestore

Dans une base NoSQL comme Firestore, il n'y a :
- **Pas de tables**
- **Pas de colonnes fixes**
- **Pas de clés étrangères (`FOREIGN KEY`)**
- **Pas de jointures (`JOIN`)**

Firestore est structuré uniquement autour de deux concepts :
1. **Les Documents** : Un document est un dictionnaire de paires clé/valeur (très similaire à un objet JSON). Sa taille maximale est de 1 Mo.
2. **Les Collections** : Une collection est un conteneur ordonné de documents. Une collection ne peut contenir que des documents, jamais de valeurs brutes directement.

```text
Collection "turbines"
    ├── Document "turbine_101"
    │       ├── custom_name: "Éolienne Nord 01"
    │       ├── serial_number: "SN-VESTAS-X9"
    │       ├── profile_id: "user_abc123"
    │       └── latitude: 48.85
    └── Document "turbine_102"
            └── ...
```

---

## 2. Transposition de `windenergy.sql` vers Firestore

Comment traduire notre schéma relationnel [windenergy.sql](file:///d:/PROJECT2026/windenergy/windenergy.sql) en structure Firestore ?

| Table SQL Supabase | Collection Firestore | Structure du Document |
| :--- | :--- | :--- |
| `public.profiles` | Collection `profiles` | ID du document = `userId`. Champs : `full_name`, `email`, `created_at`. |
| `public.turbines` | Collection `turbines` | ID auto ou entier. Champs : `serial_number`, `profile_id`, `custom_name`, `latitude`, `longitude`, `activated`, `last_seen_at`. |
| `public.pairing_codes` | Collection `pairing_codes` | Champs : `turbine_id`, `code_hash`, `expires_at`, `validated_at`. |
| `public.telemetries` | Collection `telemetries` (ou sous-collection `turbines/{id}/telemetries`) | Champs : `turbine_id`, `power_w`, `rotation_rpm`, `orientation_deg`, `recorded_at`. |
| `public.telemetries_hourly` | Collection `telemetries_hourly` | Champs : `turbine_id`, `avg_power_w`, `max_power_w`, `energy_wh`, `bucket_start`. |

---

## 3. Les Opérations CRUD dans Firestore vs Supabase

### A. Insérer des données (Create)

- **Supabase (SQL)** :
  ```dart
  await supabaseClient.from("turbines").insert({
    "serial_number": "SN-01",
    "profile_id": userId,
  });
  ```
- **Firestore (NoSQL)** :
  ```dart
  // Option 1 : ID automatique généré par Firestore
  await FirebaseFirestore.instance.collection("turbines").add({
    "serial_number": "SN-01",
    "profile_id": userId,
  });

  // Option 2 : ID spécifique imposé (ex: pour le profil avec userId)
  await FirebaseFirestore.instance.collection("profiles").doc(userId).set({
    "full_name": fullName,
    "email": email,
  });
  ```

---

### B. Lire des données avec filtre (Read)

- **Supabase (SQL)** :
  ```dart
  final list = await supabaseClient
      .from("turbines")
      .select()
      .eq("profile_id", userId);
  ```
- **Firestore (NoSQL)** :
  ```dart
  final querySnapshot = await FirebaseFirestore.instance
      .collection("turbines")
      .where("profile_id", isEqualTo: userId)
      .get();

  for (var doc in querySnapshot.docs) {
    print("Turbine: ${doc.data()['custom_name']}");
  }
  ```

---

### C. Mettre à jour des données (Update)

- **Supabase (SQL)** :
  ```dart
  await supabaseClient.from("turbines").update({
    "custom_name": "Nouveau nom",
  }).eq("id", turbineId);
  ```
- **Firestore (NoSQL)** :
  ```dart
  await FirebaseFirestore.instance
      .collection("turbines")
      .doc(turbineId.toString())
      .update({
    "custom_name": "Nouveau nom",
  });
  ```

---

### D. Supprimer des données (Delete)

- **Supabase (SQL)** :
  ```dart
  await supabaseClient.from("turbines").delete().eq("id", turbineId);
  ```
- **Firestore (NoSQL)** :
  ```dart
  await FirebaseFirestore.instance
      .collection("turbines")
      .doc(turbineId.toString())
      .delete();
  ```

---

## 4. La grande différence des dates : `Timestamp` vs `DateTime`

Attention à ce piège classique pour débutant en Flutter :
- **Supabase** renvoie les dates sous forme de chaînes de caractères au standard ISO 8601 (ex: `"2026-11-28T14:00:00Z"`). On utilise donc `DateTime.parse(map['created_at'])`.
- **Firestore** possède son propre type natif nommé **`Timestamp`**. Dans la `map`, `created_at` n'est pas une `String`, mais un objet `Timestamp` !
  Pour le convertir en `DateTime` Dart :
  ```dart
  final timestamp = map['created_at'] as Timestamp?;
  final dateTime = timestamp?.toDate(); // Méthode toDate() de Timestamp
  ```

---

## 5. Attendu final

Pour valider cette étape :
1. Vous maîtrisez le vocabulaire NoSQL de Firestore (Collection, Document, Field).
2. Vous savez filtrer avec `.where("champ", isEqualTo: valeur).get()`.
3. Vous avez compris la conversion indispensable de `Timestamp.toDate()` vers `DateTime`.

Passons à la sécurisation de notre base dans l'[Étape 4 : Sécurité des Données — Firestore Security Rules vs Supabase RLS](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/04_securite_firestore_rules_vs_supabase_rls.md).
