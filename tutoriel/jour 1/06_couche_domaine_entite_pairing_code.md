# Étape 6 : Couche Domaine — L'Entité PairingCode (Enregistrement)

Dans une station d'énergie éolienne, connecter son terminal mobile à une éolienne industrielle nécessite une procédure d'appairage sécurisée. L'éolienne génère un code secret temporaire qu'un opérateur doit valider pour en prendre le contrôle.

Dans cette étape, nous allons étudier et reproduire l'entité `PairingCode` telle qu'elle est définie dans `lib/features/domain/entities/pairing_code.dart`.

---

## 1. Comprendre le cycle de vie du code d'appairage

Dans notre base de données PostgreSQL / Supabase (schéma `windenergy.sql`) :
1. Chaque code est associé à une éolienne physique spécifique (`turbineId`).
2. Pour ne pas exposer le code en clair, on stocke son empreinte alphanumérique sécurisée (`codeHash`).
3. Le code possède une date de création (`createdAt`) et une date d'expiration (`expiresAt`), fixée à **15 minutes** après sa génération.
4. Tant que le code n'est pas utilisé et que la date d'expiration n'est pas dépassée, son statut est `PairingStatus.valid`.
5. Dès que le code est validé ou expiré, il passe en `PairingStatus.invalid` et sa date de validation (`validatedAt`) est enregistrée.

> **Note d'architecture :** Remarquez que `userId` ne fait pas partie de l'entité `PairingCode`. En effet, le code d'appairage appartient à la turbine physique (`turbine_id`). C'est la table `turbines` qui relie l'éolienne à l'utilisateur (`profile_id`). Cette séparation garantit une base de données normalisée et sans duplication.

---

## 2. Le code source : `lib/features/domain/entities/pairing_code.dart`

Ouvrez ou créez le fichier [lib/features/domain/entities/pairing_code.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/pairing_code.dart) :

```dart
import "package:equatable/equatable.dart";

enum PairingStatus { valid, invalid }

class PairingCode extends Equatable {
  final int turbineId;
  final String codeHash;
  final PairingStatus status;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? validatedAt;

  const PairingCode({
    this.turbineId = 0,
    this.codeHash = "",
    this.status = PairingStatus.invalid,
    this.expiresAt,
    this.createdAt,
    this.validatedAt,
  });

  @override
  List<Object?> get props => [turbineId, codeHash, createdAt];
}
```

---

## 3. Analyse des concepts pour débutant

### A. L'énumération : `enum PairingStatus { valid, invalid }`
- Utiliser un `enum` au lieu de chaînes de caractères (`"valid"`, `"invalid"`) évite les erreurs de typographie et permet au compilateur Dart de valider l'exhaustivité des cas dans vos structures conditionnelles.

### B. Les attributs et la Null Safety
- `final int turbineId` : Référence numérique de la turbine cible.
- `final String codeHash` : La chaîne alphanumérique du code secret.
- `final DateTime? expiresAt`, `createdAt`, `validatedAt` : Déclarés avec le suffixe `?` (nullable). Par exemple, tant que le code n'a pas été validé, `validatedAt` vaut `null`.

### C. La surcharge d'égalité avec `Equatable`
```dart
@override
List<Object?> get props => [turbineId, codeHash, createdAt];
```
- Deux instances de `PairingCode` ayant le même `turbineId`, le même `codeHash` et créées au même instant `createdAt` sont considérées par Dart comme représentant le même événement d'appairage.

---

## 4. Attendu final

Pour valider cette étape :
1. Vérifiez que [lib/features/domain/entities/pairing_code.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/pairing_code.dart) est conforme.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur sur le fichier.
   - Les entités de base du Jour 1 (`Profile` et `PairingCode`) sont posées avec rigueur.

Vous avez terminé le **Jour 1** ! Passons au **Jour 2** avec l'[Étape 7 : Couche Domaine — L'Entité Position](file:///d:/PROJECT2026/windenergy/tutoriel/jour%202/07_couche_domaine_entite_position.md).
