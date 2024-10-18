import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/models/chat_model.dart';
import 'package:reddit_app/models/user_model.dart';

final chatRepositoryProvider = Provider((ref) {
  return ChatRepository(auth: ref.read(authProvider), fireStore: ref.read(fireStoreProvider));
});

class ChatRepository{
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  ChatRepository({
    required FirebaseAuth auth,
    required FirebaseFirestore fireStore}): _auth = auth,
                                            _firestore = fireStore;

  FutureVoid sendMessage(Chat chat) async{
    try{
      return right(
          await _chats.doc(chat.id).set(chat.toMap())
      );
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Future<void> addFriend(UserModel user, UserModel friend) async{
    try{
      if(!user.contacts.contains(friend.uid)){
        user.contacts.add(friend.uid);
        await _users.doc(user.uid).set(user.toMap());
      }
      if(!friend.contacts.contains(user.uid)){
        friend.contacts.add(user.uid);
        await _users.doc(friend.uid).set(friend.toMap());
      }
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      print(e.toString()) ;
    }
  }
  
  Stream<List<Chat>> getMessages(String senderId, String friendId){
    return _chats.where(
      Filter.and(Filter('senderId', whereIn: [senderId, friendId]), Filter('friendId', whereIn: [senderId, friendId]))
    ).orderBy('createdAt', descending: false)
        .snapshots().map(
            (event) => event.docs.map(
                    (e) => Chat.fromMap(e.data() as Map<String,dynamic>)).toList());
  }


  Stream<List<Chat>> getLatestMessages(String senderId, String friendId){
    return _chats.where(
        Filter.and(
            Filter('senderId', whereIn: [senderId, friendId]),
            Filter('friendId', whereIn: [senderId, friendId])
        )
    ).orderBy('createdAt', descending: true).limit(1).snapshots().map(
            (event) => event.docs.map(
                    (e) => Chat.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  CollectionReference get _chats => _firestore.collection(FirebaseConstants.chatCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
}