import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/features/responsive/responsive.dart';

import '../../auth/controller/auth_controller.dart';

class FeedScreen extends ConsumerWidget {
  const FeedScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    if(isGuest){
      return ref.watch(fetchGuestPostProvider).when(
          data: (data)=> ListView.builder(
            itemCount: data.length,
            itemBuilder: (BuildContext context, int index) {
              final post = data[index];
              return kIsWeb? Responsive(child: PostCard(post: post)) : PostCard(post: post);
            },
          ),
          error: (error, StackTrace)=>ErrorText(error: error.toString()),
          loading: ()=>const Loader()
      );
    }else{
      return ref.watch(userCommunitiesProvider).when(
        data: (communities)=>ref.watch(userPostsProvider(communities)).when(
          data: (posts){
            return ListView.builder(
              itemCount: posts.length,
              itemBuilder: (context,index){
                final post = posts[index];
                return kIsWeb? Responsive(child: PostCard(post: post)) : PostCard(post: post);
              },
            );
          },
          error: (error, StackTrace)=>ErrorText(error: error.toString()),
          loading: ()=> const Loader(),
        ),
        error: (error, StackTrace)=>ErrorText(error: error.toString()),
        loading: ()=> const Loader(),
      );
    }

  }
}