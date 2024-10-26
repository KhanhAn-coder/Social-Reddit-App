import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/features/responsive/responsive.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityScreen extends ConsumerWidget {
  final String name;
  const CommunityScreen({super.key, required this.name});

  void navigateToModTools (BuildContext context){
    Routemaster.of(context).push('/mod_tools/$name');
  }

  void joinCommunity(WidgetRef ref, Community community, BuildContext context) {
     ref.read(communityControllerProvider.notifier).joinCommunity(community, context);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);
    final isGuest = !user!.isAuthenticated;
    return Scaffold(
      body: ref.watch(getCommunityByNameProvider(name)).when(
          data: (community)=> NestedScrollView(
              headerSliverBuilder: (context, innerBoxIsScrolled){
                return[
                  SliverAppBar(
                    expandedHeight: 150,
                    floating: true,
                    snap: true,
                    flexibleSpace: Stack(
                      children: [
                        Image.network(community.banner, fit: BoxFit.cover, width: double.infinity,),
                      ],
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                        delegate: SliverChildListDelegate(
                          [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                CircleAvatar(
                                  radius: 35,
                                  backgroundImage: NetworkImage(community.avatar),
                                ),
                                const SizedBox(height: 5,),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(community.name, style: const TextStyle(
                                        fontSize: 19,
                                        fontWeight: FontWeight.bold
                                      ),
                                    ),
                                    if(!isGuest)
                                      community.mods.contains(user!.uid)? OutlinedButton(
                                          onPressed: (){
                                            navigateToModTools(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                          ),
                                          child: const Text('Mod Tools', style: TextStyle(
                                              color: Colors.blue
                                          ),
                                          )
                                      )
                                          :OutlinedButton(
                                          onPressed: ()=> joinCommunity(ref,community, context),
                                          style: ElevatedButton.styleFrom(
                                            shape: const RoundedRectangleBorder(
                                                borderRadius: BorderRadius.all(Radius.circular(20))
                                            ),
                                            padding: const EdgeInsets.symmetric(horizontal: 25),
                                          ),
                                          child:  Text(community.members.contains(user.uid)? 'Joined' : 'Join', style: const TextStyle(
                                              color: Colors.blue
                                          ),
                                          )
                                      )
                                  ],
                                ),
                                const SizedBox(height: 5,),
                                Text('${community.members.length.toString()} members', style: const TextStyle(
                                  fontSize: 13,
                                ),
                                ),
                              ],
                            )
                          ]
                        )
                    )
                  )
                ];
              },
              body: ref.watch(fetchCommunityPostProvider(community.name)).when(
                  data: (data)=> ListView.builder(
                    itemCount: data.length,
                    itemBuilder: (context,index){
                      final post = data[index];
                      return Responsive(child: PostCard(post: post));
                    },
                  ),
                  error: (error, StackTrace)=> ErrorText(error: error.toString()),
                  loading: ()=>const Loader()
              ),
          ),
          error: (error, StackTrace)=> ErrorText(error: error.toString()),
          loading: ()=> const Loader()),
    );
  }
}