import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/repository/auth_repository.dart';
import 'package:reddit_app/models/user_model.dart';

import '../../../core/ultis.dart';

final userProvider = StateProvider<UserModel?>((ref) => null);

final authControllerProvider = StateNotifierProvider<AuthController,bool>((ref) => AuthController(
    authRepository: ref.watch(authRepositoryProvider),
    ref: ref
  )
);
final authStateChangeProvider = StreamProvider((ref){
  return ref.watch(authControllerProvider.notifier).authStateChange;
});

final getUserProvider = StreamProvider.family((ref, String uid)  {
  return ref.watch(authControllerProvider.notifier).getUserData(uid);
});

class AuthController extends StateNotifier<bool>{
  final AuthRepository _authRepository;
  final Ref _ref;

  AuthController({required authRepository, required ref}):
        _authRepository = authRepository,
        _ref = ref,
        super(false);

  Stream<User?> get authStateChange => _authRepository.authStateChange;

  void signInWithGoogle(BuildContext context, bool isFromLoginScreen) async{
    state = true;
    final user = await _authRepository.signInWithGoogle(isFromLoginScreen);
    state = false;
    user.fold((l) => showSnackBar(context, l.message), (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));


  }
  Stream<UserModel?> getUserData(String uid){
    return _authRepository.getUserData(uid);
  }

  void signInAsGuest()async{
    final res = await _authRepository.signInAsGuest();
    res.fold((l) => null, (userModel) => _ref.read(userProvider.notifier).update((state) => userModel));
  }

  void logOut() async{
    _authRepository.logOut();
  }
}