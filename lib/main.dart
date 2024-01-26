import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:projectapp/myapp.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projectapp/firebase_options.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:projectapp/simple_bloc_observer.dart';
import 'package:recipe_repository/recipe_repository.dart';

// import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Locales.init(['en', 'fa', 'ps']);
  Bloc.observer = SimpleBlocObserver();
  runApp(Localeapp(FirebaseUserRepo(), FirebaseRecipeRepository()));
}

class Localeapp extends StatelessWidget {
  const Localeapp(this.userRepository, this.recipeRepository, {super.key});
  final UserRepository userRepository;
  final RecipeRepository recipeRepository;
  @override
  Widget build(BuildContext context) {
    return LocaleBuilder(
      builder: (locale) => MaterialApp(
        title: 'Flutter Locales',
        localizationsDelegates: Locales.delegates,
        supportedLocales: Locales.supportedLocales,
        locale: locale,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: MyApp(
          userRepository: userRepository,
          recipeRepository: recipeRepository,
        ),
      ),
    );
  }
}
