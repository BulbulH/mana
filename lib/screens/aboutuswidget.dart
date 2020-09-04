import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';

class AboutusScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBG,
      body: body(context)
    );
  }
  Widget body(BuildContext context)
  {
    return Container(
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
                      LocalLanguageString().aboutus,
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
            flex: 13,
            child: aboutUsbody(context),
          )

        ],
      ),
    );
  }

  Widget aboutUsbody(BuildContext context){
    return Container(

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Landing page logo.
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: Container(
                    height:  150,
                    child: Image.asset(
                      // Replace with your landing page logo here.
                      "assets/logo.png",
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                // Landing page website title.
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: SelectableText(
                    // Replace with your landing page website title.
                    "Flutter Applipie",
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: themeTextColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                // Landing page description.
                Container(
                  width: MediaQuery.of(context).size.width * 0.50,
                  padding: EdgeInsets.only(top: 8),
                  child: SelectableText(
                    // Replace with your business or personal website description.
                    LocalLanguageString().aboutusshortdesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: themeTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 8),
                  child: SelectableText(
                    "#flutter #flutterdev ",
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: themeTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    LocalLanguageString().contactus,
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: themeTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 32),
                  child: Text(
                    "--@--.com",
                    style: TextStyle(
                        fontFamily: "Normal",
                        color: themeTextColor,
                        fontSize: 12,
                        fontWeight: FontWeight.w700
                    ),
                  ),
                ),

                Padding(
                  padding: EdgeInsets.only(top: 32),
                  child: Column(
                    children: <Widget>[
                      Container(
                        child: Text(
                          "Supported by Applipie",
                          style: TextStyle(
                              fontFamily: "Normal",
                              color: themeTextColor,
                              fontSize: 12,
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),

                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

}