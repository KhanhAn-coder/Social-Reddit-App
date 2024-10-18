import 'package:flutter/material.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/chat/controller/chat_controller.dart';
import 'package:reddit_app/models/chat_model.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:routemaster/routemaster.dart';

class ChatBoxCard extends ConsumerWidget {
  final String friendId;
  const ChatBoxCard({super.key, required this.friendId});

  void navigateToChatBoxScreen(String friendId, BuildContext context){
    Routemaster.of(context).push('/chat/$friendId');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    return ref.watch(getUserProvider(friendId)).when(
        data: (data) {
          return ref.watch(getLatestMessagesProvider(friendId)).when(
              data: (messages) {
                String text = '';
                for(var i in messages){
                  text = i.text;
                }
                return GestureDetector(
                  onTap: ()=>navigateToChatBoxScreen(friendId, context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage(data!.profilePic),
                              radius: 18,
                            ),
                            Expanded(
                                child: Column(
                                  children: [
                                    Text(data.name),
                                    Text(text),
                                  ],
                                )
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              },
              error: (error,StackTrace)=> ErrorText(error: error.toString()),
              loading: ()=> const Loader()
          );
        },
        error: (error,StackTrace)=> ErrorText(error: error.toString()),
        loading: ()=> const Loader()
    );
  }
}
