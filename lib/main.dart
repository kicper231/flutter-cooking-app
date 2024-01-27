import 'package:easy_localization/easy_localization.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  await EasyLocalization.ensureInitialized();

  runApp(
    EasyLocalization(
      supportedLocales: [Locale('en', 'US'), Locale('de', 'DE')],
      path: 'assets/translations',
      fallbackLocale: Locale('en', 'US'),
      child: Localeapp(FirebaseUserRepo(), FirebaseRecipeRepository()),
    ),
  );
}

class Localeapp extends StatelessWidget {
  final UserRepository userRepository;
  final RecipeRepository recipeRepository;

  Localeapp(this.userRepository, this.recipeRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Locales',
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: MyApp(
        userRepository: userRepository,
        recipeRepository: recipeRepository,
      ),
    );
  }
}
