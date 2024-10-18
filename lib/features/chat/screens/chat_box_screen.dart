import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/chat/controller/chat_controller.dart';
import 'package:reddit_app/features/chat/widgets/chat_card.dart';
import 'package:reddit_app/models/user_model.dart';

class ChatBoxScreen extends ConsumerStatefulWidget {
  final String friendId;
  const ChatBoxScreen({super.key, required this.friendId});

  @override
  ConsumerState createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends ConsumerState<ChatBoxScreen> {
  TextEditingController chatTextController = TextEditingController();
  ScrollController scrollController = ScrollController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    chatTextController.dispose();
  }

  void sendMessage(WidgetRef ref, String friendId, String senderId, String senderProfilePic, UserModel user, UserModel friend){
    ref.read(chatControllerProvider.notifier).addFriend(user, friend);
    ref.read(chatControllerProvider.notifier).sendMessage(friendId: friendId, senderId: senderId, text: chatTextController.text.trim(), senderProfilePic: senderProfilePic, context: context);
    setState(() {
      chatTextController.text = '';
      scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
    });
  }
  void scrollScreenToBottom(){
    scrollController.animateTo(scrollController.position.maxScrollExtent, duration: const Duration(milliseconds: 300), curve: Curves.easeOut);
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollScreenToBottom();
    });
  }
  @override
  Widget build(BuildContext context) {
    final currUser = ref.read(userProvider)!;
    return Container(
      child: ref.watch(getUserProvider(widget.friendId)).when(
          data: (friend)=>ref.watch(getUserProvider(currUser.uid)).when(
              data: (user)=>Scaffold(
                appBar: AppBar(
                  title: Row(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(friend!.profilePic),
                        radius: 18,
                      ),
                      const SizedBox(width: 10,),
                      Text(friend.name)
                    ],
                  ),
                ),
                body:  Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ref.watch(getMessagesProvider(widget.friendId)).when(
                        data: (messages) {
                          return Expanded(
                            child: ListView.builder(
                              itemCount: messages.length,
                              controller: scrollController,
                              shrinkWrap: true,
                              itemBuilder: (BuildContext context, int index) {
                                final chat = messages[index];
                                return ChatCard(chat: chat);
                              },
                            ),
                          );
                        },
                        error: (error, StackTrace)=> ErrorText(error: error.toString()),
                        loading: ()=> const Loader()
                    ),
                    TextField(
                      controller: chatTextController,
                      decoration: const InputDecoration(
                          hintText: 'Aa',
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(right: Radius.circular(30), left: Radius.circular(30)),
                              borderSide: BorderSide.none
                          )
                      ),
                      onSubmitted: (val)=> sendMessage(ref, friend.uid, currUser.uid, currUser.profilePic, user!, friend),
                    ),
                  ],
                ),

              ),
              error: (error,StackTrace)=> ErrorText(error: error.toString()),
              loading: ()=>const Loader()
          ),
          error: (error,StackTrace)=> ErrorText(error: error.toString()),
          loading: ()=> const Loader()
      ),
    );
  }
}
