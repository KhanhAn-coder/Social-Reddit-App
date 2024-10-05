import 'package:flutter/material.dart';
import 'package:routemaster/routemaster.dart';

class ModToolsScreen extends StatelessWidget {
  final String name;
  const ModToolsScreen({super.key, required this.name});

  void navigateToEditCommunity (BuildContext context){
    Routemaster.of(context).push('/edit_community/$name');
  }

  void navigateToAddMods(BuildContext context){
    Routemaster.of(context).push('/add_mods/$name');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mod Tools'),
      ),
      body: Column(
        children: [
          ListTile(
            title: const Text('Add Moderators'),
            leading: const Icon(Icons.add_moderator),
            onTap: ()=> navigateToAddMods(context)
          ),
          ListTile(
            title: const Text('Edit Community'),
            leading: const Icon(Icons.edit),
            onTap: (){
              navigateToEditCommunity(context);
            },
          ),
        ],
      ),
    );
  }
}
