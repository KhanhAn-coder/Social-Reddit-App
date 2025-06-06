import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/core/ultis.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/responsive/responsive.dart';
import 'package:reddit_app/models/community_model.dart';
import 'package:reddit_app/theme/pallete.dart';

class EditCommunityScreen extends ConsumerStatefulWidget {
  final String name;
  const EditCommunityScreen({super.key, required this.name});


  @override
  ConsumerState createState() => _EditCommunityScreenState();
}

class _EditCommunityScreenState extends ConsumerState<EditCommunityScreen> {
  File? bannerFile;
  File? profileFile;
  Uint8List? bannerWebFile;
  Uint8List? profileWebFile;

  void selectBannerImage() async {
    try{
      final res = await pickImage();
      if(res!= null && !kIsWeb){
        setState(() {
          bannerFile = File(res.files.first.path!);
        });
      }else{
        setState(() {
          bannerWebFile = res!.files.first.bytes;
        });
      }

    }catch(e){
      print(e);
    }
  }
  void selectProfileImage() async {
    try{
      final res = await pickImage();
      if(res!= null && !kIsWeb){
        setState(() {
          profileFile = File(res.files.first.path!);
        });
      }else{
        setState(() {
          profileWebFile = res!.files.first.bytes;
        });
      }
    }catch(e){
      print(e);
    }
  }
  void save(Community community){
    ref.read(communityControllerProvider.notifier).editCommunity(
        community: community,
        bannerFile: bannerFile,
        profileFile: profileFile,
        bannerWebFile: bannerWebFile,
        profileWebFile: profileWebFile,
        context: context
    );
  }
  @override
  Widget build(BuildContext context) {
    return ref.watch(getCommunityByNameProvider(widget.name)).when(
        data: (community){
          return Scaffold(
            appBar: AppBar(
              title: const Text('Edit Community'),
              actions: [
                TextButton(
                    onPressed: ()=> save(community),
                    child: const Text('Save', style: TextStyle(
                        color: Colors.blue,
                        fontSize: 14,
                        fontWeight: FontWeight.bold
                    ),
                    )
                )
              ],
            ),
            body: Responsive(
              child: Padding(
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
                                  child:bannerWebFile!=null ?
                                  Image.memory(bannerWebFile!):bannerFile != null ?
                                  Image.file(bannerFile!):
                                  community.banner == Constants.bannerDefault || community.banner == ''?
                                  const Center(
                                    child: Icon(Icons.camera_alt_outlined, size: 40,),
                                  )
                                      :Image.network(community.banner),
                                )
                            ),
                          ),
                          Positioned(
                            bottom: 20,
                            left: 20,
                            child: GestureDetector(
                              onTap: selectProfileImage,
                              child: profileWebFile!=null ?
                              CircleAvatar(
                                backgroundImage: MemoryImage(profileWebFile!),
                              ):profileFile != null?
                              CircleAvatar(
                                backgroundImage: FileImage(profileFile!),
                              ):
                              CircleAvatar(
                                backgroundImage: NetworkImage(community.avatar),
                                radius: 32,
                              ),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            )
          );
        },
        error: (error, StackTrace)=>ErrorText(error: error.toString()),
        loading: ()=>const Loader()
    );
  }
}


