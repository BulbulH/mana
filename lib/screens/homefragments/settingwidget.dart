import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterecom/dialogs/LanguagePickerDialog.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/screens/homefragments/categoryWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';

class SettingScreen extends StatefulWidget {
  Function callback;
  SettingScreen(this.callback);
  @override
  _SettingScreenState createState() => new _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  RateMyApp rateMyApp;
  @override
  void dispose() {
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    rateMyApp = RateMyApp(
      preferencesPrefix: 'RateOurApp',
      minDays: 7,
      minLaunches: 10,
      remindDays: 7,
      remindLaunches: 10,
      googlePlayIdentifier: 'com.envator.ecom',
      appStoreIdentifier: '1517507827',
    );
    rateMyApp.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        body: NestedScrollView(
            headerSliverBuilder: (BuildContext context,
                bool innerBoxIsScrolled) {
              return <Widget>[
                SliverAppBar(
                  backgroundColor: themeBG,
                  expandedHeight: 200.0,
                  floating: false,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    centerTitle: true,

                    background: Stack(
                      alignment: Alignment.topCenter,
                      children: <Widget>[
                        Container(),
                        Image.asset(
                          "assets/logo.png",
                          fit: BoxFit.contain,
                        ),
                      ],
                    )
                  ),
                )
              ];
            },
            body: Container(
              color: themeBG,
              child: ListView(
                children: [
                  Container(
                      color: themeBG,
                      padding: EdgeInsets.only(top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                      child: Column(
                        children: <Widget>[
                          Divider(),
                          Text(
                            LocalLanguageString().profilesetting,
                            style: TextStyle(
                              fontFamily: "Header",
                              fontWeight: FontWeight.w600,
                              fontSize: 18,
                              color: themeTextColor,
                            ),
                          ),
                          getListItem(Icons.supervised_user_circle,
                              getCustomerDetailsPref().username==""?"Name":getCustomerDetailsPref().username, "", "",
                              null, () {
                                print("");
                              }),
                          getListItem(
                              Icons.email, getCustomerDetailsPref().email==""?"Email":getCustomerDetailsPref().email, "",
                              "", null, () {
                            print("");
                          }),
                          getListItem(Icons.contacts,
                              LocalLanguageString().profileupdate, "", "",
                              Icons.arrow_forward_ios, () {
                                Navigator.pushNamed(context, '/userprofile');
                              }),
                        ],
                      ),
                  ), Container(
                      padding: EdgeInsets.only(top: 36.0, left: 6.0, right: 6.0, bottom: 6.0),
                      color: themeBG,
                      child:  Column(
                        children: <Widget>[
                          Divider(),
                          Text(
                            LocalLanguageString().generalsetting,
                            style: TextStyle(
                              fontFamily: "header",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: themeTextColor,
                            ),
                          ),
                          getListItem(Icons.favorite_border,
                              LocalLanguageString().wishlist, "", "",
                              Icons.arrow_forward_ios, () {
                                Navigator.pushNamed(context, '/wishlist');
                              }),

                          getListItem(
                              Icons.history, LocalLanguageString().orders, "",
                              "", Icons.arrow_forward_ios, () {
                            Navigator.pushNamed(context, '/orders');
                          }),
                          getListThemeOption(Icons.brightness_4, LocalLanguageString().themeoptions, "",""),
                          getListItem(
                              Icons.dvr, LocalLanguageString().aboutus, "",
                              "", Icons.arrow_forward_ios, () {
                            Navigator.pushNamed(context, '/aboutus');
                          }),
                          getListItem(
                              Icons.share, LocalLanguageString().share, "",
                              "", Icons.arrow_forward_ios, () {
                            Share.share(Platform.isIOS
                                ? "YOUR IPHONE APP LINK "
                                : "YOUR ANDROID APP LINK",
                                subject: 'Get this link from developer console');
                          }),

                        ],
                      )
                  )
                ],
              ),
            )
        )
    );
  }


  void rateApp() {
      rateMyApp.showRateDialog(
        context,
        title: 'Rate this app',
        // The dialog title.
        message: 'If you like this app, please take a little bit of your time to review it !\nIt really helps us and it shouldn\'t take you more than one minute.',
        // The dialog message.
        rateButton: 'RATE',
        // The dialog "rate" button text.
        noButton: 'NO THANKS',
        // The dialog "no" button text.
        laterButton: 'MAYBE LATER',
        // The dialog "later" button text.
        listener: (
            button) { // The button click listener (useful if you want to cancel the click event).
          switch (button) {
            case RateMyAppDialogButton.rate:
              print('Clicked on "Rate".');
              break;
            case RateMyAppDialogButton.later:
              print('Clicked on "Later".');
              break;
            case RateMyAppDialogButton.no:
              print('Clicked on "No".');
              break;
          }

          return true; // Return false if you want to cancel the click event.
        },
        ignoreIOS: false,
        // Set to false if you want to show the native Apple app rating dialog on iOS.
        dialogStyle: DialogStyle(), // Custom dialog styles.
      );

      // Or if you prefer to show a star rating bar :

      rateMyApp.showStarRateDialog(
        context,
        title: 'Rate this app',
        // The dialog title.
        message: 'You like this app ? Then take a little bit of your time to leave a rating :',
        // The dialog message.
        actionsBuilder: (context,
            stars) { // Triggered when the user updates the star rating.
          return [
            // Return a list of actions (that will be shown at the bottom of the dialog).
            FlatButton(
              child: Text('OK'),
              onPressed: () async {
                print('Thanks for the ' +
                    (stars == null ? '0' : stars.round().toString()) +
                    ' star(s) !');
                // You can handle the result as you want (for instance if the user puts 1 star then open your contact page, if he puts more then open the store page, etc...).
                await rateMyApp.callEvent(RateMyAppEventType
                    .rateButtonPressed); // This allows to mimic the behavior of the default "Rate" button. See "Advanced > Broadcasting events" for more information.

                Navigator.pop(context);
              },
            ),
          ];
        },
        ignoreIOS: false,
        // Set to false if you want to show the native Apple app rating dialog on iOS.
        dialogStyle: DialogStyle( // Custom dialog styles.
          titleAlign: TextAlign.center,
          messageAlign: TextAlign.center,
          messagePadding: EdgeInsets.only(bottom: 20),
        ),
        starRatingOptions: StarRatingOptions(), // Custom star bar rating options.
      );
  }
  Widget getListItem(IconData icon,String title,String extendedTitle,String description,IconData trailing,Function callback){

    return ListTile(
      onTap: callback,
      leading: Icon(
        icon,
        color: themePrimary,
      ),
      title: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontFamily: "Normal",
                color: themeTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Text(
            extendedTitle,
            style: TextStyle(
              fontFamily: "Normal",
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: themeTextColor,
            ),
          ),
        ],
      ),
      subtitle: Text(
          description,
        style: TextStyle(
          fontFamily: "Normal",
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: themeTextColor,
        ),
      ),
      trailing: Icon(
        trailing,
      ),
    );
  }

  getListThemeOption(IconData icon,String title,String extendedTitle,String description ){

    List<bool> isSelected = [isDarkTheme(), !isDarkTheme()];
    ToggleButtons toggleButtons= ToggleButtons(
      borderColor: transparent,
      borderWidth: 1,
      borderRadius: BorderRadius.circular(10),
      selectedColor: themeTextHighLightColor.withAlpha(70),
      fillColor: themeTextColor.withAlpha(70),
      children: <Widget>[
        Text(
          'Dark',
          style: TextStyle(
              fontFamily: "Normal",
              color: themeTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w800
          ),
        ),
        Text(
          'Light',
          style: TextStyle(
              fontFamily: "Normal",
              color: themeTextColor,
              fontSize: 14,
              fontWeight: FontWeight.w800
          ),
        ),
      ],
      onPressed: (int index) {
        setState(() {
          for (int i = 0; i < isSelected.length; i++) {
            isSelected[i] = i == index;
          }
          setDarkTheme(isSelected[0]);
          widget.callback();
        });
      },
      isSelected: isSelected,
    );

    return ListTile(
      leading: Icon(
        icon,
        color: themePrimary,
      ),
      title: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                fontFamily: "Normal",
                color: themeTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w800
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Text(
            extendedTitle,
            style: TextStyle(
              fontFamily: "Normal",
              fontWeight: FontWeight.w600,
              fontSize: 20,
              color: themeTextColor,
            ),
          ),
        ],
      ),
      subtitle: Text(description),
      trailing: Container(
        decoration: BoxDecoration(
          border: Border.all(width: 0.0),
          borderRadius: BorderRadius.all(
              Radius.circular(10.0) //                 <--- border radius here
          ),
        ),
        child:  Wrap(
          direction: Axis.horizontal,
          children: <Widget>[
            InkWell(
              onTap: (){
                setState(() async {
                  await setDarkTheme(true);
                  widget.callback();
                });
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  'Dark',
                  style: TextStyle(
                      fontFamily: "Header",
                      color: isDarkTheme()?themeTextHighLightColor:themeTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: (){
                setState(() async {
                  await setDarkTheme(false);
                  widget.callback();
                });
              },
              child: Container(
                margin: EdgeInsets.all(10),
                child: Text(
                  'Light',
                  style: TextStyle(
                      fontFamily: "Header",
                      color: !isDarkTheme()?themeTextHighLightColor:themeTextColor,
                      fontSize: 14,
                      fontWeight: FontWeight.w800
                  ),
                ),
              ),
            ),

          ],),
      )
    );
  }

}