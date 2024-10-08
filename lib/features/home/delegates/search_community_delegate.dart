import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/common/error_text.dart';
import 'package:reddit_app/core/common/loader.dart';
import 'package:reddit_app/features/community/controller/community_controller.dart';
import 'package:routemaster/routemaster.dart';

class SearchCommunityDelegate extends SearchDelegate {
  WidgetRef ref;
  SearchCommunityDelegate(this.ref);
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [
      IconButton(
          onPressed: (){
            query = '';
          },
          icon: const Icon(Icons.close)
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    return null;
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    return SizedBox();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    return ref.watch(searchCommunityProvider(query)).when(
        data: (communities) {
          return ListView.builder(
            itemCount: communities.length,
              itemBuilder: (context, index) {
                final community = communities[index];
                return ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(community.avatar),
                  ),
                  title: Text(community.name),
                  onTap: ()=> navigateToCommunityScreen(context,community.name),
                );
              });
        },
        error: (error, stackTrace)=> ErrorText(error: error.toString()),
        loading: ()=> const Loader()
    );
  }
  void navigateToCommunityScreen(BuildContext context, String name){
    Routemaster.of(context).push('/r/$name');
  }

}