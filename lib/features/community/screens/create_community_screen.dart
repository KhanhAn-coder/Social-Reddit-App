import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/theme/pallete.dart';

class CreateCommunityScreen extends ConsumerStatefulWidget {
  const CreateCommunityScreen({super.key});

  @override
  ConsumerState createState() => _CreateCommunityScreenState();
}

class _CreateCommunityScreenState extends ConsumerState<CreateCommunityScreen> {
  final communityNameController = TextEditingController();

  void createCommunity(){
    ref.read(communityControllerProvider.notifier).createCommunity(communityNameController.text.trim(), context);
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    communityNameController.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(communityControllerProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text(
            'Create a community',
          style: TextStyle(
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading? const Loader() :Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8,),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'Community name',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16
              ),
            ),
          ),
          const SizedBox(height: 8,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextField(
              controller: communityNameController,
              decoration: const InputDecoration(
                hintText: 'r/Community_name',
                border: InputBorder.none,
                filled: true,
                contentPadding: EdgeInsets.all(18)
              ),
              maxLength: 21,
            ),
          ),
          const SizedBox(height: 30,),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: ElevatedButton(
                onPressed: createCommunity,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity,50.0),
                  backgroundColor: Colors.blue
                ),
                child: Container(
                  margin: const EdgeInsets.all(10),
                  child: const Text(
                      'Create community',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold
                    ),
                  ),
                )
            ),
          )
        ],
      ),
    );
  }
}
