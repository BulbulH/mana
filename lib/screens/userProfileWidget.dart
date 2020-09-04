import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/profileInfo.dart';
import 'package:flutterecom/bloc/bloc_checkout.dart';
import 'package:flutterecom/emuns/checkOutType.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:percent_indicator/percent_indicator.dart';

class UserProfileScreen extends StatelessWidget {
  static final String path = "lib/src/pages/profile/profile3.dart";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBG,
      body: Container(
        child: Flex(
          direction: Axis.vertical,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
                flex: 1,
                child: Container()
            ),
            Expanded(
                flex: 1,
                child: Container(
                  color: themeAppBar,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                          onTap: (){
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
                        LocalLanguageString().updateprofile,
                        style: TextStyle(
                            color: themeAppBarItems,
                            fontSize: 20.0,
                            fontFamily: "Header"
                        ),
                      ),
                       Container(),
                    ],
                  ),
                )
            ),
            Expanded(
              flex: 13,
              child: Container(
                padding: EdgeInsets.all(15),
                child: ProfileInfo( onTap: (){
                  Navigator.of(context).pop();
                },),
              )
            )
          ],
        ),
      ) ,
    );
  }

}

