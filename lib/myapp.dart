import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:go_router/go_router.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:projectapp/bussines/update_user_data_bloc/update_user_data_bloc_bloc.dart';
import 'package:projectapp/presentation/home/addrecipe.dart';
import 'package:projectapp/presentation/recipedails/recipedatails.dart';
import 'package:provider/provider.dart';
import 'bussines/authentication_bloc/authentication_bloc.dart';
import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
import 'package:projectapp/presentation/auth/welcome_screen.dart';
import 'package:projectapp/presentation/home/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// class MyApp extends StatelessWidget {
//   final UserRepository userRepository;
//   const MyApp(this.userRepository, {super.key});

//   @override
//   Widget build(BuildContext context) {
//     return RepositoryProvider<AuthenticationBloc>(
//       create: (context) => AuthenticationBloc(userRepository: userRepository),
//       child: const MyAppView(),
//     );
//   }
// }

/////
/////
/////
/////
/////
/////
/////
/////

class MyApp extends StatelessWidget {
  final UserRepository userRepository;

  MyApp(this.userRepository, {super.key});

  @override
  Widget build(BuildContext context) {
    final router = GoRouter(
        routes: [
          GoRoute(
            path: '/login',
            builder: (context, state) => const WelcomeScreen(),
          ),
          GoRoute(
              path: '/',
              name: 'home',
              builder: (context, state) => RecipesPage(),
              routes: [
                GoRoute(
                  path: 'recipe/:id',
                  builder: (context, state) {
                    final recipeId = state.pathParameters['id']!;
                    return RecipeDetailPage(recipeId: recipeId);
                  },
                ),
                GoRoute(
                  path: 'recipeadd',
                  builder: (context, state) {
                    // final recipeId = state.pathParameters['id']!;
                    return (AddRecipe());
                  },
                )
              ]),
        ],
        redirect: (BuildContext context, GoRouterState state) {
          final authBloc = context.read<AuthenticationBloc>();
          final isAuthenticated =
              authBloc.state.status == AuthenticationStatus.authenticated;
          final currentPath = state.uri.path;

          /// nie jest to efektywne ale nie mialem czasu tego ogarnac xdd

          if (!isAuthenticated &&
              (currentPath != '/login' || currentPath == '/')) {
            return '/login';
          }

          if (isAuthenticated && currentPath == '/login') {
            return '/';
          }

          return currentPath;
        });
    return MultiProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository),
        ),
        BlocProvider<SignInBloc>(
          create: (context) => SignInBloc(userRepository: userRepository),
        ),
        BlocProvider<UpdateUserDataBloc>(
          create: (contex) =>
              UpdateUserDataBloc(userRepository: userRepository),
        ),
        BlocProvider<MyUserBloc>(
          create: (context) => MyUserBloc(
              myUserRepository:
                  context.read<AuthenticationBloc>().userRepository)
            ..add(GetMyUser(
                myUserId: context.read<AuthenticationBloc>().state.user!.uid)),
        ),
      ],
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          router
              .refresh(); // nie wiem kiedy ten refresh dokladnie sie uruchamia czasem to  jest to losowe
        },
        child: MaterialApp.router(
          routerConfig: router,
          title: 'Firebase Auth',
          theme: ThemeData(
              colorScheme: const ColorScheme.light(
                  background: Color.fromARGB(255, 245, 245, 245),
                  onBackground: Colors.black,
                  primary: Color.fromARGB(255, 243, 204, 255),
                  //primary: Color.fromARGB(255, 9, 69, 67),
                  onPrimary: Color.fromARGB(255, 255, 255, 255),
                  secondary: Color.fromRGBO(206, 147, 216, 1),
                  onSecondary: Colors.white,
                  tertiary: Color.fromRGBO(206, 147, 216, 1),
                  error: Colors.red,
                  outline: Color(0xFF424242)),
              cardColor: Colors.white),
        ),
      ),
    );
  }
}
