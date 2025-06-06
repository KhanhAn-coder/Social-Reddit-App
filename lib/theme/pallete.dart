import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:reddit_app/core/enums/enums.dart';
import 'package:shared_preferences/shared_preferences.dart';

final themeNotifierProvider =
    StateNotifierProvider<ThemeNotifier, ThemeData>((ref) {
      return ThemeNotifier();
});

class Pallete {
  // Colors
  static const blackColor = Color.fromRGBO(1, 1, 1, 1); // primary color
  static const greyColor = Color.fromRGBO(26, 39, 45, 1); // secondary color
  static const drawerColor = Color.fromRGBO(18, 18, 18, 1);
  static const whiteColor = Colors.white;
  static var redColor = Colors.red.shade500;
  static var blueColor = Colors.blue.shade300;

  // Themes
  static var darkModeAppTheme = ThemeData.dark().copyWith(
    scaffoldBackgroundColor: blackColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: drawerColor,
      iconTheme: IconThemeData(
        color: whiteColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: drawerColor,
    ),
    primaryColor: redColor,
    //backgroundColor: drawerColor, // will be used as alternative background color
  );

  static var lightModeAppTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: whiteColor,
    cardColor: greyColor,
    appBarTheme: const AppBarTheme(
      backgroundColor: whiteColor,
      elevation: 0,
      iconTheme: IconThemeData(
        color: blackColor,
      ),
    ),
    drawerTheme: const DrawerThemeData(
      backgroundColor: whiteColor,
    ),
    primaryColor: redColor,
    //backgroundColor: whiteColor,
  );
}

class ThemeNotifier extends StateNotifier<ThemeData>{
  ThemeModel _model;
  ThemeNotifier({ThemeModel model = ThemeModel.dark}):
        _model = model,
        super(Pallete.darkModeAppTheme){
    getTheme();
  }




  void getTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    final theme = pref.getString('theme');

    if(theme == 'light'){
      state = Pallete.lightModeAppTheme;
    }else{
      state = Pallete.darkModeAppTheme;
    }
  }

  void toggleTheme() async{
    SharedPreferences pref = await SharedPreferences.getInstance();


    if(_model == ThemeModel.light){
      state = Pallete.darkModeAppTheme;
      pref.setString('theme', 'dark');
      _model = ThemeModel.dark;
    }else{
      state = Pallete.lightModeAppTheme;
      pref.setString('theme', 'light');
      _model = ThemeModel.light;
    }

  }

}