import 'package:flutter/material.dart';
import 'package:flutterecom/utils/prefrences.dart';


Color transparent = Color(0x00000000);

//main
Color get themePrimary => Color(0xff54b0f3);
Color get themeBG => isDarkTheme()?Color(0xff40465d): Color(0xFFeef4f8);
//appbar
Color get themeAppBar =>  isDarkTheme()?Color(0xff40465d): Color(0xFFeef4f8);
Color get themeAppBarItems => isDarkTheme()?Color(0xFFeef4f8): Color(0xff40465d);
//text
Color get themeTextColor => isDarkTheme()?Color(0xFFeef4f8): Color(0xff40465d);
Color get themeTextHighLightColor => Color(0xff54b0f3);
//nav
Color get themeNavbarSelectedItems =>  isDarkTheme()?Color(0xff40465d): Color(0xFFeef4f8);
Color get themeNavbarUnSelectedItems =>  isDarkTheme()?Color(0xFFeef4f8): Color(0xff40465d);




