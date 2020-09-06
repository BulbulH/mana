import 'dart:collection';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/productImageSlider.dart';
import 'package:flutterecom/list_views/home_product_grid_view.dart';
import 'package:flutterecom/list_views/home_product_list_view.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:flutter_html/flutter_html.dart';

_SubProductScreenScreenState SubProductScreenScreenState;
class SubProductScreen extends StatefulWidget {
  @override
  _SubProductScreenScreenState createState() {
    SubProductScreenScreenState= _SubProductScreenScreenState();
   return SubProductScreenScreenState;
  }
}

class _SubProductScreenScreenState extends State<SubProductScreen>   {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  List<GetAllProducts> subscreenProducts;
  String title;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    subscreenProducts = map['_subProducts'];
    title = map['_title'];


    return Scaffold(
        backgroundColor: themeBG,
        key: _scaffoldKey,
        body: SafeArea(
          child: screen(),
        )
    );
  }


  Widget screen( ) {
    List cartList = getCartProductsPref();

    return Container(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
                color: themeAppBar,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                        onTap: () {
                          Navigator.of(context).pop();
                        },
                        child: Container(
                          padding: EdgeInsets.all(5),
                          child: Icon(Icons.arrow_back,
                            color: themeAppBarItems,
                            size: 25,),
                        )
                    ),
                    Text(
                      title,
                      style: TextStyle(color: themeAppBarItems,
                        fontSize: 20.0,
                        fontFamily: "Header",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                   Container(),

                  ],
                ),
              )
          ),
          Expanded(
            flex: 10,
            child: Container(
                child: HomeProductListView(
                  products: subscreenProducts,
                  callBack: (String productId) {
                    Navigator.pushNamed(context, '/homeproductdetail', arguments: {'_productId': productId});
                  },
                )
            ),
          )

        ],
      ),
    );
  }


}
