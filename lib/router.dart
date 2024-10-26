import 'package:flutter/material.dart';
import 'package:reddit_app/features/auth/screens/login_screen.dart';
import 'package:reddit_app/features/chat/screens/chat_box_screen.dart';
import 'package:reddit_app/features/chat/screens/list_chat_screen.dart';
import 'package:reddit_app/features/community/screens/add_mods_screen.dart';
import 'package:reddit_app/features/community/screens/community_screen.dart';
import 'package:reddit_app/features/community/screens/create_community_screen.dart';
import 'package:reddit_app/features/community/screens/edit_community_screen.dart';
import 'package:reddit_app/features/community/screens/mod_tools_screen.dart';
import 'package:reddit_app/features/home/screens/home_screen.dart';
import 'package:reddit_app/features/post/screens/add_post_screen.dart';
import 'package:reddit_app/features/post/screens/add_post_type_screen.dart';
import 'package:reddit_app/features/post/screens/comments_screen.dart';
import 'package:reddit_app/features/user_profile/screens/edit_profile_screen.dart';
import 'package:reddit_app/features/user_profile/screens/user_profile_screen.dart';
import 'package:routemaster/routemaster.dart';

final loggedOutRoutes = RouteMap(routes: {
  '/': (_)=>const MaterialPage(child: LoginScreen()),
});

final loggedInRoutes = RouteMap(routes: {
  '/':(_) => const MaterialPage(child: HomeScreen()),
  '/create_community':(_) => const MaterialPage(child: CreateCommunityScreen()),
  '/r/:name':(route)=> MaterialPage(child: CommunityScreen(name: route.pathParameters['name']!)),
  '/mod_tools/:name':(route)=> MaterialPage(child: ModToolsScreen(name: route.pathParameters['name']!,)),
  '/edit_community/:name':(route)=> MaterialPage(child: EditCommunityScreen(name: route.pathParameters['name']!)),
  '/add_mods/:name':(route)=>MaterialPage(child: AddModsScreen(name: route.pathParameters['name']!,)),
  '/u/:uid':(routeData)=> MaterialPage(child: UserProfileScreen(uid: routeData.pathParameters['uid']!)),
  '/edit-profile/:uid': (routeData)=> MaterialPage(child: EditProfileScreen(uid: routeData.pathParameters['uid']!)),
  '/add-post/:type': (routeData)=> MaterialPage(child: AddPostTypeScreen(type: routeData.pathParameters['type']!)),
  '/post/:postId/comments':(routeData)=> MaterialPage(child: CommentsScreen(postId: routeData.pathParameters['postId']!)),
  '/chat/:id':(routeData)=> MaterialPage(child: ChatBoxScreen(friendId: routeData.pathParameters['id']!)),
  '/add-post':(routeData)=>const MaterialPage(child: AddPostScreen()),
  '/list-chat': (routeData)=> const MaterialPage(child: ListChatScreen()),
});