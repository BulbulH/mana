
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/profileInfo.dart';
import 'package:flutterecom/emuns/checkOutType.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/bloc/bloc_checkout.dart';

class CheckOutProfileScreen extends StatefulWidget {

  @override
  _ConfirmOrderPageState createState() => new _ConfirmOrderPageState();
}

class _ConfirmOrderPageState extends State<CheckOutProfileScreen>  {

  final String REQUIRED="__ *";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: themeBG,
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {

    Map map= ModalRoute.of(context).settings.arguments as Map;
    double amount=map['_amount'];

    return Container(
      padding: EdgeInsets.all(15),
      child: ProfileInfo(onTap:(){
        checkOutBloc.selectCheckOut(CheckOutType.SHIPPING);
      })
    ) ;
  }

}