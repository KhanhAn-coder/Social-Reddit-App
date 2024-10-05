import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/models/community_model.dart';

import '../../../core/type_defs.dart';

final communityRepositoryProvider = Provider((ref) => CommunityRepository(fireStore: ref.watch(fireStoreProvider)));
class CommunityRepository{
  final FirebaseFirestore _firestore;

  CommunityRepository({required FirebaseFirestore fireStore}): _firestore = fireStore;

  FutureVoid createCommunity(Community community) async{
    try{
        var communityDoc = await _communities.doc(community.name).get();
        if(communityDoc.exists){
          throw "Community with the same name already exist";
        }
        return right(await _communities.doc(community.name).set(community.toMap()));
    }on FirebaseException catch(e){
      throw e.message!;
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Community>> getUserCommunities(String uid) {
    return _communities.where('members', arrayContains: uid).snapshots().map((event) {
      List<Community> communities = [];
      for(var doc in event.docs){
        communities.add(Community.fromMap(doc.data() as Map<String,dynamic>));
      }
      return communities;
    });
  }

  Stream<Community> getCommunityByName(String name){
    return _communities.doc(name).snapshots().map((event) => Community.fromMap(event.data() as Map<String,dynamic>));
  }

  FutureVoid editCommunity(Community community) async{
    try{
      return right(await _communities.doc(community.name).update(community.toMap()));
    }on FirebaseException catch(e){
      throw e.message!;
    }
    catch(e){
      return left(Failure(e.toString()));
    }
  }
  Stream<List<Community>> searchCommunity(String query){
    return _communities.where(
      'name',
      isGreaterThanOrEqualTo: query.isEmpty ? 0: query,
      isLessThan: query.isEmpty? null
          : query.substring(0,query.length-1) +
          String.fromCharCode(
            query.codeUnitAt(query.length-1) +1,
          ),
    ).snapshots().map((event) {
      List<Community> communities = [];
      for(var community in event.docs){
        communities.add(Community.fromMap(community.data() as Map<String, dynamic>));
      }
      return communities;
    });
  }

  FutureVoid joinCommunity (String communityName, String userID) async{
    try{
      return right(await _communities.doc(communityName).update({'members': FieldValue.arrayUnion([userID])}));
    }on FirebaseException catch(e){
      throw e.message!;
    } catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid leaveCommunity(String communityName, String userID) async{
    try{
      return right(
        await _communities.doc(communityName).update({'members':FieldValue.arrayRemove([userID])})
      );
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  FutureVoid addMods(String name, Set<String> uIds) async{
    try{
      return right(
        await _communities.doc(name).update({'mods':uIds})
      );
    }on FirebaseException catch(e){
      throw e.message!;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _communities => _firestore.collection(FirebaseConstants.communitiesCollection);
}