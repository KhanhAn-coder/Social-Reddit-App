import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../models/comment_model.dart';

class CommentCard extends ConsumerWidget {
  final Comment comment;
  const CommentCard({super.key, required this.comment});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      child:  Padding(
          padding:const EdgeInsets.symmetric(
              horizontal: 4,
              vertical: 10
          ),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage: NetworkImage(comment.profiePic),
                  radius: 18,
                ),
                Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(comment.username, style: const TextStyle( fontWeight: FontWeight.bold),),
                          Text(comment.text)
                        ],
                      ),
                    )
                )
              ],
            ),
            Row(
              children: [
                IconButton(
                    onPressed: (){},
                    icon: const Icon(Icons.reply)
                ),
                const Text("Reply")
              ],
            )
          ],
        ),
      ),
    );
  }
}