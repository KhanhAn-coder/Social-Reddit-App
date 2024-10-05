import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/common/sign_in_button.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/theme/pallete.dart';

class LoginScreen extends ConsumerWidget {
  const LoginScreen({super.key});

  void signInAsGuest(WidgetRef ref){
    ref.read(authControllerProvider.notifier).signInAsGuest();
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Image.asset(Constants.logoPath, height: 50,),
        actions: [
          TextButton(
            onPressed: ()=>signInAsGuest(ref),
            child:  Text(
                'Skip',
              style: TextStyle(
                fontSize: 16,
                color: Pallete.blueColor,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
        ],
      ),
      body:  Center(
        child: isLoading? const Loader() : Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30,),
            const Text(
                'Dive into anything',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 25,
                letterSpacing: 0.5
              ),
            ),
            const SizedBox(height: 30,),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Image.asset('assets/images/loginEmote.png', height: 400,)
            ),
            const SizedBox(height: 20,),
            /*Container(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: MaterialButton(
                onPressed: (){},
                shape:  const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16))
                ),
                color: Pallete.greyColor,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset('assets/images/google.png',width: 40,),
                    const Text(
                        'Continue with Google',
                      style: TextStyle(
                        fontSize: 16
                      ),
                    )
                  ],
                ),
              ),
            ),*/
            const SignInButton(),
          ],
        ),
      ),
    );
  }
}
