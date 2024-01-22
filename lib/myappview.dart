import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectapp/bussines/authentication_bloc/authentication_bloc.dart';
import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
import 'package:projectapp/presentation/auth/welcome_screen.dart';
import 'package:projectapp/presentation/home/home.dart';
import 'package:go_router/go_router.dart';
// class MyAppView extends StatelessWidget {
//   const MyAppView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//         title: 'Firebase Auth',
//         theme: ThemeData(
//           colorScheme: const ColorScheme.light(
//               background: Color.fromARGB(239, 254, 237, 202),
//               onBackground: Colors.black,
//               primary: Color.fromRGBO(206, 147, 216, 1),
//               onPrimary: Color.fromARGB(255, 107, 82, 82),
//               secondary: Color.fromRGBO(244, 143, 177, 1),
//               onSecondary: Colors.white,
//               tertiary: Color.fromRGBO(255, 204, 128, 1),
//               error: Colors.red,
//               outline: Color(0xFF424242)),
//         ),
//         home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
//             builder: (context, state) {
//           if (state.status == AuthenticationStatus.authenticated) {
//             return BlocProvider(
//               create: (context) => SignInBloc(
//                   userRepository:
//                       context.read<AuthenticationBloc>().userRepository),
//               child: HomeScreen(),
//             );
//           } else {
//             return const WelcomeScreen();
//           }
//         }));
//   }
// }
class MyAppView extends StatelessWidget {
  const MyAppView({super.key});

  @override
  Widget build(BuildContext context) {
    final _router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: 'home',
          builder: (context, state) {
            final authState = context.read<AuthenticationBloc>().state;
            if (authState.status == AuthenticationStatus.authenticated) {
              return HomeScreen();
            } else {
              return const WelcomeScreen();
            }
          },
          routes: [
            GoRoute(
              path: 'recipe/:id',
              builder: (context, state) {
                final recipeId = state.pathParameters['id']!;
                final recipe = Recipe(
                    id: recipeId,
                    title: 'Przepis',
                    description: 'Szczegóły przepisu');
                return RecipeDetailScreen(recipe: recipe);
              },
            ),
            // Dodaj inne trasy w razie potrzeby
          ],
        ),
      ],
    );

    return MaterialApp.router(
      routerConfig: _router,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: const ColorScheme.light(
            background: Color.fromARGB(239, 254, 237, 202),
            onBackground: Colors.black,
            primary: Color.fromRGBO(206, 147, 216, 1),
            onPrimary: Color.fromARGB(255, 107, 82, 82),
            secondary: Color.fromRGBO(244, 143, 177, 1),
            onSecondary: Colors.white,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242)),
      ),
    );
  }
}

// class MyAppView extends StatelessWidget {
//   const MyAppView({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final router = GoRouter(
//       routes: [
//         GoRoute(
//           path: '/',
//           builder: (context, state) => HomeScreen(),
//         ),
//         GoRoute(
//           path: '/signin',
//           builder: (context, state) => const WelcomeScreen(),
//         ),
//         // Definicje innych tras...
//       ],
//     );

//     return BlocListener<AuthenticationBloc, AuthenticationState>(
//       listener: (context, state) {
//         if (state.status == AuthenticationStatus.authenticated) {
//           router.go('/'); // Przekieruj do HomeScreen
//         } else {
//           router.go('/signin'); // Przekieruj do WelcomeScreen
//         }
//       },
//       child: MaterialApp.router(
//         title: 'Firebase Auth',
//         routeInformationParser: router.routeInformationParser,
//         routerDelegate: router.routerDelegate,
//         routerConfig:
//         theme: ThemeData(
//           colorScheme: const ColorScheme.light(
//               background: Color.fromARGB(239, 254, 237, 202),
//               onBackground: Colors.black,
//               primary: Color.fromRGBO(206, 147, 216, 1),
//               onPrimary: Color.fromARGB(255, 107, 82, 82),
//               secondary: Color.fromRGBO(244, 143, 177, 1),
//               onSecondary: Colors.white,
//               tertiary: Color.fromRGBO(255, 204, 128, 1),
//               error: Colors.red,
//               outline: Color(0xFF424242)),
//         ),
//       ),
//     );
//   }
// }
