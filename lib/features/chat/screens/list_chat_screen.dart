import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/chat/controller/chat_controller.dart';
import 'package:reddit_app/features/chat/widgets/chat_box_card.dart';

import '../../../models/chat_model.dart';

class ListChatScreen extends ConsumerWidget {
  const ListChatScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.read(userProvider)!;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Messages'),
        centerTitle: true,
      ),
      body: ref.watch(getUserProvider(user.uid)).when(
          data: (data) {
            return ListView.builder(
            itemCount: data!.contacts.length,
            itemBuilder: (BuildContext context, int index) {
              final friendId = data.contacts[index];
              return ChatBoxCard(friendId: friendId);

            },
          );
          },
          error: (error,StackTrace)=> ErrorText(error: error.toString()),
          loading: ()=> const Loader()
      ),
    );
  }
}
