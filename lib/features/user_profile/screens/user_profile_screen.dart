import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:routemaster/routemaster.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';

class UserProfileScreen extends ConsumerWidget {
  final String uid;
  const UserProfileScreen({super.key, required this.uid});

  void navigateToEditProfileScren(String uid, BuildContext context){
    Routemaster.of(context).push('/edit-profile/$uid');
  }

  void navigateToChatScreen(String friendId, BuildContext context){
    Routemaster.of(context).push('/chat/$friendId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currUser = ref.watch(userProvider)!;
    return Scaffold(
      body: ref.watch(getUserProvider(uid)).when(
          data: (user)=> NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled){
              return[
                SliverAppBar(
                  expandedHeight: 250,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(
                    children: [
                      Image.network(user!.banner, fit: BoxFit.cover, width: double.infinity,),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20).copyWith(bottom: 70),
                        child: CircleAvatar(
                          radius: 45,
                          backgroundImage: NetworkImage(user.profilePic),
                        ),
                      ),
                      Container(
                        alignment: Alignment.bottomLeft,
                        padding: const EdgeInsets.all(20),
                        child:  currUser.uid == uid? OutlinedButton(
                            onPressed: ()=>navigateToEditProfileScren(uid, context),
                            style: ElevatedButton.styleFrom(
                              shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(20))
                              ),
                              padding: const EdgeInsets.symmetric(horizontal: 25),
                            ),
                            child:  const Text('Edit Profile', style: TextStyle(
                                color: Colors.blue
                            ),
                            )
                        ) :  const SizedBox()
                      )
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
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(user.name, style: const TextStyle(
                                          fontSize: 19,
                                          fontWeight: FontWeight.bold
                                      ),
                                      ),

                                      if(user.uid !=currUser.uid)
                                        IconButton(
                                          onPressed: ()=> navigateToChatScreen(user.uid, context),
                                          icon: const Icon(Icons.message),
                                          iconSize: 30,
                                          color: Colors.grey,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 5,),
                                  Text('${user.karma.toString()} karma', style: const TextStyle(
                                    fontSize: 13,
                                  ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10,),
                              const Divider(thickness: 2,),
                            ]
                        )
                    )
                )
              ];
            },
            body: ref.watch(fetchUserProfileProvider(user!.uid)).when(
                data: (data)=>ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context,index){
                    final post = data[index];
                    return PostCard(post: post);
                  },
                ),
                error: (error, StackTrace)=> ErrorText(error: error.toString()),
                loading: ()=> const Loader()
            ),
          ),
          error: (error, StackTrace)=> ErrorText(error: error.toString()),
          loading: ()=> const Loader()),
    );
  }
}