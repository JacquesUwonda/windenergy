# Étape 6 : Couche Domaine — L'Entité PairingCode (Enregistrement)

Dans une station d'énergie éolienne, connecter son terminal ou son compte technicien à une éolienne industrielle ne se fait pas au hasard. Pour des raisons de sécurité évidentes, l'opérateur doit passer par un processus d'**enregistrement et d'appairage**.

Dans cette étape, nous allons étudier et concevoir l'entité `PairingCode` telle qu'elle existe dans `lib/features/domain/entities/pairing_code.dart`.

---

## 1. Comprendre le cycle d'enregistrement d'une éolienne

Pourquoi a-t-on besoin d'un code d'appairage ?
1. Chaque éolienne physique du parc possède un identifiant unique (`turbineId`, un entier).
2. Pour enregistrer une éolienne et commencer à la monitorer, l'opérateur (`userId`) reçoit ou génère un code sécurisé.
3. Pour éviter qu'un tiers intercepte ce code en clair, on manipule son empreinte sécurisée (`codeHash`).
4. Ce code a une durée de vie limitée : il est créé à une date (`createdAt`), expire à une date précise (`expiresAt`), et devient effectif au moment de la validation (`validatedAt`).
5. Son statut est suivi via une énumération claire : `valid` ou `invalid` (`PairingStatus`).

---

## 2. Le code source exact : `lib/features/domain/entities/pairing_code.dart`

Ouvrez ou créez le fichier [lib/features/domain/entities/pairing_code.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/pairing_code.dart) :

```dart
import "package:equatable/equatable.dart";

enum PairingStatus{ valid, invalid}

class PairingCode extends Equatable{
  final String userId;
  final int turbineId;
  final String codeHash;
  final PairingStatus status;
  final DateTime? expiresAt;
  final DateTime? createdAt;
  final DateTime? validatedAt;

  const PairingCode({
    this.userId = "",
    this.turbineId = 0,
    this.codeHash = "",
    this.status = PairingStatus.invalid,
    this.expiresAt,
    this.createdAt,
    this.validatedAt
  });

  @override
  List<Object?> get props => [userId, turbineId, codeHash, createdAt];
}
```

---

## 3. Analyse détaillée pour débutant

### A. L'énumération : `enum PairingStatus { valid, invalid }`
- **Pourquoi un enum ?** En tant qu'ingénieur, manipuler des chaînes de caractères comme `"valide"`, `"invalide"` ou des booléens `true/false` est une source majeure de bogues silencieux. Un `enum` définit un ensemble fermé de valeurs reconnues par le compilateur Dart.
- Si le statut est `valid`, l'appairage peut être initié. S'il est `invalid`, l'application refuse l'accès à la commande de la turbine.

### B. Les attributs et la gestion temporelle
- `final int turbineId` : Le numéro d'identification de l'éolienne ciblée (par exemple turbine 1, turbine 2).
- `final String userId` : L'identifiant de l'utilisateur qui enregistre la turbine.
- `final String codeHash` : La signature cryptographique du code secret.
- `final DateTime? expiresAt`, `createdAt`, `validatedAt` : 
  - Le `?` signifie que ces variables peuvent être `null` (Null Safety). Par exemple, tant que le code n'a pas été validé avec succès par le serveur, `validatedAt` reste `null`.

### C. Le constructeur constant `const PairingCode(...)`
- Comme pour `Profile`, tous les champs sont `final`.
- Les valeurs par défaut (`this.status = PairingStatus.invalid`, `this.turbineId = 0`, etc.) garantissent qu'on ne se retrouve jamais avec une variable indéfinie qui ferait crasher l'application.

### D. La surcharge d'égalité : `props`
```dart
@override
List<Object?> get props => [userId, turbineId, codeHash, createdAt];
```
- Pourquoi inclure `createdAt` ? Deux tentatives d'enregistrement pour la même turbine et le même utilisateur mais à des dates différentes représentent deux sessions d'enregistrement distinctes. `Equatable` prend ces 4 propriétés pour vérifier si deux objets `PairingCode` représentent le même enregistrement.

---

## 4. Attendu final

Pour valider cette étape :
1. Assurez-vous que le fichier est présent et fidèle dans [lib/features/domain/entities/pairing_code.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/pairing_code.dart).
2. Lancez l'analyse du projet depuis le terminal :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - La commande s'exécute sans erreur (`No issues found!`).
   - Le socle métier du projet **WindEnergy** est parfaitement en place avec :
     - La gestion unifiée des résultats et erreurs : `lib/utils/result.dart`.
     - L'entité utilisateur / technicien : `lib/features/domain/entities/profile.dart`.
     - L'entité d'enregistrement d'éolienne : `lib/features/domain/entities/pairing_code.dart`.

Vous avez complété avec succès toutes les étapes correspondant aux fichiers actuellement construits dans le projet !
