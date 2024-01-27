import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_locales/flutter_locales.dart';

import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectapp/bussines/my_user_bloc/my_user_bloc.dart';
import 'package:projectapp/bussines/sign_in_bloc/sign_in_bloc.dart';
import 'package:projectapp/bussines/update_user_data_bloc/update_user_data_bloc_bloc.dart';

class Mydrawer extends StatefulWidget {
  Mydrawer({super.key});

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<UpdateUserDataBloc, UpdateUserDataState>(
      listener: (context, state) {
        if (state is UploadPictureSuccess) {
          setState(() {
            context.read<MyUserBloc>().state.user!.picture = state.userImage;
          });
        }
      },
      child: BlocBuilder<MyUserBloc, MyUserState>(
        builder: (context, state) {
          if (state.status == MyUserStatus.loading) {
            // Wyświetl pasek ładowania, gdy status to loading
            return Center(child: CircularProgressIndicator());
          } else if (state.status == MyUserStatus.success) {
            return Column(
              mainAxisSize: MainAxisSize.max,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  height: 200,
                  color: Theme.of(context).primaryColor, // Kolor tła kontenera
                  child: Column(
                    mainAxisAlignment:
                        MainAxisAlignment.center, // Wyśrodkowanie zawartości
                    // mainAxisSize: MainAxisSize.max,
                    children: [
                      SizedBox(
                        height: 40,
                      ),
                      state.user!.picture != null
                          ? GestureDetector(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 500,
                                    maxWidth: 500,
                                    imageQuality: 40);
                                if (image != null) {
                                  CroppedFile? croppedFile =
                                      await ImageCropper().cropImage(
                                    sourcePath: image.path,
                                    aspectRatio: const CropAspectRatio(
                                        ratioX: 1, ratioY: 1),
                                    aspectRatioPresets: [
                                      CropAspectRatioPreset.square
                                    ],
                                    uiSettings: [
                                      AndroidUiSettings(
                                          toolbarTitle: 'Cropper',
                                          toolbarColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          toolbarWidgetColor: Colors.white,
                                          initAspectRatio:
                                              CropAspectRatioPreset.original,
                                          lockAspectRatio: false),
                                      IOSUiSettings(
                                        title: 'Cropper',
                                      ),
                                    ],
                                  );
                                  if (croppedFile != null) {
                                    setState(() {
                                      context.read<UpdateUserDataBloc>().add(
                                          UploadPicture(
                                              image.path,
                                              context
                                                  .read<MyUserBloc>()
                                                  .state
                                                  .user!
                                                  .userId));
                                    });
                                  }
                                }
                              },
                              child: CircleAvatar(
                                radius: 50.0, // Promień okręgu
                                backgroundColor: Colors.black26,
                                child: ClipOval(
                                  child: Image.network(
                                    state.user!.picture!,
                                    fit: BoxFit.fill,
                                    width: 100,
                                    height: 100,
                                  ),
                                ),
                              ),
                            )
                          : GestureDetector(
                              onTap: () async {
                                final ImagePicker picker = ImagePicker();
                                final XFile? image = await picker.pickImage(
                                    source: ImageSource.gallery,
                                    maxHeight: 500,
                                    maxWidth: 500,
                                    imageQuality: 40);
                                if (image != null) {
                                  CroppedFile? croppedFile =
                                      await ImageCropper().cropImage(
                                    sourcePath: image.path,
                                    aspectRatio: const CropAspectRatio(
                                        ratioX: 1, ratioY: 1),
                                    aspectRatioPresets: [
                                      CropAspectRatioPreset.square
                                    ],
                                    uiSettings: [
                                      AndroidUiSettings(
                                          toolbarTitle: 'Cropper',
                                          toolbarColor: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          toolbarWidgetColor: Colors.white,
                                          initAspectRatio:
                                              CropAspectRatioPreset.original,
                                          lockAspectRatio: false),
                                      IOSUiSettings(
                                        title: 'Cropper',
                                      ),
                                    ],
                                  );
                                  if (croppedFile != null) {
                                    setState(() {
                                      context.read<UpdateUserDataBloc>().add(
                                          UploadPicture(
                                              image.path,
                                              context
                                                  .read<MyUserBloc>()
                                                  .state
                                                  .user!
                                                  .userId));
                                    });
                                  }
                                }
                              },
                              child: CircleAvatar(
                                radius: 50.0, // Promień okręgu
                                backgroundColor: Colors.black26,
                                child: Icon(Icons.person),
                              ),
                            ),
                      Padding(
                        padding: EdgeInsets.all(6.0),
                        child: Text(
                          '${state.user!.name}',
                          style: TextStyle(
                            fontFamily: 'Wendy',
                            fontSize: 20,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                // const SizedBox(width: 10),
                //  Text("Welcome ${state.user!.name}"),

                Expanded(
                  child: Container(
                    color: Colors.white, // Ustawienie białego koloru tła
                    child: ListTileTheme(
                      textColor: Colors.black,
                      iconColor: Colors.black,
                      child: Column(
                        children: [
                          ListTile(
                            onTap: () {
                              Navigator.of(context).pop();
                            },
                            leading: Icon(Icons.home),
                            title: Text('home'.tr()),
                          ),
                          ListTile(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => SettingScreen()));
                            },
                            leading: Icon(Icons.settings),
                            title: Text('language_settings'.tr()),
                          ),
                          ListTile(
                            onTap: () {
                              context
                                  .read<SignInBloc>()
                                  .add(const SignOutRequired());
                            },
                            leading: Icon(Icons.logout),
                            title: Text('logout'.tr()),
                          ),
                          Spacer(),
                          DefaultTextStyle(
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.black,
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(
                                vertical: 16.0,
                              ),
                              child:
                                  Text('terms_of_service_privacy_policy'.tr()),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          } else
            return Center(child: Text("Wystąpił błąd"));
        },
      ),
    );
  }
}

//  GestureDetector(
//                   onTap: () async {
//
//                   },

class SettingScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('settings'.tr()), // Przykład użycia tłumaczenia
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: <Widget>[
            ListTile(
              onTap: () => context.setLocale(Locale('en', 'US')),
              title: Text('english'.tr()),
              leading: Icon(Icons.language),
            ),
            Divider(),
            ListTile(
              onTap: () => context
                  .setLocale(Locale('de', 'DE')), // Ustawienie niemieckiego
              title: Text('german'.tr()), // Tłumaczenie na niemiecki
              leading: Icon(Icons.language),
            ),
            Divider(),
            ListTile(
              title: Text(
                  'current_locale'.tr(args: [context.locale.languageCode])),
            ),
          ],
        ),
      ),
    );
  }
}
