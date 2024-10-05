import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/enums/enums.dart';
import 'package:reddit_app/core/providers/storage_repository_provider.dart';
import 'package:reddit_app/core/type_defs.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/repository/post_repository.dart';
import 'package:reddit_app/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/models/comment_model.dart';
import 'package:routemaster/routemaster.dart';
import 'package:uuid/uuid.dart';

import '../../../core/ultis.dart';
import '../../../models/user_model.dart';


final postControllerProvider = StateNotifierProvider<PostController, bool>((ref) {
  return PostController(ref: ref, postRepository: ref.read(postRepositoryProvider), storageRepository: ref.read(storageRepositoryProvider));
});

final userPostsProvider = StreamProvider.family((ref, List<Community> communities) {
  return ref.watch(postControllerProvider.notifier).fetchUserPosts(communities);
});

final fetchUserProfileProvider = StreamProvider.family((ref, String uid) {
  return ref.watch(postControllerProvider.notifier).fetchUserProfilePost(uid);
});

final fetchCommunityPostProvider = StreamProvider.family((ref, String communityName) {
  return ref.watch(postControllerProvider.notifier).fetchCommunityPost(communityName);
});

final getPostByIdProvider = StreamProvider.family((ref, String postId)  {
  return ref.watch(postControllerProvider.notifier).getPostById(postId);
});

final fetchPostCommentProvider = StreamProvider.family((ref, String postId) {
  return ref.watch(postControllerProvider.notifier).fetchPostComment(postId);
});

final fetchGuestPostProvider = StreamProvider((ref) {
  return ref.watch(postControllerProvider.notifier).fetchGuestPost();
});

class PostController extends StateNotifier<bool>{
  final Ref _ref;
  final PostRepository _postRepository;
  final StorageRepository  _storageRepository;

  PostController({
    required Ref ref,
    required PostRepository postRepository,
    required StorageRepository storageRepository,
  }): _ref = ref,
      _postRepository = postRepository,
      _storageRepository = storageRepository,
      super(false);

  void shareTextPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String description,
}) async{
    final user = _ref.read(userProvider)!;
    String postID = const Uuid().v1();
    final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user.name,
        uid: user.uid,
        type: "Text",
        createdAt: DateTime.now(),
        awards: [],
        description: description
    );

    final res  = await _postRepository.addPost(post);
    res.fold(
            (l) => showSnackBar(context, l.message),
            (r) {
              showSnackBar(context, "Add Post Successfully");
              Routemaster.of(context).pop();
              _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.textPost);
            });
  }

  void shareLinkPost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required String link,
  }) async{
    final user = _ref.read(userProvider)!;
    String postID = const Uuid().v1();
    final Post post = Post(
        id: postID,
        title: title,
        communityName: selectedCommunity.name,
        communityProfilePic: selectedCommunity.avatar,
        upVotes: [],
        downVotes: [],
        commentCount: 0,
        userName: user.name,
        uid: user.uid,
        type: "Link",
        createdAt: DateTime.now(),
        awards: [],
        link: link,
    );

    final res  = await _postRepository.addPost(post);
    res.fold(
            (l) => showSnackBar(context, l.message),
            (r) {
          showSnackBar(context, "Add Post Successfully");
          Routemaster.of(context).pop();
          _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.linkPost);
        });
  }

  void shareImagePost({
    required BuildContext context,
    required String title,
    required Community selectedCommunity,
    required File? file,
  }) async{
    final user = _ref.read(userProvider)!;
    String postID = const Uuid().v1();
    final imageRes = await _storageRepository.storeFile(
        path: "posts/${selectedCommunity.name}",
        id: postID,
        file: file
    );

    imageRes.fold(
            (l) => showSnackBar(context, l.message),
            (r) async {
              final Post post = Post(
                  id: postID,
                  title: title,
                  communityName: selectedCommunity.name,
                  communityProfilePic: selectedCommunity.avatar,
                  upVotes: [],
                  downVotes: [],
                  commentCount: 0,
                  userName: user.name,
                  uid: user.uid,
                  type: "Image",
                  createdAt: DateTime.now(),
                  awards: [],
                  link: r,
              );
              final res  = await _postRepository.addPost(post);
              res.fold(
                      (l) => showSnackBar(context, l.message),
                      (r) {
                    showSnackBar(context, "Add Post Successfully");
                    Routemaster.of(context).pop();
                    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.imagePost);
                  });
            }
    );

  }

  Stream<List<Post>> fetchUserPosts(List<Community> communities){
    if(communities.isNotEmpty){
      return _postRepository.fetchUserPosts(communities);
    }else{
      return Stream.value([]);
    }
  }

  Stream<List<Post>> fetchGuestPost(){
    return _postRepository.fetchGuestPost();
  }

  void deleteUserPost(String postID, BuildContext context) async{
    final res = await _postRepository.deleteUserPost(postID);
    _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.deletePost);
    res.fold(
            (l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, "Post Deleted Successfully")
    );
  }
  void upVote(Post post) async{
    final user = _ref.watch(userProvider);
    await _postRepository.upVote(post, user!.uid);
  }
  void downVote(Post post) async{
    final user = _ref.watch(userProvider);
    await _postRepository.downVote(post, user!.uid);
  }

  Stream<List<Post>> fetchUserProfilePost(String uid){
    return _postRepository.fetchUserProfilePost(uid);
  }

  Stream<List<Post>> fetchCommunityPost(String communityName){
    return _postRepository.fetchCommunityPost(communityName);
  }

  Stream<Post> getPostById(String postId){
    return _postRepository.getPostById(postId);
  }

  void addComment({
    required String text,
    required Post post,
    required BuildContext context
  }) async{
    final user = _ref.read(userProvider)!;
    final commentId = const Uuid().v1();
    Comment comment = Comment(
        id: commentId,
        text: text,
        createdAt: DateTime.now(),
        postId: post.id,
        username: user.name,
        profiePic: user.profilePic
    );
    final res = await _postRepository.addComments(comment);
    res.fold((l) => showSnackBar(context, l.message),
            (r) => _ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.comment)
    );
  }

  Stream<List<Comment>> fetchPostComment(String postId){
    return _postRepository.fetchPostComment(postId);
  }

  void awardPost({
    required Post post,
    required String award,
    required UserModel userSend,
    required UserModel userGet,
    required BuildContext context
})async{
    userSend.awards.remove(award);
    UserModel newUserSend = userSend.copyWith();

    userGet.awards.add(award);
    UserModel newUserGet = userGet.copyWith();

    post.awards.add(award);
    Post newPost = post.copyWith();
    final res = await _postRepository.awardPost(newUserSend, newUserGet, newPost);
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Routemaster.of(context).pop();
      _ref.read(userProvider.notifier).update((state) {
        state?.awards.remove(award);
        return state;
      });
      //_ref.read(userProfileControllerProvider.notifier).updateUserKarma(UserKarma.awardPost);

    });

  }

}