import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/constants/constants.dart';
import 'package:reddit_app/features/auth/controller/auth_controller.dart';
import 'package:reddit_app/features/home/delegates/search_community_delegate.dart';
import 'package:reddit_app/features/home/drawer/community_list_drawer.dart';
import 'package:reddit_app/features/home/drawer/prrofile_drawer.dart';
import 'package:reddit_app/features/responsive/responsive.dart';
import 'package:reddit_app/theme/pallete.dart';
import 'package:routemaster/routemaster.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _page = 0;
  void displayDrawer(BuildContext context){
    Scaffold.of(context).openDrawer();
  }
  void displayProfileDrawer(BuildContext context){
    Scaffold.of(context).openEndDrawer();
  }
  void pageChanged(int page) {
    setState(() {
      _page = page;
    });
  }
  void navigateToAddPostScreen(BuildContext context){
    Routemaster.of(context).push('/add-post');
  }

  void navigateToChatListScreen(BuildContext context){
    Routemaster.of(context).push('/list-chat');
  }


  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userProvider);
    final currentTheme = ref.watch(themeNotifierProvider);
    return Scaffold(
      appBar: AppBar(
        leading: Builder(
            builder: (context) {
              return IconButton(
                  onPressed: ()=> displayDrawer(context),
                  icon: const Icon(Icons.menu)
              );
            }
        ),
        actions: [
          IconButton(
              onPressed: (){
                showSearch(context: context, delegate: SearchCommunityDelegate(ref));
              },
              icon: const Icon(Icons.search)
          ),
          if(kIsWeb)
            IconButton(
                onPressed: ()=> navigateToAddPostScreen(context),
                icon: const Icon(Icons.add)
            ),
            IconButton(
                onPressed: ()=> navigateToChatListScreen(context),
                icon: const Icon(Icons.messenger)
            ),
          Builder(
              builder: (context) {
                return IconButton(
                  onPressed: ()=> displayProfileDrawer(context) ,
                  icon: CircleAvatar(
                    radius: 15,
                    backgroundImage: NetworkImage(user!.profilePic),
                  ),
                );
              }
          )
        ],
        title: const Text(
            'Home'
        ),
      ),
      body: Constants.tabBars[_page],
      drawer: const CommunityListDrawer(),
      endDrawer: const ProfileDrawer(),
      bottomNavigationBar: !kIsWeb? CupertinoTabBar(
        backgroundColor: currentTheme.scaffoldBackgroundColor,
        activeColor: currentTheme.iconTheme.color,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.add),
              label: ''
          ),
          BottomNavigationBarItem(
              icon: Icon(Icons.messenger),
              label: ''
          ),
        ],
        onTap: pageChanged,
        currentIndex: _page,
      ):const SizedBox(),
    );
  }
}




