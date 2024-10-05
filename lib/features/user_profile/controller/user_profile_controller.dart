import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/providers/storage_repository_provider.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/user_profile/repository/user_profile_repository.dart';
import 'package:reddit_app/models/user_model.dart';
import 'package:routemaster/routemaster.dart';
import '../../../core/enums/enums.dart';
import '../../../core/ultis.dart';

final  userProfileControllerProvider = StateNotifierProvider<UserProfileController,bool >((ref) {
  final userProfileRepository = ref.watch(userRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return UserProfileController(userProfileRepository: userProfileRepository, storageRepository: storageRepository, ref: ref);
});


class UserProfileController extends StateNotifier<bool> {
  final UserProfileRepository _userProfileRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;


  UserProfileController({
    required UserProfileRepository userProfileRepository,
    required StorageRepository storageRepository,
    required Ref ref
  }): _userProfileRepository = userProfileRepository,
      _storageRepository = storageRepository,
      _ref = ref,
      super(false);


  void editUserProfile( File? banner, File? profileFile, String name, UserModel user, BuildContext context) async{
    //state = true;
    if(banner!=null){
      final res = await _storageRepository.storeFile(
          path: 'userProfile/banner',
          id: user.uid,
          file: banner
      );
      res.fold((l) => showSnackBar(context, l.message), (r) => user = user.copyWith(banner: r));
    }
    if(profileFile!=null){
      final res = await _storageRepository.storeFile(
          path: 'userProfile/profilePic',
          id: user.uid,
          file: profileFile
      );
      res.fold((l) => showSnackBar(context, l.message), (r) => user = user.copyWith(profilePic: r));
    }
    user = user.copyWith(name: name);

    final res = await _userProfileRepository.editUserProfile(user, user.uid);
    //state = false;
    res.fold((l) => showSnackBar(context, l.message),
            (r) {
              _ref.read(userProvider.notifier).update((state) => user);
              Routemaster.of(context).pop();
            }
    );
  }

  void updateUserKarma(UserKarma karma)async{
    UserModel user = _ref.read(userProvider)!;
    final newUser  = user.copyWith(karma: user.karma + karma.karma);
    _ref.read(userProvider.notifier).update((state) => newUser);
    final res = await _userProfileRepository.updateUserKarma(newUser);
    res.fold((l) => null, (r) => null);
  }
}