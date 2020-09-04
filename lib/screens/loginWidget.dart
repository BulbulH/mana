import 'dart:convert';
import 'dart:io';

//import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/customerCreateModel.dart';
import 'package:flutterecom/models/request/cupdateCustomerUpdateModel.dart';
import 'package:flutterecom/models/responce/createCustomerResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:flutterecom/woohttprequest.dart';
import 'package:http/http.dart' as http;
import 'package:progress_indicators/progress_indicators.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';


import 'package:google_sign_in/google_sign_in.dart';


class LoginWidget extends StatefulWidget {
  @override
  _MyAppState createState() => new _MyAppState();
}

class _MyAppState extends State<LoginWidget> {
//  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  bool isFreeShipment;
  double amount;
  String redirectTo;
  bool isLoading=false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    amount = map['_amount'];
    isFreeShipment = map['_freeShipment']??false;
    redirectTo = map['_nextToGo'];

    return Scaffold(
      backgroundColor: themeBG,
      body: Flex(
        direction: Axis.vertical,
        children: <Widget>[
          Expanded(
              flex: 2,
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
                      "Login "+APPNAME,
                      style: TextStyle(
                        color: themeAppBarItems,
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
              flex: 2,
              child: Center(
                child: Image.asset(
                  'assets/logo.png',
                  width: 150,
                  height: 150,
                ),
              )
          ),
          Expanded(
            flex: 3,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    initiateGoogleLogin();
                  },
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: themeTextColor,
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/google.png',
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            'Sign in with Google',
                            style: TextStyle(
                              fontFamily: "Normal",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: themeBG,
                            ),
                          ),

                        ],
                      )
                  ),
                ),
                Divider(),
                GestureDetector(
                  onTap: () {
                    initiateFacebookLogin();
                  },
                  child: Container(
                      margin: EdgeInsets.all(5),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: themeTextColor,
                      ),
                      width: MediaQuery
                          .of(context)
                          .size
                          .width * 0.8,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            'assets/fb.png',
                            width: 30,
                            height: 30,
                          ),
                          Text(
                            'Sign in with FaceBook',
                            style: TextStyle(
                              fontFamily: "Normal",
                              fontWeight: FontWeight.w600,
                              fontSize: 20,
                              color: themeBG,
                            ),
                          ),

                        ],
                      )
                  ),
                ),
                Divider(),
                Container(width: MediaQuery.of(context).size.width * 0.8,
                  child: Platform.isAndroid ? Container() :
                  SignInWithAppleButton(
                    onPressed: (){
                      appleSignIn();
                    },
                    style: isDarkTheme()?SignInWithAppleButtonStyle.white:SignInWithAppleButtonStyle.black,
                  ),
                )
              ],
            ),
          ),
          Divider(),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.only(right: 20, left: 20),
                child: Text(
                  "Login Required .Signup with fb or google for continue to payment process.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: themeTextColor,
                  ),
                ),
              )
          ),
          isLoading?JumpingDotsProgressIndicator(fontSize: 30.0,):Container(),
          Expanded(
              flex: 1,
              child: Center(
                child: Text(
                  "@Copyright :WooFlux Store.",
                  style: TextStyle(
                    fontFamily: "Normal",
                    fontWeight: FontWeight.w600,
                    fontSize: 10,
                    color: themeTextColor,
                  ),
                ),
              )
          ),
        ],
      ),
    );
  }

  addNewUserToWooComm(String displayName, String email, String phoneNumber) async {

    CreateCustomer customer=getCustomerDetailsPref();
    customer.billing.first_name=customer.first_name=displayName.split(" ")[0];
    customer.billing.last_name=customer.last_name=displayName.split(" ").length>1?displayName.split(" ")[1]:"";
    customer.billing.email=customer.email=customer.billing.email=email;
    customer.billing.phone=phoneNumber;
    customer.username=displayName;

    setCustomerDetailsPref(customer);
    setState(() {isLoading=true;});
    moveToNext();
  }

  Future<void> addToWoocommerce(CreateCustomer customer) async {
    int userid = await WooHttpRequest().getUserWithId( customer);
    if(userid!=0) {
      UpdateCustomer updateCustomer=UpdateCustomer.fromJson( customer.toJson());
      CreateCustomerResponce createCustomerResponce=await WooHttpRequest().updateNewUser(userid, updateCustomer);
      if(createCustomerResponce!=null){
        prefs.setInt(USERID, createCustomerResponce.id);
        moveToNext();
      }
      print(createCustomerResponce);
    }else{
      CreateCustomer createCustomer=CreateCustomer.fromJson( customer.toJson());
      CreateCustomerResponce createCustomerResponce=await WooHttpRequest().addCustomer( createCustomer);
      if(createCustomerResponce!=null){
        prefs.setInt(USERID, createCustomerResponce.id);
        moveToNext();
      }
    }
  }

  Future<void> moveToNext() async {
    orders =await WooHttpRequest().getOrders();
    prefs.setBool(ISLOGIN, true);
    Navigator.pushReplacementNamed(context, redirectTo, arguments: {'_amount': amount,'_freeShipment': isFreeShipment});
  }
  //-------------------Incase If Developer wants serpate implemenation standalone login independent to firebase -----------//


  GoogleSignIn googleauth = new GoogleSignIn();
  void initiateFacebookLogin() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);

    switch (result.status) {
      case FacebookLoginStatus.loggedIn:

        var graphResponse = await http.get(
            'https://graph.facebook.com/v2.12/me?fields=name,first_name,last_name,email&access_token=${result.accessToken.token}');

        var profile = json.decode(graphResponse.body);
        print(profile.toString());
        addNewUserToWooComm( profile["name"], profile["email"], "");
        break;
      case FacebookLoginStatus.cancelledByUser:
        print("");
        break;
      case FacebookLoginStatus.error:
        facebookLogin.loginBehavior = FacebookLoginBehavior.webViewOnly;
        await facebookLogin.logIn(['email']);
        break;
    }
  }
  void initiateGoogleLogin() async {
    googleauth.signIn().then((result){
      result.authentication.then((googleuser){
        addNewUserToWooComm(result.displayName, result.email, "");

      }).catchError((e){
        print(e);
      });}).catchError((e){
      print(e);
    });
  }

  Future<void>  appleSignIn()  async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
      webAuthenticationOptions: WebAuthenticationOptions(
        // TODO: Set the `clientId` and `redirectUri` arguments to the values you entered in the Apple Developer portal during the setup
        clientId: 'com.envato.wcfm',
        redirectUri: Uri.parse(
          'https://flutter-sign-in-with-apple-example.glitch.me/callbacks/sign_in_with_apple',
        ),
      ),
      // TODO: Remove these if you have no need for them
      nonce: 'example-nonce',
      state: 'example-state',
    );

    print(credential);
    addNewUserToWooComm("", "", "");
  }
}
