import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/core/ultis.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:reddit_app/features/post/controller/post_controller.dart';
import 'package:reddit_app/models/community_model.dart';

class AddPostTypeScreen extends ConsumerStatefulWidget {
  final String type;
  const AddPostTypeScreen({super.key, required this.type});

  @override
  ConsumerState createState() => _AddPostTypeScreenState();
}

class _AddPostTypeScreenState extends ConsumerState<AddPostTypeScreen> {
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController linkController = TextEditingController();
  List<Community> communities = [];
  Community? selectedCommunity;
  File? image;

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
    linkController.dispose();
  }

  void selectImage()async{
    final res = await pickImage();
    if(res!=null){
      setState(() {
        image = File(res.files.first.path!);
      });
    }
  }

  void shareTextPost(WidgetRef ref, BuildContext context) async{
    ref.read(postControllerProvider.notifier).shareTextPost(
        context: context,
        title: titleController.text.trim(),
        selectedCommunity: selectedCommunity ?? communities[0],
        description: descriptionController.text.trim(),
    );
  }

  void shareLinkPost(WidgetRef ref, BuildContext context) async{
    ref.read(postControllerProvider.notifier).shareLinkPost(
      context: context,
      title: titleController.text.trim(),
      selectedCommunity: selectedCommunity ?? communities[0],
      link: linkController.text.trim(),
    );
  }

  void shareImagePost(WidgetRef ref, BuildContext context) async{
    ref.read(postControllerProvider.notifier).shareImagePost(
      context: context,
      title: titleController.text.trim(),
      selectedCommunity: selectedCommunity ?? communities[0],
      file: image,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isTypeImage = widget.type == 'image';
    final isTypeText = widget.type == 'text';
    final isTypeLink = widget.type == 'link';
    return Scaffold(
      appBar: AppBar(
        title: const Text('Post Text'),
        centerTitle: true,
        actions: [
          TextButton(
              onPressed: (){
                if(isTypeText && titleController.text.isNotEmpty){
                  shareTextPost(ref, context);
                }
                else if(isTypeLink && titleController.text.isNotEmpty && linkController.text.isNotEmpty){
                  shareLinkPost(ref, context);
                }
                else if(isTypeImage && titleController.text.isNotEmpty && image != null){
                  shareImagePost(ref, context);
                }else{
                  showSnackBar(context, "Please Enter all the fields");
                }
              },

              child: const Text('Share', style: TextStyle(
                color: Colors.blue,
                fontSize: 16
              ),
            ),
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(
                  filled: true,
                  hintText: 'Enter Title',
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                    borderRadius: BorderRadius.all(Radius.circular(10))
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.all(18)
                ),
                maxLength: 30,
              ),
              const SizedBox(height: 10,),
              if(isTypeImage)
                GestureDetector(
                  onTap: selectImage,
                  child: DottedBorder(
                      radius: const Radius.circular(10),
                      borderType: BorderType.RRect,
                      strokeCap: StrokeCap.round,
                      dashPattern: const [10,4],
                      color: Colors.grey,
                      child: Container(
                        width: double.infinity,
                        child: image!=null?
                        Image.file(image!)
                            :const Icon(Icons.camera_alt_outlined, size: 120,),
                      )
                  ),
                ),
              if(isTypeText)
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter Description',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)
                  ),
                  maxLines: 5,
                ),
              if(isTypeLink)
                TextField(
                  controller: linkController,
                  decoration: const InputDecoration(
                      filled: true,
                      hintText: 'Enter link',
                      focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.all(Radius.circular(10))
                      ),
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.all(18)
                  ),
                ),
              const SizedBox(height: 20,),
              const Align(
                alignment: Alignment.topLeft,
                child: Text('Select Community'),
              ),
              ref.watch(userCommunitiesProvider).when(
                  data: (data){
                    communities = data;
                    if(data.isEmpty){
                      return const SizedBox();
                    }
                    return DropdownButton(
                      value: selectedCommunity ?? data[0],
                        items: data.map((e) => DropdownMenuItem(value: e,child: Text(e.name))).toList(),
                        onChanged: (val){
                          setState(() {
                            selectedCommunity = val;
                          });
                        }
                    );
                  },
                  error: (error, StackTrace)=> ErrorText(error: error.toString()),
                  loading: ()=> const Loader()
              )
            ],
          ),
        ),
      ),
    );
  }
}
