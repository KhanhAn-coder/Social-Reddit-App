import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:reddit_app/core/constants/firebase_constants.dart';
import 'package:reddit_app/core/failure.dart';
import 'package:reddit_app/core/providers/firebase_providers.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/models/user_model.dart';

import '../../../models/comment_model.dart';
import '../../../models/community_model.dart';

final postRepositoryProvider = Provider<PostRepository>((ref) {
  return PostRepository(firestore: ref.watch(fireStoreProvider));
});

class PostRepository{
  final FirebaseFirestore _firestore;
  PostRepository({required FirebaseFirestore firestore}): _firestore = firestore;

  FutureVoid addPost(Post post) async{
    try{
      return Right( await _posts.doc(post.id).set(post.toMap()));
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities){
    return _posts.where('communityName', whereIn: communities.map((e) => e.name).toList())
                  .orderBy('createdAt', descending: true)
                  .snapshots().map((event) => event.docs
                  .map((e) => Post.fromMap(e.data() as Map<String,dynamic>)).toList());
  }

  Stream<List<Post>> fetchGuestPost(){
    return _posts.limit(10)
        .orderBy('createdAt', descending: true)
        .snapshots().map((event) => event.docs
        .map((e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  FutureVoid deleteUserPost(String postID) async{
    try{
      return right(
        await _posts.doc(postID).delete()
      );
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Future<void> upVote(Post post, String uID) async{
    if(post.upVotes.contains(uID)){
      return await _posts.doc(post.id).update({'upVotes': FieldValue.arrayRemove([uID])});
    }else if(post.downVotes.contains(uID)){
      await _posts.doc(post.id).update({'downVotes': FieldValue.arrayRemove([uID]), 'upVotes': FieldValue.arrayUnion([uID])});
      //return await _posts.doc(post.id).update({'upVotes': FieldValue.arrayUnion([uID])});
    }else{
      return await _posts.doc(post.id).update({'upVotes': FieldValue.arrayUnion([uID])});
    }
  }

  Future<void> downVote(Post post, String uID) async{
    if(post.downVotes.contains(uID)){
      await _posts.doc(post.id).update({'downVotes': FieldValue.arrayRemove([uID])});
    }else if(post.upVotes.contains(uID)){
      await _posts.doc(post.id).update({'upVotes': FieldValue.arrayRemove([uID]), 'downVotes': FieldValue.arrayUnion([uID])});
    }else{
      await _posts.doc(post.id).update({'downVotes': FieldValue.arrayUnion([uID])});
    }
  }

  //for user_profile_screen load post on their profile page
  Stream<List<Post>> fetchUserProfilePost(String uid) {
    return _posts.where('uid', isEqualTo: uid).orderBy('createdAt', descending: true).snapshots().map(
            (event) => event.docs.map(
                    (e) => Post.fromMap(e.data() as Map<String,dynamic>)).toList());
  }
  //for community_screen
  Stream<List<Post>> fetchCommunityPost(String communityName){
    return _posts.where('communityName', isEqualTo: communityName).orderBy('createdAt', descending: true)
        .snapshots().map(
            (event) => event.docs.map(
                    (e) => Post.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  Stream<Post> getPostById(String postId){
    return _posts.doc(postId).snapshots().map((event) => Post.fromMap(event.data() as Map<String,dynamic>));
  }

  FutureVoid addComments(Comment comment) async{
    try{
      return right(
          {
            await _comments.doc(comment.id).set(comment.toMap()),
            await _posts.doc(comment.postId).update({'commentCount': FieldValue.increment(1)})
          }
        );
    }on FirebaseException catch(e){
     throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  Stream<List<Comment>> fetchPostComment(String postId){
    return _comments.where('postId', isEqualTo: postId).orderBy('createdAt', descending: true)
        .snapshots().map(
            (event) => event.docs.map(
                    (e) => Comment.fromMap(e.data() as Map<String, dynamic>)).toList());
  }

  FutureVoid awardPost(/*Post post, String award, String senderId*/ UserModel userSend, UserModel userGet, Post post)async{
    try{
      /*await _users.doc(senderId).update({'awards': FieldValue.arrayRemove([award])});
      await _users.doc(post.uid).update({'awards': FieldValue.arrayUnion([award])});*/
      await _users.doc(userSend.uid).update(userSend.toMap());
      await _users.doc(userGet.uid).update(userGet.toMap());
      return right(
        /*await _posts.doc(post.id).update({'awards': FieldValue.arrayUnion([award])})*/
        await _posts.doc(post.id).update(post.toMap())
      );
    }on FirebaseException catch(e){
      throw e;
    }catch(e){
      return left(Failure(e.toString()));
    }
  }

  CollectionReference get _posts => _firestore.collection(FirebaseConstants.postsCollection);
  CollectionReference get _comments => _firestore.collection(FirebaseConstants.commentsCollection);
  CollectionReference get _users => _firestore.collection(FirebaseConstants.usersCollection);
}