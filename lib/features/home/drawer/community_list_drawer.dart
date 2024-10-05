import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/common/sign_in_button.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:routemaster/routemaster.dart';

class CommunityListDrawer extends ConsumerWidget {
  const CommunityListDrawer({super.key});

  void navigateToCommunity(BuildContext context){
    Routemaster.of(context).push('/create_community');
  }

  void navigateToCommunityScreen(BuildContext context, String name){
    Routemaster.of(context).push('/r/$name');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Drawer(
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              isGuest?
              const SignInButton()
              : ListTile(
                title: const Text("Create community "),
                leading: const Icon(Icons.add),
                onTap: () => navigateToCommunity(context),
              ),
              ref.watch(userCommunitiesProvider).when(
                  data: (communities)=>ListView.builder(
                    itemCount: communities.length,
                    itemBuilder: (context, index){
                      final community = communities[index];
                      return ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(community.avatar),
                        ),
                        title: Text(community.name),
                        onTap:()=> navigateToCommunityScreen(context, community.name),
                      );
                    },
                    shrinkWrap: true,
                  ),
                  error: (error, StackTrace)=>ErrorText(error: error.toString()),
                  loading: ()=>const Loader()
              ),
            ],
          ),
        ),
      ),
    );
  }
}