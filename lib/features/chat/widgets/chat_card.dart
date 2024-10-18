import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';

import '../../../models/chat_model.dart';

class ChatCard extends ConsumerWidget {
  final Chat chat;
  const ChatCard({super.key, required this.chat});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    if(user.uid == chat.senderId){
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(chat.senderProfilePic),
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16),
                      child: Container(
                        decoration: BoxDecoration(color: user.uid==chat.senderId ? Colors.deepOrangeAccent : Colors.grey,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                                bottomRight: Radius.circular(16)
                            )
                        ),
                        child: Column(
                          children: [
                            Text(chat.text, style: const TextStyle(
                                fontSize: 20
                            ),
                            )
                          ],
                        ),
                      ),
                    )
                )
              ],
            )
          ],
        ),
      );
    }else{
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 10),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Container(
                      decoration: BoxDecoration(color: user.uid==chat.senderId ? Colors.deepOrangeAccent : Colors.grey,
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                              bottomRight: Radius.circular(16)
                          )
                      ),
                      child: Column(
                        children: [
                          Text(chat.text, style: const TextStyle(
                              fontSize: 20
                          ),
                          )
                        ],
                      ),
                    )
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 16.0),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(chat.senderProfilePic),
                  ),
                ),
              ],
            )
          ],
        ),
      );
    }

  }
}
