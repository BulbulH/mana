import 'package:flutter/material.dart';
import 'package:flutterecom/bloc/bloc_checkout.dart';
import 'package:flutterecom/emuns/checkOutType.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:intl/intl.dart';

class CheckOutShippingScreen extends StatefulWidget {

  bool isFreeShipment;
  CheckOutShippingScreen(this.isFreeShipment);
  @override
  _CheckOutShippingState createState() => new _CheckOutShippingState();
}

double shippingCost=0.0;
class _CheckOutShippingState extends State<CheckOutShippingScreen>  {

  final String REQUIRED="__ *";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  int _groupValue = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if(shippingZoneMethod.length>0)
      shippingCost=double.parse(widget.isFreeShipment?0:shippingZoneMethod[0].cost);
  }
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

    return SingleChildScrollView(
      padding: EdgeInsets.only(left: 20.0, right: 20.0, top: 40.0, bottom: 10.0),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: []..addAll(
              shippingZoneMethod!=null&&shippingZoneMethod.length>0?shippingZoneMethod.map((method) {
                return _myRadioButton(
                  title: method.title +" ("+(widget.isFreeShipment?LocalLanguageString().free:method.cost)+")",
                  value: shippingZoneMethod.indexOf(method),
                  onChanged: (newValue) => setState((){
                    _groupValue = newValue;
                    shippingCost=widget.isFreeShipment?0:double.parse(method.cost);
                  }),
                );
              }).toList():
              [
                Center(
                  child: Text(
                    LocalLanguageString().shippingnotavailable,
                    style: TextStyle(
                      fontFamily: "Normal",
                      fontWeight: FontWeight.w600,
                      fontSize: 20,
                      color: themeTextColor,
                    ),
                  ),
                )
              ]
          )
          ..add(SaveButton())
      ),
    );
  }

  Widget _myRadioButton({String title, int value, Function onChanged}) {
    return RadioListTile(
      value: value,
      groupValue: _groupValue,
      onChanged: onChanged,
      title: Text(
        title,
        style: TextStyle(
          fontFamily: "Normal",
          fontWeight: FontWeight.w600,
          fontSize: 20,
          color: themeTextColor,
        ),),
    );
  }

  SaveButton( ) {
    return GestureDetector(
      onTap: () {
        checkOutBloc.selectCheckOut(CheckOutType.PAYMENT);
      },
      child: Container(
        padding: EdgeInsets.only(top: 30),
        width: double.infinity,
        child: Text(
          LocalLanguageString().gotopayment,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Normal",
            fontWeight: FontWeight.w600,
            fontSize: 20,
            color: themeTextColor,
          ),
        ),
      )
    );
  }

}