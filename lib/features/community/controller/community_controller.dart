import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/storage_repository_provider.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/repository/community_repository.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/ultis.dart';

final communityControllerProvider = StateNotifierProvider<CommunityController,bool>((ref) {
  final communityRepository = ref.watch(communityRepositoryProvider);
  final storageRepository = ref.watch(storageRepositoryProvider);
  return CommunityController(communityRepository: communityRepository, ref: ref, storageRepository: storageRepository);
});

final userCommunitiesProvider = StreamProvider((ref) {
  return ref.watch(communityControllerProvider.notifier).getUserCommunities();
});

final getCommunityByNameProvider = StreamProvider.family((ref, String name) {
  return ref.watch(communityControllerProvider.notifier).getCommunityByName(name);
});

final searchCommunityProvider = StreamProvider.family((ref, String query) {
  return ref.watch(communityControllerProvider.notifier).searchCommunity(query);
});


class CommunityController extends StateNotifier<bool>{
  final CommunityRepository _communityRepository;
  final StorageRepository _storageRepository;
  final Ref _ref;

  CommunityController({required CommunityRepository communityRepository,
                        required Ref ref,
                        required StorageRepository storageRepository
                                        }): _communityRepository = communityRepository,
                                            _storageRepository = storageRepository,
                                            _ref = ref,
                                            super(false);

  void createCommunity(String name, BuildContext context) async{
    state = true;
    final uid = _ref.read(userProvider)?.uid ?? '';
    Community community = Community(
        id: name,
        name: name,
        banner: Constants.bannerDefault,
        avatar: Constants.avatarDefault,
        members: [uid],
        mods: [uid]
    );
    final res = await _communityRepository.createCommunity(community);
    state = false;
    res.fold(
          (l) => showSnackBar(context,l.message),
          (r) {
            showSnackBar(context,'Community created successfully');
            Routemaster.of(context).pop();
          });


  }
  
  Stream<List<Community>> getUserCommunities(){
    final uid = _ref.watch(userProvider)!.uid;
    return _communityRepository.getUserCommunities(uid);
  }
  Stream<Community> getCommunityByName(String name){
    return _communityRepository.getCommunityByName(name);
  }

  void editCommunity({required Community community, required File? bannerFile, required File? profileFile, required BuildContext context}) async{
    state = true;
    if(bannerFile!=null){
      final res = await _storageRepository.storeFile(
          path: 'communities/banner',
          id: community.id,
          file: bannerFile
      );
      res.fold((l) => showSnackBar(context, l.toString()), (r) =>  community = community.copyWith(banner: r));
    }                                                  /*Phai gan bien community moi cap nhat gia tri moi*/

    if(profileFile!=null){
      final res = await _storageRepository.storeFile(
          path: 'communities/avatar',
          id: community.id,
          file: profileFile
      );
      res.fold((l) => showSnackBar(context, l.toString()), (r) => community = community.copyWith(avatar: r));
    }
    final res = await _communityRepository.editCommunity(community);

    state = false;
    res.fold((l) => showSnackBar(context, l.toString()), (r) => Routemaster.of(context).pop());
  }
  Stream<List<Community>> searchCommunity(String query){
    return _communityRepository.searchCommunity(query);
  }

  void joinCommunity(Community community, BuildContext context) async{
    final user = _ref.read(userProvider);
    Either<Failure,void> res;
    if(community.members.contains(user!.uid)){
      res = await _communityRepository.leaveCommunity(community.name, user.uid);
    }else{
      res = await _communityRepository.joinCommunity(community.name, user.uid);
    }
    res.fold((l) => showSnackBar(context, l.message), (r){
      if(community.members.contains(user.uid)){
        showSnackBar(context, 'Left community Successfully');
      }else{
        showSnackBar(context, 'Joined community successfully');
      }
    });
  }

  void addMods(String name, Set<String> uIds, BuildContext context)async{
    Either<Failure,void> res;
    res = await _communityRepository.addMods(name, uIds);
    res.fold((l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, 'Action Successfully!')
    );
    Routemaster.of(context).pop();
  }
}