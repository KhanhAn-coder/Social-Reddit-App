import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/features/responsive/responsive.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class AddPostScreen extends ConsumerWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double cardHeightWidth = kIsWeb? 360 : 120;
    double iconSize = kIsWeb? 120: 60;
    final currentTheme = ref.watch(themeNotifierProvider);

    void navigateToType(BuildContext context, String type){
      Routemaster.of(context).push('/add-post/$type');
    }

    return Scaffold(
      appBar: AppBar(

      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: ()=> navigateToType(context, 'image'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child:  Card(
                color: currentTheme.backgroundColor,
                child: Icon(Icons.image_outlined, size: iconSize,),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()=> navigateToType(context, 'text'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child:  Card(
                color: currentTheme.backgroundColor,
                child: Icon(Icons.font_download_outlined, size: iconSize,),
              ),
            ),
          ),
          GestureDetector(
            onTap: ()=> navigateToType(context, 'link'),
            child: SizedBox(
              height: cardHeightWidth,
              width: cardHeightWidth,
              child:  Card(
                color: currentTheme.backgroundColor,
                child: Icon(Icons.link_outlined, size: iconSize,),
              ),
            ),
          )
        ],
      ),
    );
  }
}