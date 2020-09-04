import 'package:flutter/material.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:intro_slider/intro_slider.dart';

class IntroScreen extends StatefulWidget  {

  @override
  _IntroScreenState createState() => new _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {

  static final String path = "lib/src/pages/onboarding/smart_wallet_onboarding.dart";
  final slides = [
     Slide(
      title: APPNAME,
      styleTitle:
      TextStyle(color: themeTextColor, fontSize: 25.0, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono'),
      description: "WooFlux Store is your one-stop online shopping marketplace World wide bringing a reliable, hassle-free and convenient shopping experience to your fingertips. ",
      styleDescription: TextStyle(color: themeTextColor, fontSize: 15.0, fontStyle: FontStyle.italic, fontFamily: 'Raleway'),
      pathImage: "assets/splashone.png",
      backgroundColor: themeBG,
    ),
    Slide(
      title: APPNAME,
      styleTitle: TextStyle(color: themeTextColor, fontSize: 25.0, fontWeight: FontWeight.bold, fontFamily: 'RobotoMono'),
      description: "Founded on the precipice of trust and peace of mind, WooFlux Store aims to provide an unfailing and absolutely trouble-free shopping experience to the people of World.",
      styleDescription: TextStyle(color: themeTextColor, fontSize: 15.0, fontStyle: FontStyle.italic, fontFamily: 'Raleway'),
      pathImage: "assets/splashtwo.png",
      backgroundColor: themeBG,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: themeBG,
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            IntroSlider(
              slides: this.slides,
              onDonePress: this.onDonePress,
              onSkipPress: this.onSkipPress,
              colorSkipBtn: themeAppBarItems,
              highlightColorSkipBtn: themeAppBarItems,

              // Next, Done button
              colorDoneBtn: themeAppBarItems,
              highlightColorDoneBtn: themeAppBarItems,
              // Dot indicator
              colorDot: themeAppBarItems,
              colorActiveDot: Colors.indigo,
              sizeDot: 13.0,
            )
          ],
        ),
      ),
    );
  }



  void onDonePress() {
    Navigator.pushReplacementNamed(context, "/home");
  }

  void onSkipPress() {
    Navigator.pushReplacementNamed(context, "/home");
  }

}