import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/myapp.dart';
import 'package:projectapp/firebase_options.dart';

import 'package:auth_repository/auth_repository.dart';
import 'package:projectapp/simple_bloc_observer.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //Bloc.observer = SimpleBlocObserver();
  runApp(MyApp(FirebaseUserRepo()));
}
