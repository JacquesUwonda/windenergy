# Étape 5 : Couche Domaine — L'Entité Profile

Nous entrons maintenant au cœur de la **Clean Architecture** avec la couche **Domaine (Domain Layer)**. Dans cette étape, nous allons créer l'entité représentant le technicien ou opérateur du parc éolien : le `Profile`.

---

## 1. Qu'est-ce qu'une "Entité" dans le Domain ?

Une **Entité (Entity)** est un objet qui encapsule les données et règles métier fondamentales de notre application. 

### Règle d'or de l'Entité :
- L'entité doit être **purement Dart**. Elle ne doit importer aucun paquet de base de données (pas de Supabase, pas de Firebase, pas de SQLite) et aucun widget graphique (`material.dart`).
- Elle représente la vérité métier, peu importe d'où proviennent les données.
- Elle doit être **immuable** (`immutable`) : ses propriétés sont déclarées `final`. Pour modifier une information, on crée une nouvelle instance de l'objet plutôt que de muter l'objet existant. Cela évite les effets de bord imprévisibles dans l'application.

---

## 2. Conception de l'entité `Profile`

Pour gérer notre parc éolien, chaque utilisateur connecté possède :
- Un identifiant unique (`id` sous forme d'UUID provenant du système d'authentification).
- Une adresse email (`email`).
- Son nom complet (`fullName`).
- La date de création de son compte (`createdAt`).

---

## 3. Création du fichier `lib/features/domain/entities/profile.dart`

Créez le fichier [lib/features/domain/entities/profile.dart](file:///d:/PROJECT2026/windenergy/lib/features/domain/entities/profile.dart) et insérez le code suivant :

```dart
import "package:equatable/equatable.dart";

/// [Profile] représente l'identité d'un technicien ou superviseur
/// de la station d'énergie éolienne.
class Profile extends Equatable {
  final String id;
  final String email;
  final String fullName;
  final DateTime? createdAt;

  /// Constructeur constant avec valeurs par défaut.
  ///
  /// L'utilisation de [const] permet à Dart d'optimiser la mémoire
  /// en réutilisant les mêmes instances immuables.
  const Profile({
    this.id = "",
    this.email = "",
    this.fullName = "",
    this.createdAt,
  });

  /// [props] définit les attributs utilisés pour tester l'égalité entre deux profils.
  ///
  /// Ici, nous considérons que l'identité d'un profil repose avant tout sur son [id].
  @override
  List<Object?> get props => [id];
}
```

---

## 4. Explications détaillées du code

### 1. `class Profile extends Equatable`
En héritant de `Equatable`, nous déléguons la gestion de l'opérateur d'égalité `==`.

### 2. Pourquoi `const Profile(...)` ?
Le mot-clé `const` devant un constructeur est une optimisation majeure de Dart :
- Si vous instanciez deux fois `const Profile(id: "tech_01")` à différents endroits de votre application, la machine virtuelle Dart n'allouera qu'un seul emplacement mémoire.
- Cela accélère considérablement l'exécution et allège la consommation de mémoire vive de l'application mobile.

### 3. Les paramètres nommés entre accolades `{ ... }`
En Dart, placer les paramètres du constructeur entre accolades `{ this.id = "" }` permet :
- De les rendre **nommés** lors de l'appel : `Profile(id: "123", email: "jean@eolien.fr")`. C'est infiniment plus lisible que des paramètres positionnels où l'on risque d'inverser l'email et le nom sans s'en rendre compte.
- De leur attribuer des **valeurs par défaut** (ici des chaînes vides `""`), évitant ainsi les erreurs `null pointer` inattendues si un champ n'est pas renseigné.

### 4. `DateTime? createdAt`
Le point d'interrogation `?` indique que la propriété est "nullable" (Système de *Sound Null Safety* de Dart). Si la date de création n'est pas encore connue lors de la saisie d'un profil, `createdAt` peut valoir `null` en toute sécurité sans provoquer de crash.

### 5. `List<Object?> get props => [id];`
Pour `Profile`, l'identifiant technique `id` suffit pour garantir l'unicité du compte technicien. Deux objets `Profile` ayant le même `id` seront reconnus comme représentant le même utilisateur.

---

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que le fichier existe et qu'il est syntaxiquement correct :
   ```bash
   flutter analyze
   ```
2. **Ce que vous devez observer :**
   - Aucune erreur de compilation n'est levée.
   - Votre entité `Profile` est prête à être manipulée par nos repositories et ViewModels.

Passons maintenant à la modélisation de l'enregistrement de l'éolienne dans l'[Étape 6 : Couche Domaine — L'Entité PairingCode](file:///d:/PROJECT2026/windenergy/tutoriel/06_couche_domaine_entite_pairing_code.md).
