import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/common/post_card.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/features/post/widgets/commnet_card.dart';

import '../../../models/post_model.dart';
import '../../auth/controller/auth_controller.dart';

class CommentsScreen extends ConsumerStatefulWidget {
  final String postId;
  const CommentsScreen({required this.postId, super.key});


  @override
  ConsumerState createState() => _CommentsScreenState();
}

class _CommentsScreenState extends ConsumerState<CommentsScreen> {
  TextEditingController commentsController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    commentsController.dispose();
  }
  void addComment(Post post) async{
    ref.read(postControllerProvider.notifier).addComment(text: commentsController.text.trim(), post: post, context: context);
    setState(() {
      commentsController.clear();
    });
  }
  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider)!;
    final isGuest = !user.isAuthenticated;
    return Scaffold(
      appBar: AppBar(),
      body: ref.watch(getPostByIdProvider(widget.postId)).when(
          data: (data) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  PostCard(post: data),
                  if(!isGuest)
                    TextField(
                      controller: commentsController,
                      decoration: const InputDecoration(
                          hintText: "What are your thoughts ?",
                          filled: true,
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.horizontal(left: Radius.circular(20), right: Radius.circular(20)),
                              borderSide: BorderSide.none
                          )
                      ),
                      onSubmitted: (val)=>addComment(data),
                    ),
                  ref.watch(fetchPostCommentProvider(data.id)).when(
                      data: (data)=> ListView.builder(
                        shrinkWrap: true,
                        physics: const ScrollPhysics(),
                        itemCount: data.length,
                        itemBuilder: (context, index){
                          final comment = data[index];
                          return CommentCard(comment: comment);
                        },
                      ),
                      error: (error, stackTrace) {
                        print(error.toString());
                        return ErrorText(error: error.toString() );
                      },
                      loading: ()=> const Loader()
                  )
                ],
              ),
            );
          },
          error: (error,StackTrace)=>ErrorText(error: error.toString()),
          loading: ()=> const Loader()
      ),
    );
  }
}
