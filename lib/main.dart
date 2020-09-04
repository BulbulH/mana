import 'package:flutter/material.dart';
import 'package:flutterecom/screens/aboutuswidget.dart';
import 'package:flutterecom/screens/subProductWidget.dart';
import 'package:flutterecom/screens/homefragments/cartWidget.dart';
import 'package:flutterecom/screens/homefragments/categoryWidget.dart';
import 'package:flutterecom/screens/checkOutTabWidget.dart';
import 'package:flutterecom/screens/checkoutfragments/checkoutProfileWidget.dart';
import 'package:flutterecom/screens/homeWidget.dart';
import 'package:flutterecom/screens/introWidget.dart';
import 'package:flutterecom/screens/loginWidget.dart';
import 'package:flutterecom/screens/homeProductDetailWidget.dart';
import 'package:flutterecom/screens/orderhistoryWidget.dart';
import 'package:flutterecom/screens/userProfileWidget.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/screens/wishListWidget.dart';
import 'package:shared_preferences/shared_preferences.dart';

//drawer UI Update ,set all strings in app for multilanguage .
SharedPreferences prefs;
void main() {

  return runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => SplashWidget(),
      '/intro': (context) => IntroScreen(),
      '/login': (context) => LoginWidget(),
      '/home': (context) => HomeScreen(),
      '/subproduct': (context) => SubProductScreen(),
      '/homeproductdetail': (context) => HomeProdcutDetailScreen(),
      '/aboutus': (context) => AboutusScreen(),
      '/orders': (context) => OrdersScreen(),
      '/checkOutTab': (context) => CheckOutTabScreen(),
      '/wishlist': (context) => WishListScreen(),
      '/cart': (context) => CartScreen(false),
      '/userprofile': (context) => UserProfileScreen(),
    },
    debugShowCheckedModeBanner: false,
  ));
}
