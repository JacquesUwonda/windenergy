# Étape 17 : Introduction à la Couche UI et aux ViewModels (MVVM)

Nous avons posé le Domaine, les Services, la Base de données Supabase et les Repositories. Il est maintenant temps d'aborder la **Couche Présentation** dans `lib/features/ui/`.

Dans cette étape, nous allons comprendre :
1. L'organisation du dossier `lib/features/ui/`.
2. Le rôle d'un widget générique comme `CustomTextFormField`.
3. L'architecture de l'écran de connexion : `LoginPage` et son `LoginPageViewModel`.

---

## 1. Organisation de `lib/features/ui/`

La couche de présentation est organisée en deux sous-dossiers :
- **`core/widgets/`** : Les composants graphiques réutilisables à travers toute l'application (champs de formulaire, boutons personnalisés, jauges, cartes éoliennes).
- **`pages/`** : Les pages complètes de l'application (Login, Dashboard, Enregistrement de turbine, etc.).

Dans chaque dossier de page (ex: `pages/login/`), nous trouvons le binôme inséparable de MVVM :
1. **`login_page.dart` (La Vue)** : Contient les widgets Flutter (`Scaffold`, `Form`, `TextFormField`, boutons). Elle ne fait qu'afficher et réagir aux changements.
2. **`login_page_view_model.dart` (Le ViewModel)** : Gère l'état de la page (chargement, message d'erreur, succès) et appelle le repository (`AuthenticationRepository`).

---

## 2. Le Widget de Saisie Réutilisable : `CustomTextFormField`

Dans une application d'ingénierie, les formulaires de connexion et de saisie d'éolienne doivent avoir un design unifié et cohérent.

Créez le fichier [lib/features/ui/core/widgets/custom_text_form_field.dart](file:///d:/PROJECT2026/windenergy/lib/features/ui/core/widgets/custom_text_form_field.dart) :

```dart
import 'package:flutter/material.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  final Widget? suffixIcon;

  const CustomTextFormField({
    super.key,
    this.controller,
    this.labelText = "",
    this.hintText = "",
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
    );
  }
}
```

### Pourquoi encapsuler `TextFormField` ?
- Au lieu de répéter la décoration (`OutlineInputBorder`, rayon de bordure, couleur de fond) sur chaque écran, tout est centralisé ici.
- Si le design de l'application change demain, vous modifiez uniquement ce widget !

---

## 3. Le ViewModel de Connexion : `LoginPageViewModel`

Dans le pattern MVVM, le ViewModel hérite généralement de `ChangeNotifier` pour pouvoir émettre des notifications d'état à la vue (`notifyListeners()`).

Créez [lib/features/ui/pages/login/login_page_view_model.dart](file:///d:/PROJECT2026/windenergy/lib/features/ui/pages/login/login_page_view_model.dart) :

```dart
import 'package:flutter/foundation.dart';
import 'package:windenergy/features/domain/repositories/authentication_repository.dart';
import 'package:windenergy/utils/result.dart';

enum LoginState { initial, loading, success, error }

class LoginPageViewModel extends ChangeNotifier {
  final AuthenticationRepository authenticationRepository;

  LoginState _state = LoginState.initial;
  String _errorMessage = "";

  LoginPageViewModel({required this.authenticationRepository});

  LoginState get state => _state;
  String get errorMessage => _errorMessage;
  bool get isLoading => _state == LoginState.loading;

  Future<bool> login({required String email, required String password}) async {
    _state = LoginState.loading;
    _errorMessage = "";
    notifyListeners();

    final result = await authenticationRepository.signIn(
      email: email,
      password: password,
    );

    if (result is Success) {
      _state = LoginState.success;
      notifyListeners();
      return true;
    } else if (result is Error) {
      _state = LoginState.error;
      _errorMessage = result.reason;
      notifyListeners();
      return false;
    }

    _state = LoginState.initial;
    notifyListeners();
    return false;
  }
}
```

### Analyse pédagogique du ViewModel :
- **Indépendance** : Le ViewModel ne connaît aucun widget Flutter. Il dépend uniquement de `AuthenticationRepository` (notre interface abstraite).
- **Gestion des états réactifs** :
  1. `_state = LoginState.loading` : L'écran affiche un spinner de chargement.
  2. `notifyListeners()` : Préviens la vue de se redessiner.
  3. Selon le `result` (Success ou Error), l'état final est mis à jour.

---

## 4. La Vue de Connexion : `LoginPage`

Créez [lib/features/ui/pages/login/login_page.dart](file:///d:/PROJECT2026/windenergy/lib/features/ui/pages/login/login_page.dart) :

```dart
import 'package:flutter/material.dart';
import 'package:windenergy/features/ui/core/widgets/custom_text_form_field.dart';
import 'package:windenergy/features/ui/pages/login/login_page_view_model.dart';

class LoginPage extends StatefulWidget {
  final LoginPageViewModel viewModel;

  const LoginPage({super.key, required this.viewModel});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _onLoginPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await widget.viewModel.login(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      if (!mounted) return;

      if (!success && widget.viewModel.errorMessage.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(widget.viewModel.errorMessage),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WindEnergy - Supervision'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: ListenableBuilder(
            listenable: widget.viewModel,
            builder: (context, _) {
              return Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wind_power, size: 72, color: Colors.blueAccent),
                    const SizedBox(height: 16),
                    const Text(
                      'Connexion Technicien',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    CustomTextFormField(
                      controller: _emailController,
                      labelText: 'Email Professionnel',
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined),
                      validator: (value) =>
                          (value == null || !value.contains('@')) ? 'Email invalide' : null,
                    ),
                    const SizedBox(height: 16),
                    CustomTextFormField(
                      controller: _passwordController,
                      labelText: 'Mot de passe',
                      obscureText: true,
                      prefixIcon: const Icon(Icons.lock_outline),
                      validator: (value) =>
                          (value == null || value.length < 6) ? 'Mot de passe trop court' : null,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: widget.viewModel.isLoading ? null : _onLoginPressed,
                        child: widget.viewModel.isLoading
                            ? const CircularProgressIndicator.adaptive()
                            : const Text('Se connecter'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
```

---

## 5. Attendu final

Pour valider cette étape :
1. Vérifiez que `custom_text_form_field.dart`, `login_page_view_model.dart` et `login_page.dart` sont créés et compilent sans erreur.
2. Lancez l'analyse :
   ```bash
   flutter analyze
   ```
3. **Ce que vous devez observer :**
   - Aucune erreur détectée.
   - L'écran de connexion et son ViewModel sont prêts à communiquer avec le repository et Supabase pour authentifier les techniciens du parc éolien.

Félicitations ! Vous maîtrisez désormais l'intégralité du cycle de vie logiciel de **WindEnergy**, de la base de données SQL jusqu'à l'interface réactive Flutter !
