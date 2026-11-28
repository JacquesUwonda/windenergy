# Cours Complet Firebase pour Flutter (Projet WindEnergy)

Bienvenue dans ce module spécial dédié à **Firebase** ! 

Dans le projet **WindEnergy**, nous avons d'abord implémenté notre backend avec **Supabase** (PostgreSQL relationnel). Cependant, dans le monde professionnel, un développeur mobile Flutter accompli doit être capable de travailler avec les deux géants du Backend-as-a-Service (BaaS) : **Supabase** et **Firebase** (Google Cloud).

Grâce à notre **Clean Architecture** articulée autour de l'interface `DbService`, vous allez découvrir comment intégrer Firebase sans toucher à une seule ligne de votre couche Domaine ni de votre interface utilisateur.

---

## 🧭 Sommaire du Module Firebase

1. [Étape 0 : Introduction à Firebase et Grand Comparatif Firebase vs Supabase](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/00_introduction_et_comparatif_firebase_vs_supabase.md)  
   *Histoire, écosystème Google, NoSQL vs SQL relationnel, avantages, inconvénients et liens officiels.*

2. [Étape 1 : Setup de la Console Firebase et Configuration avec FlutterFire CLI](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/01_setup_firebase_console_et_flutterfire_cli.md)  
   *Création du projet sur la Console Firebase, installation de `firebase-tools` et `flutterfire_cli`, génération automatique de `firebase_options.dart` et initialisation.*

3. [Étape 2 : Firebase Authentication vs Supabase Auth](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/02_firebase_authentication_vs_supabase_auth.md)  
   *Prise en main de `FirebaseAuth`, flux de connexion/inscription, gestion des sessions, et conversion de `FirebaseAuthException` en `ServerException`.*

4. [Étape 3 : Cloud Firestore — Les Fondations NoSQL vs PostgreSQL](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/03_cloud_firestore_fondations_nosql_vs_postgresql.md)  
   *Comprendre la modélisation en Collections et Documents, requêtes, filtres, limitations du NoSQL et transposition du schéma de WindEnergy.*

5. [Étape 4 : Sécurité des Données — Firestore Security Rules vs Supabase RLS](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/04_securite_firestore_rules_vs_supabase_rls.md)  
   *Écriture des règles de sécurité `firestore.rules` pour protéger les éoliennes, les profils et les codes d'appairage en miroir des politiques RLS SQL.*

6. [Étape 5 : Modèles de Données DTO Firebase](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/05_modeles_donnees_firebase_dto.md)  
   *Gestion des `DocumentSnapshot`, conversion des `Timestamp` Firestore en `DateTime`, création de `ProfileFirebaseModel`, `TurbineFirebaseModel`, etc.*

7. [Étape 6 : Implémentation Concrète de `FirebaseService`](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/06_implementation_concrete_firebase_service.md)  
   *Écriture complète de `FirebaseService extends DbService` en miroir de `SupabaseService` avec comparatif de code ligne par ligne.*

8. [Étape 7 : Interchangeabilité Totale et Injection avec GetIt](file:///d:/PROJECT2026/windenergy/tutoriel/firebase/07_interchangeabilite_et_injection_dans_get_it.md)  
   *Le triomphe de la Clean Architecture : basculer entre Supabase et Firebase en changeant une seule ligne d'enregistrement dans `GetIt` !*

---

## 🔗 Ressources officielles à toujours garder sous la main
- [Portail officiel FlutterFire](https://firebase.flutter.dev/)
- [Documentation Firebase Officielle](https://firebase.google.com/docs)
- [Console Firebase](https://console.firebase.google.com/)
- [Documentation Cloud Firestore Flutter](https://firebase.flutter.dev/docs/firestore/overview)
- [Documentation Firebase Auth Flutter](https://firebase.flutter.dev/docs/auth/overview)
