import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/models/user_model.dart';

class AddModsScreen extends ConsumerStatefulWidget {
  final String name;
  const AddModsScreen({super.key, required this.name});

  @override
  ConsumerState createState() => _AddModsScreenState();
}

class _AddModsScreenState extends ConsumerState<AddModsScreen> {

  Set<String> uIds = {};
  int counter = 0;

  void addUid(String uid){
    setState(() {
      uIds.add(uid);
    });
  }

  void removeUid(String uid){
    setState(() {
      uIds.remove(uid);
    });
  }

  void addMods(WidgetRef ref, String name, Set<String> uIds, BuildContext context){
    ref.read(communityControllerProvider.notifier).addMods(name, uIds, context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: ()=> addMods(ref, widget.name, uIds, context),
              icon: const Icon(Icons.done),
          )
        ],
      ),
      body: ref.watch(getCommunityByNameProvider(widget.name)).when(
          data: (community){
            return ListView.builder(
              itemCount: community.members.length,
              itemBuilder: (context, index){
                final member = community.members[index];
                return ref.watch(getUserProvider(member)).when(
                    data: (memberData){
                      if(community.mods.contains(member) && counter < community.mods.length){
                        uIds.add(member);
                        counter++;
                      }
                      return CheckboxListTile(
                          title: Text(memberData!.name),
                          value: uIds.contains(memberData.uid),
                          onChanged: (val){
                            if(val == true){
                              addUid(memberData.uid);
                            }else{
                              removeUid(memberData.uid);
                            }
                          }
                      );
                    },
                    error: (error,StackTrace)=> ErrorText(error: error.toString()),
                    loading: ()=> const Loader()
                );

              }
            );
          },
          error: (error,StackTrace)=>ErrorText(error: error.toString()),
          loading: ()=> const Loader(),
      ),
    );
  }
}
