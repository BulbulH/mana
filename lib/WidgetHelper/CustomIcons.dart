import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/utils/appTheme.dart';

Widget drawerButtonIcon(Function callBack,IconData icon) {
  return GestureDetector(
      onTap: callBack,
      child: Container(
        height: 40,
        width: 40,
        child: Icon(
          icon,
          color: themeAppBarItems,
          size: 25,
        ),
      )
  );
}
Widget navTabItem() {
  return TabBar(
    labelColor: themeNavbarUnSelectedItems,
    unselectedLabelColor: themeNavbarUnSelectedItems,
//    indicatorSize: TabBarIndicatorSize.tab,
    indicatorPadding: EdgeInsets.all(5.0),
    indicatorColor: Colors.blue ,
    indicatorSize: TabBarIndicatorSize.label,
    tabs: [
      Tab(
        icon:  Image.asset("assets/home.png",width: 24,height: 24,color: themeTextColor,),
      ),
      Tab(
        icon:  Image.asset("assets/categories.png",width: 24,height: 24,color: themeTextColor,),
      ),
      Tab(
        icon:  Image.asset("assets/cart.png",width: 24,height: 24,color: themeTextColor,),
      ),
      Tab(
        icon:  Image.asset("assets/setting.png",width: 24,height: 24,color: themeTextColor,),
      ),
    ],
  );
}



Widget getReviews(GetAllProducts thisProduct){
  int rating =double.parse(thisProduct.average_rating).floor();
  return Row(
    children: <Widget>[
      rating==0?  Row(
        children: List.generate(5-rating, (index)  {
          return Icon(
            Icons.star_border,
            size: 15,
            color: themeTextColor,
          );
        }),
      ):Row(
          children: []..addAll(
              List.generate(rating, (index)  {
                return Icon(
                  Icons.star,
                  size: 15,
                  color: themePrimary,
                );
              })
          )..addAll(
              List.generate(5-rating, (index)  {
                return Icon(
                  Icons.star_border,
                  size: 15,
                  color: themePrimary,
                );
              })
          )..add( Text(
            '  ( ${thisProduct.rating_count} )',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontFamily: "Normal",
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: themeTextColor,
            ),
          ),)
      ),
    ],
  );
}
