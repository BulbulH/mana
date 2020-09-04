import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterecom/WidgetHelper/checkOutButton.dart';
import 'package:flutterecom/bloc/bloc_checkout.dart';
import 'package:flutterecom/emuns/checkOutType.dart';
import 'package:flutterecom/screens/checkoutfragments/checkoutPaymentWidget.dart';
import 'package:flutterecom/screens/checkoutfragments/checkoutProfileWidget.dart';
import 'package:flutterecom/screens/checkoutfragments/checkoutShippingWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';

 class CheckOutTabScreen extends StatefulWidget {

  @override
  _CheckOutScreenState createState() => new _CheckOutScreenState();
  }

class _CheckOutScreenState extends State<CheckOutTabScreen> with CheckOutButton {
  bool isFreeShipment;
  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    double amount = map['_amount'];
    isFreeShipment = map['_freeShipment']??false;

    return Container(
      color: themeBG,
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
              flex: 1,
              child: Container(
              )
          ),
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
                          height: 40,
                          width: 40,

                          child: Icon(Icons.arrow_back,
                            color: themeAppBarItems,
                            size: 25,),
                        )
                    ),
                    Text(
                      LocalLanguageString().checkout,
                      style: TextStyle(
                        color: themeAppBarItems,
                        fontSize: 20.0,
                        decoration: TextDecoration.none,
                        fontWeight: FontWeight.normal,
                        fontFamily: "Header",
                      ),
                    ),
                    Container(),

                  ],
                ),
              )
          ),
          Expanded(
              flex: 13,
              child: body(amount)
          )

        ],
      ),
    );
  }

  Widget body(double amount){
    return Container(
        child: Flex(
          direction: Axis.vertical,
          children: <Widget>[
            Divider(),
            Expanded(
              flex: 1,
              child: StreamBuilder(
                stream: checkOutBloc.selectCheckoutStreamController.stream,
                initialData: CheckOutType.ADDRESS,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data!=null? getCheckOutTab(snapshot.data):Container();
                },
              ),
            ),
            Expanded(
                flex: 9,
                child:  StreamBuilder(
                  stream: checkOutBloc.selectCheckoutStreamController.stream,
                  initialData: CheckOutType.ADDRESS,
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if( snapshot.data!=null) {
                      if (snapshot.data == CheckOutType.ADDRESS) {
                        return CheckOutProfileScreen();
                      }else if(snapshot.data==CheckOutType.SHIPPING){
                        return CheckOutShippingScreen(isFreeShipment);
                      }else if(snapshot.data==CheckOutType.PAYMENT){
                        return CheckOutPaymentScreen(amount);
                      }
                    }
                    else
                      return Container();
                  },
                )
            ),

          ],
        )

    );
  }

}

