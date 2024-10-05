import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/models/user_model.dart';

final userRepositoryProvider = Provider((ref){
  final firestore = ref.watch(fireStoreProvider);
  final storage = ref.watch(storageProvider);
  return UserProfileRepository(firestore: firestore, storage: storage, ref: ref);
});

class UserProfileRepository{
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;
  final Ref _ref;

  UserProfileRepository({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
    required Ref ref,
  }): _firestore = firestore,
      _storage = storage,
      _ref = ref;

  FutureVoid editUserProfile (UserModel user, String uid) async{
    try{
      return right(
          await _firestore.collection(FirebaseConstants.usersCollection).doc(uid).update(user.toMap())
      );
    }on FirebaseException catch (e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid updateUserKarma(UserModel user)async{
    try{
      return right(
          await _firestore.collection(FirebaseConstants.usersCollection).doc(user.uid).update({'karma': user.karma})
      );
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }


}