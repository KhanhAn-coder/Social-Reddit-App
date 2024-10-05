import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/ultis.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/user_profile/controller/user_profile_controller.dart';
import 'package:reddit_app/models/user_model.dart';

import '../../../core/common/error_text.dart';
import '../../../core/common/loader.dart';
import '../../../core/constants/constants.dart';
import '../../../theme/pallete.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  final String uid;
  const EditProfileScreen({super.key, required this.uid});

  @override
  ConsumerState createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  File? bannerFile;
  File? profileFile;
  late TextEditingController? nameController;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    nameController = TextEditingController(text: ref.read(userProvider)!.name);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    nameController!.dispose();
  }

  void selectBannerImage() async{
    final res = await pickImage();
    if(res != null){
      setState(() {
        bannerFile = File(res.files.first.path!);
      });
    }
  }

  void selectProfileImage() async{
    final res = await pickImage();
    if(res != null){
      setState(() {
        profileFile = File(res.files.first.path!);
      });
    }
  }

  void saveUserProfile(String name, File? banner, File? profileFile, BuildContext context, UserModel user) {
    ref.read(userProfileControllerProvider.notifier).editUserProfile(banner, profileFile, name, user, context);
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(userProfileControllerProvider);

    return ref.watch(getUserProvider(widget.uid)).when(
        data: (user){
          return Scaffold(
              appBar: AppBar(
                title: const Text('Edit Profile'),
                actions: [
                  TextButton(
                      onPressed: ()=> saveUserProfile(nameController!.text.trim(), bannerFile, profileFile, context, user!),
                      child: const Text('Save', style: TextStyle(
                          color: Colors.blue,
                          fontSize: 14,
                          fontWeight: FontWeight.bold
                      ),
                      )
                  )
                ],
              ),
              body: isLoading ?
              const Loader() :
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    SizedBox(
                      height: 200,
                      child: Stack(
                        children: [
                          GestureDetector(
                            onTap: selectBannerImage,
                            child: DottedBorder(
                                radius: const Radius.circular(10),
                                borderType: BorderType.RRect,
                                dashPattern: const [10,4],
                                strokeCap: StrokeCap.round,
                                color: Colors.grey,
                                child: Container(
                                  width: double.infinity,
                                  height: 150,
                                  child: bannerFile != null ?
                                  Image.file(bannerFile!):
                                  user!.profilePic == Constants.bannerDefault || user.profilePic == ''?
                                  const Center(
                                    child: Icon(Icons.camera_alt_outlined, size: 40,),
                                  )
                                      :Image.network(user.banner),
                                )
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: profileFile != null?
                              CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                              ):
                              CircleAvatar(
                                backgroundImage: NetworkImage(user!.profilePic),
                                radius: 32,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                     TextField(
                      controller: nameController,
                      decoration: const InputDecoration(
                        filled: true,
                        hintText: 'name',
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.all(18)
                      ),
                    ),
                  ],
                ),
              )
          );
        },
        error: (error, StackTrace)=>ErrorText(error: error.toString()),
        loading: ()=>const Loader()
    );
  }
}
