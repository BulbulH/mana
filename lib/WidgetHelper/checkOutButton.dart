import 'package:flutter/material.dart';
import 'package:flutterecom/bloc/bloc_checkout.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/bloc/bloc_order.dart';
import 'package:flutterecom/emuns/checkOutType.dart';
import 'package:flutterecom/emuns/ratingType.dart';
import 'package:flutterecom/emuns/orderType.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';
import 'package:flutterecom/screens/homeWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/screens/splashWidget.dart';

class CheckOutButton {

  Widget getCheckOutTab(CheckOutType checkOutType) {
    return  Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: []..addAll(CheckOutType.values.map((type) {
        return getButtonUI(type,type==checkOutType);
      }).toList()),
    );

  }

  Widget getButtonUI(CheckOutType checkOutType, bool isSelected) {
    return Container(
        margin: EdgeInsets.all(5),
        width: 90,
        child:  Padding(
          padding: const EdgeInsets.all(2),
          child: Center(
            child: Text(
              checkOutType.toString().split(".")[1],
              textAlign: TextAlign.left,
              style: TextStyle(
                fontSize: 15,
                decoration: TextDecoration.none,
                fontWeight: FontWeight.bold,
                fontFamily: "Normal",
                color: isSelected?themeTextHighLightColor:themeTextColor,
              ),

            ),
          ),
        ),
    );
  }
}