import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/models/post_model.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

import '../../models/user_model.dart';
import '../constants/constants.dart';

class PostCard extends ConsumerWidget {
  final Post post;
  const PostCard({super.key, required this.post});

  void deleteUserPost(WidgetRef ref, String postID, BuildContext context) async{
    ref.read(postControllerProvider.notifier).deleteUserPost(postID, context);
  }

  void upVote(Post post, WidgetRef ref) async{
     ref.read(postControllerProvider.notifier).upVote(post);
  }

  void downVote(Post post, WidgetRef ref) async{
    ref.read(postControllerProvider.notifier).downVote(post);
  }

  void navigateToUserProfile(BuildContext context){
    Routemaster.of(context).push('/u/${post.uid}');
  }
  void navigateToCommunity(BuildContext context){
    Routemaster.of(context).push('/r/${post.communityName}');
  }

  void navigateToComment(BuildContext context){
    Routemaster.of(context).push('/post/${post.id}/comments');
  }

  void awardPost(/*WidgetRef ref, String award, String senderId, BuildContext context*/WidgetRef ref, String award, UserModel userSend, UserModel userGet, BuildContext context){
    ref.watch(postControllerProvider.notifier).awardPost(post: post, award: award, userSend: userSend, userGet: userGet, context: context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isTypeText = post.type == 'Text';
    final isTypeLink = post.type == 'Link';
    final isTypeImage = post.type == 'Image';
    final currentTheme = ref.watch(themeNotifierProvider);
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: currentTheme.drawerTheme.backgroundColor,
          ),
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 16).copyWith(right: 0),
                      child: Container(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: ()=>navigateToCommunity(context),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(post.communityProfilePic),
                                        radius: 16,
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(left: 8),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(post.communityName, style: const TextStyle(
                                             fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          GestureDetector(
                                            onTap: ()=>navigateToUserProfile(context),
                                            child: Text(post.userName, style: const TextStyle(
                                              fontSize: 12
                                            ),),
                                          ),
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                                if(user!.uid == post.uid) IconButton(
                                    onPressed: ()=>deleteUserPost(ref, post.id, context),
                                    icon: const Icon(Icons.delete, color: Colors.red,)
                                )
                              ],
                            ),
                            if(post.awards.isNotEmpty)...[
                              const SizedBox(height: 5,),
                              SizedBox(
                                height: 25,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemCount: post.awards.length,
                                    itemBuilder: (context,index) {
                                      final award = post.awards[index];
                                      return Image.asset(Constants.awards[award]!);
                                    }),
                              ),
                            ],
                            Padding(
                              padding: const EdgeInsets.only(top: 10.0),
                              child: Text(post.title, style: const TextStyle(
                                fontSize: 19,
                                fontWeight: FontWeight.bold
                              ),),
                            ),
                            if(isTypeImage)
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.35,
                                width: double.infinity,
                                child: Image.network(
                                    post.link!,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            if(isTypeLink)
                              SizedBox(
                                height: MediaQuery.of(context).size.height*0.35,
                                width: double.infinity,
                                child: AnyLinkPreview(
                                    link: post.link!,
                                  displayDirection: UIDirection.uiDirectionHorizontal,
                                ),
                              ),
                            if(isTypeText)
                              Container(
                                alignment: Alignment.bottomLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 15),
                                child: Text(post.description!, style: const TextStyle(
                                  color: Colors.grey
                                ),),
                              ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    //upVote
                                    IconButton(
                                        onPressed: isGuest ? (){} : ()=> upVote(post, ref),
                                        icon:  Icon(
                                          Constants.up,
                                          size: 30,
                                          color: post.upVotes.contains(user.uid)? Colors.red:null,
                                        )
                                    ),
                                    Text(post.upVotes.length - post.downVotes.length == 0 ? 'Vote': '${post.upVotes.length - post.downVotes.length}'),
                                    //downVote
                                    IconButton(
                                        onPressed: isGuest ? (){} : ()=> downVote(post, ref),
                                        icon:  Icon(
                                          Constants.down,
                                          size: 30,
                                          color: post.downVotes.contains(user.uid) ? Colors.red:null,
                                        ),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                        onPressed: ()=>navigateToComment(context),
                                        icon: const Icon(Icons.comment),
                                    ),
                                    Text(post.commentCount == 0? 'Comment':'${post.commentCount}')
                                  ],
                                ),
                                ref.watch(getCommunityByNameProvider(post.communityName)).when(
                                    data: (data) {
                                      if(data.mods.contains(user.uid)){
                                        return IconButton(
                                            onPressed: (){},
                                            icon: const Icon(Icons.admin_panel_settings)
                                        );
                                      }else {
                                        return const SizedBox();
                                      }

                                    },
                                    error: (error,StackTrace)=> ErrorText(error: error.toString()),
                                    loading: ()=> const Loader()
                                ),
                                IconButton(
                                    onPressed:isGuest ? (){} : (){
                                      ref.watch(getUserProvider(user.uid)).when(
                                          data: (userSendData)=>ref.watch(getUserProvider(post.uid)).when(
                                              data: (userGetData)=>showDialog(
                                                  context: context,
                                                  builder: (context)=>Dialog(
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(20),
                                                      child: GridView.builder(
                                                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                                              crossAxisCount: 4
                                                          ),
                                                          itemCount: userSendData!.awards.length,
                                                          itemBuilder: (context, index) {
                                                            final award = userSendData.awards[index];
                                                            return GestureDetector(
                                                              onTap: ()=>awardPost(ref, award, userSendData, userGetData!, context),
                                                              child: Image.asset(Constants.awards[award]!),
                                                            );
                                                          }),
                                                    ),
                                                  )
                                              ),
                                              error: (error, StackTrace)=> ErrorText(error: error.toString()),
                                              loading: ()=>const Loader()
                                          ),

                                          error: (error, StackTrace)=> ErrorText(error: error.toString()),
                                          loading: ()=>const Loader()
                                      );

                                    },
                                    icon: const Icon(Icons.present_to_all_outlined)
                                )
                                
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
        const SizedBox(height: 10,)
      ],
    );
  }
}