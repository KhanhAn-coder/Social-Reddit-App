import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/theme/pallete.dart';

class SignInButton extends ConsumerWidget {
  final bool isFromLoginScreen;
  const SignInButton({super.key, this.isFromLoginScreen = true});

  void signInWithGoogle(WidgetRef ref, BuildContext context){
    ref.read(authControllerProvider.notifier).signInWithGoogle(context, isFromLoginScreen);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 18),
      child: ElevatedButton.icon(
          onPressed: ()=> signInWithGoogle(ref, context),
          icon: Image.asset(Constants.googlePath, width: 35,),
          label: const Text(
              'Continue with google',
            style: TextStyle(
              fontSize: 18
            ),
          ),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity,50),
          backgroundColor: Pallete.greyColor,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          )
        ),
      ),
    );
  }
}
