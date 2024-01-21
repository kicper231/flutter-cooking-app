import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:projectapp/firebase_options.dart';
import 'features/app/presentation/pages/app.dart';
// import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
// import 'package:firebase_ui_auth/firebase_ui_auth.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: App(),
    );
  }
}













// class AuthGate extends StatelessWidget {
//   const AuthGate({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return StreamBuilder<User?>(
//       stream: FirebaseAuth.instance.authStateChanges(),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) {
//           return SignInScreen(
//             providers: [EmailAuthProvider()],
//             headerBuilder: (context, constraints, shrinkOffset) {
//               return Padding(
//                 padding: const EdgeInsets.all(20),
//                 child: AspectRatio(
//                   aspectRatio: 1,
//                   child: Image.asset('flutterfire_300x.png'),
//                 ),
//               );
//             },
//             subtitleBuilder: (context, action) {
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 8.0),
//                 child: action == AuthAction.signIn
//                     ? const Text('Welcome to FlutterFire, please sign in!')
//                     : const Text('Welcome to Flutterfire, please sign up!'),
//               );
//             },
//             footerBuilder: (context, action) {
//               return const Padding(
//                 padding: EdgeInsets.only(top: 16),
//                 child: Text(
//                   'By signing in, you agree to our terms and conditions.',
//                   style: TextStyle(color: Colors.grey),
//                 ),
//               );
//             },
//           );
//         }

//         return const HomeScreen();
//       },
//     );
//   }
// }

// typedef HeaderBuilder = Widget Function(
//   BuildContext context,
//   BoxConstraints constraints,
//   double shrinkOffset,
// );

// class HomeScreen extends StatelessWidget {
//   const HomeScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       color: Colors.red,
//       width: 200,
//       height: 100,
//     );
//   }
// }
