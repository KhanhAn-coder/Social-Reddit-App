import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/enums/enums.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class ProfileDrawer extends ConsumerWidget {
  const ProfileDrawer({super.key});

  void logOut(WidgetRef ref){
    ref.read(authControllerProvider.notifier).logOut();
  }

  void navigateToProfileUser(BuildContext context, String uid){
    Routemaster.of(context).push('/u/$uid');
  }

  void toggleTheme(WidgetRef ref){
    ref.read(themeNotifierProvider.notifier).toggleTheme();
    print(ref.read(themeNotifierProvider));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(user!.profilePic),
              radius: 70,
            ),
            const SizedBox(height: 15,),
            Text(user.name, style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20
            ),
          ),
            const SizedBox(height: 30,),
            if(!isGuest)
              ListTile(
                title: const Text('My Profile', style: TextStyle(
                    fontWeight: FontWeight.bold
                ),
                ),
                leading: const Icon(Icons.person),
                onTap: ()=> navigateToProfileUser(context, user.uid),
              ),
            ListTile(
              title: const Text('Log Out', style: TextStyle(
                fontWeight: FontWeight.bold
              ),
              ),
              leading: const Icon(Icons.logout, color: Colors.red,),
              onTap: ()=>logOut(ref),
            ),
            Switch.adaptive(
                value: ref.watch(themeNotifierProvider) == Pallete.darkModeAppTheme,
                onChanged: (value)=> toggleTheme(ref)
            ),
          ],
        ),
      ),
    );
  }
}