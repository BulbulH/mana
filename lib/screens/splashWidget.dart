import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/responce/getAllCouponResponceModel.dart';
import 'package:flutterecom/models/responce/getAllPaymentMethodResponceModel.dart';
import 'package:flutterecom/models/responce/getShippingZoneMethodsResponce.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/woohttprequest.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutterecom/bloc/bloc_order.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:animated_text_kit/animated_text_kit.dart';


List<GetAllProducts> products=new List();
List<GetAllProductCategories> categories=new List();
List<GetOrderResponce> orders=new List();
List<int> shippingZoneId=new List();
List<GetShippingZoneMethods> shippingZoneMethod=new List();
List<PaymentGatewayResponce>  paymentGateway;
List<GetAllCoupon> coupons;
String currencyCode;



class SplashWidget extends StatefulWidget {
  @override
  SplashScreenState createState() => new SplashScreenState();
}

class SplashScreenState extends State<SplashWidget> with SingleTickerProviderStateMixin {

  startTime() async {
    var _duration = new Duration(seconds: 4);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {

    if(prefs!=null) {
      if (prefs.getBool(ISFIRSTOPEN) ?? true)
        Navigator.pushReplacementNamed(context, "/intro");
      else
        Navigator.pushReplacementNamed(context, "/home");
    }else
      Navigator.pushReplacementNamed(context, "/home");

  }

  Future getPrefences() async{
    prefs = await SharedPreferences.getInstance();
    return null;
  }

  @override
  void initState() {
    super.initState();
    getProductCategories();
    getProducts();
    getOrders();
    getShippingZonesMethod();
    getCoupon();
    getSettings();
    getPaymentGatewayMethod();
  }

  @override
  Widget build(BuildContext context) {

     if(prefs==null) {
       getPrefences().then((value) {
         setState(() {});
       });
       return Scaffold(
           backgroundColor: Colors.white,
           body: Container()
       );
     }
     else {
       startTime();

       return Scaffold(
           backgroundColor: themeBG,
           body: Center(
             child: Flex(
               direction: Axis.vertical,
               children: <Widget>[
                 Expanded(
                     flex: 1,
                     child: Container()
                 ),
                 Expanded(
                   flex: 1,
                   child: Image.asset(
                     'assets/logo.png',
                     width: 150,
                     height: 150,
                   ),
                 ),
                 Expanded(
                   flex: 1,
                   child: Row(
                     mainAxisSize: MainAxisSize.min,
                     children: <Widget>[
                       SizedBox(width: 20.0, height: 100.0),
                       Text(
                         APPNAME,
                         style: TextStyle(
                             color: themeTextHighLightColor,
                             fontSize: 25.0,
                             fontWeight: FontWeight.bold,
                             fontFamily: "Header"
                         ),
                       ),
                       SizedBox(width: 10.0, height: 100.0),
                       RotateAnimatedTextKit(
                         isRepeatingAnimation: false,
                         onTap: () {
                           print("Tap Event");
                         },
                         text: ["Store","Store"],
                         textStyle: TextStyle(
                             color: themeTextHighLightColor,
                             fontSize: 25.0,
                             fontWeight: FontWeight.bold,
                             fontFamily: "Header"),
                       ),
                     ],
                   ),
                 ),
                 SizedBox(height: 130.0),

                 Expanded(
                     flex: 1,
                     child: Center(
                       child: TypewriterAnimatedTextKit(
                           isRepeatingAnimation: false,
                           onTap: () {
                             print("Tap Event");
                           },
                           text: [
                             ". . . . . . . . . . . . ",
                             ". . . . . . . . . . . . ",
                           ],
                           textStyle: TextStyle(
                               color: themeTextColor,
                               fontSize: 28.0,
                               fontFamily: "Normal")
                       ),
                     )
                 ),

               ],
             ),
           )
       );
     }
  }




  getProducts() async {
    products =await WooHttpRequest().getProducts();
    homeBloc.refreshProducts(products);
    print(products);
  }

  getProductCategories() async {

    categories =await WooHttpRequest().getProductCategories();
    homeBloc.refreshProductCategories(categories);
    print(categories);
  }

  getOrders() async {
    orders =await WooHttpRequest().getOrders();
    print(orders);
  }

  getShippingZonesMethod() async {
    shippingZoneId =await WooHttpRequest().getShippingZones();
    print(shippingZoneId);
    shippingZoneId.forEach((value) async {
      shippingZoneMethod =await WooHttpRequest().getShippingZonesMethod(value);
      print(shippingZoneMethod);
    });
  }

  getCoupon() async {
    coupons =await WooHttpRequest().getCoupon();
    print(coupons);
  }

  getSettings() async {
    currencyCode =await WooHttpRequest().getSettings();
    print(currencyCode);
  }

  getPaymentGatewayMethod() async {
    paymentGateway =await WooHttpRequest().getPaymentGatways();
    print(paymentGateway);
  }

}