import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/auth/screens/login_screen.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:reddit_app/router.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
    webProvider: ReCaptchaV3Provider('recaptcha-v3-site-key'),
    androidProvider: AndroidProvider.playIntegrity,
    appleProvider: AppleProvider.appAttest,
  );
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({super.key});

  @override
  ConsumerState createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  UserModel? userModel;

  void getData(WidgetRef ref, User data) async{
    userModel = await ref.watch(authControllerProvider.notifier).getUserData(data.uid).first;
    await ref.read(userProvider.notifier).update((state) => userModel);
  }

  @override
  Widget build(BuildContext context) {
    return ref.watch(authStateChangeProvider).when(
        data: (data){
          return MaterialApp.router(
            title: 'Flutter Demo',
            theme: ref.watch(themeNotifierProvider),
            debugShowCheckedModeBanner: false,
            routerDelegate: RoutemasterDelegate(routesBuilder: (context) {
              if(data!=null){
                getData(ref, data);
                return loggedInRoutes;
                if(userModel!= null){
                  return loggedInRoutes;
                }
              }
              return loggedOutRoutes;
            }),
            routeInformationParser: const RoutemasterParser(),

          );
        },
        error: (error, StackTrace){
          return ErrorText(error: error.toString());
        },
        loading: (){
          return const Loader();
        }
    );
  }
}



