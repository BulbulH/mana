import 'package:flutter/material.dart';
import 'package:flutterecom/payments/config.dart';
import 'package:flutterecom/payments/paypal.dart';
import 'package:flutterecom/payments/tap.dart';
import 'package:flutterecom/screens/checkoutfragments/checkoutShippingWidget.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/woohttprequest.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
class CheckOutPaymentScreen extends StatefulWidget {

  double amount;
  CheckOutPaymentScreen(this.amount);
  @override
  _CheckOutPaymentScreenState createState() => new _CheckOutPaymentScreenState();
}

class _CheckOutPaymentScreenState extends State<CheckOutPaymentScreen>  {

  final String REQUIRED="__ *";
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  Razorpay _razorpay ;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _razorpay = Razorpay();
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
    bool tap=false;
    bool paypal=false;
    bool razorpay=false;
    bool cod=false;
    bool cheque=false;
    bool bacs=false;

    paymentGateway.forEach((element) {
      if(element.id=="tap"&&element.enabled){
        tap=true;
      }
      else if(element.id=="paypal"&&element.enabled){
        paypal=true;
      }
      else if(element.id=="razorpay"&&element.enabled){
        razorpay=true;
      }
      else if(element.id=="cod"&&element.enabled){
        cod=true;
      }
      else if(element.id=="cheque"&&element.enabled){
        cheque=true;
      }
      else if(element.id=="bacs"&&element.enabled){
        bacs=true;
      }
    });


    ProgressDialog pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: true, showLogs: false);
    pr.style(
        message: LocalLanguageString().processingorderrequest+'...',
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );

    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(

            padding: EdgeInsets.all(15),
            margin: EdgeInsets.only(bottom: 30,top: 60),
            child:  Text(
              LocalLanguageString().paymentdescription,
              textAlign:TextAlign.center,
              style: TextStyle(
                fontFamily: "Normal",
                fontWeight: FontWeight.w600,
                fontSize: 15,
                color: themeTextColor,
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Text(
                LocalLanguageString().total,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: themeTextColor,
                ),
              ),
              Text(
                "${widget.amount+shippingCost} ${currencyCode==null?"":currencyCode}",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: themeTextColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10.0,),
          tap? Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: RaisedButton(
              color: themeAppBarItems,
              onPressed: () async {
                pr.show();
                String url=await WooHttpRequest().getTapUrl(widget.amount,shippingCost,currencyCode);
                pr.hide();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewTap(url)
                  ),
                );
              },
              child: Text(
                "pay via Tap",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: themeBG,
                ),
              ),
            ),
          ):Container(),
          paypal?Container(
            padding: EdgeInsets.all(10),
            width: double.infinity,
            child: RaisedButton(
              color: themeAppBarItems,
              onPressed: () async {
                pr.show();
                String tokenpaypal=await WooHttpRequest().getAuthPaypal();
                Map urls=await WooHttpRequest().paymentPaypal(tokenpaypal,widget.amount,shippingCost,currencyCode);
                pr.hide();
                if(urls!=null)
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => WebViewPaypal(tokenpaypal,urls["approval_url"],urls["execute"])
                  ),
                );
              },
              child: Text(
                "Pay via PayPal",
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: themeBG,
                ),
              ),
            ),
          ):Container(),
//          razorpay?Container(
//            padding: EdgeInsets.all(10),
//            width: double.infinity,
//            child: RaisedButton(
//              color: themeAppBarItems,
//              onPressed: () async {
//                _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentSuccessResponse response) {
//                  WooHttpRequest().putNewOrder("razorpay","Razorpay").then((value) {
//                    Navigator.pushReplacementNamed(context, "/home");
//                  });
//                });
//                _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
//                  print("");
//                });
//                var config=getRazorPayConfig(widget.amount,shippingCost,currencyCode);
//                _razorpay.open(config);
//              },
//              child: Text(
//                "Pay via RazorPay",
//                style: TextStyle(
//                  fontFamily: "Normal",
//                  fontWeight: FontWeight.w600,
//                  fontSize: 20,
//                  color: themeBG,
//                ),
//              ),
//            ),
//          ):Container()
        ],
      ),
    );
  }

}