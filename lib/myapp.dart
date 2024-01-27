import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:auth_repository/auth_repository.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:go_router/go_router.dart';
import 'package:projectapp/bussines/create_recipe_bloc/create_recipe_bloc.dart';
import 'package:projectapp/bussines/get_recipe_bloc/get_recipe_bloc.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:projectapp/bussines/recipe_bloc/recipe_bloc.dart';
import 'package:projectapp/bussines/update_user_data_bloc/update_user_data_bloc_bloc.dart';
import 'package:projectapp/presentation/home/addrecipe.dart';
import 'package:projectapp/presentation/recipedails/recipedatails.dart';
import 'package:provider/provider.dart';
import 'package:recipe_repository/recipe_repository.dart';
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
  final RecipeRepository recipeRepository;

  MyApp(
      {required this.userRepository,
      required this.recipeRepository,
      super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        RepositoryProvider<AuthenticationBloc>(
          create: (context) =>
              AuthenticationBloc(userRepository: userRepository),
        ),
        RepositoryProvider<RecipeRepository>(
          create: (context) => recipeRepository,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Twoja Aplikacja',
        theme: ThemeData(
          colorScheme: const ColorScheme.light(
            background: Colors.white,
            onBackground: Colors.black,
            // primary: Color.fromRGBO(206, 147, 216, 1),
            primary: Color.fromARGB(255, 240, 203, 254),
            onPrimary: Color.fromARGB(255, 255, 255, 255),
            secondary: Color.fromRGBO(244, 143, 177, 1),
            onSecondary: Colors.white,
            tertiary: Color.fromRGBO(255, 204, 128, 1),
            error: Colors.red,
            outline: Color(0xFF424242),
          ),
        ),
        home: BlocBuilder<AuthenticationBloc, AuthenticationState>(
          builder: (context, state) {
            if (state.status == AuthenticationStatus.authenticated) {
              return MultiBlocProvider(
                providers: [
                  BlocProvider(
                    create: (context) => SignInBloc(
                      userRepository: userRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => UpdateUserDataBloc(
                      userRepository: userRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => RecipeBloc(
                      recipeRepository: recipeRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) =>
                        MyUserBloc(myUserRepository: userRepository)
                          ..add(GetMyUser(
                              myUserId: context
                                  .read<AuthenticationBloc>()
                                  .state
                                  .user!
                                  .uid)),
                  ),
                  BlocProvider(
                    create: (context) => CreateRecipeBloc(
                      recipeRepository: recipeRepository,
                    ),
                  ),
                  BlocProvider(
                    create: (context) => GetRecipeBloc(
                      recipeRepository: recipeRepository,
                    ),
                  ),
                ],
                child: RecipesPage(),
              );
            } else {
              return const WelcomeScreen();
            }
          },
        ),
      ),
    );
  }
}
