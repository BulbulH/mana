import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/ToastUtils.dart';
import 'package:flutterecom/WidgetHelper/homeCategoryHeader.dart';
import 'package:flutterecom/WidgetHelper/filters.dart';
import 'package:flutterecom/WidgetHelper/homeTagHeader.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/emuns/coupon.dart';
import 'package:flutterecom/list_views/home_product_grid_view.dart';
import 'package:flutterecom/list_views/home_product_list_view.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllCouponResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/homefragments/cartWidget.dart';
import 'package:flutterecom/screens/homefragments/categoryWidget.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/screens/userProfileWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/commonMethod.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';

_ProductScreenState ProductScreenState;
double checkOutHeight=0;
class ProductScreen extends StatefulWidget  {

  @override
  _ProductScreenState createState() {
    ProductScreenState= _ProductScreenState();
    return ProductScreenState;
  }
}

class _ProductScreenState extends State<ProductScreen> with TickerProviderStateMixin , CategoryButton{
  AnimationController animationController;

  int REFRESHDELAY=1;
  List<Line_items> cartList;
  CouponSelection couponSelection=CouponSelection.TextField;
  TextEditingController couponController = TextEditingController();
  GetAllCoupon _coupon=null;
  String itemPriceText;
  String itemSubtotalText;
  double totalCost=0;

  @override
  Future<void> initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    getTotalPrice();


    return Scaffold(
      backgroundColor: themeBG,
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  getSearchBarUI(),
                  /*   specialWCFMHeader(),
                  TagSlidingCard().getTagsHeader(),*/
                  //@todo top image card
                 // getCategoryUI(context),
                  //Divider(),
                  getPopularProductUI(),
                ],
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              height: checkOutHeight,
              color: themeBG,
              width: double.infinity,
              child:  SingleChildScrollView(child: _checkoutSection(context)),
            )
          ],
        ),

      )
    );

  }

  Widget _checkoutSection(BuildContext context) {
    return Material(
      color: themeTextColor.withAlpha(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Stack(
            children: [
              (coupons!=null&&coupons.length>0)?
              getCoupon():Container()
            ],
          ),
          Container(
              margin: EdgeInsets.all(7),
              child: Row(
                children: <Widget>[
                  Text(
                    LocalLanguageString().checkoutprice+" :",
                    style: TextStyle(
                      color: themeTextColor,
                      fontFamily: "Normal",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                 /* FutureBuilder(
                      future: getTotalPrice(),
                      initialData: "Loading ..",
                      builder: (BuildContext context, AsyncSnapshot<String> text) {
                        return Text(
                          totalCost.toString(),
                          style: TextStyle(
                            color: themeTextColor,
                            fontFamily: "Normal",
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        );
                      })*/
                  Text(
                    totalCost.toString(),
                    style: TextStyle(
                      color: themeTextColor,
                      fontFamily: "Normal",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  )

                ],
              )
          ),
          GestureDetector(
            onTap: () {
              if (totalCost > 0) {
                Future.delayed(  Duration(seconds: REFRESHDELAY), () {
                  bool isFreeShipment=(couponSelection==CouponSelection.Accepted && _coupon!=null && _coupon.free_shipping);
                  if(prefs.getBool(ISLOGIN) ?? false) {
                    Navigator.pushNamed(context, '/checkOutTab', arguments: {'_amount': totalCost,'_freeShipment': isFreeShipment});
                  } else
                    Navigator.pushNamed(context, '/login', arguments: {'_amount': totalCost,'_freeShipment': isFreeShipment,'_nextToGo': "/checkOutTab"});

                });
              }
              else
                ToastUtils.showCustomToast(context, "Cart must not be empty");
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Text(
                  LocalLanguageString().checkout,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Header",
                      color: themeTextColor,
                      fontSize: 24,
                      fontWeight: FontWeight.bold
                  ),
                ),
              ),
            ),
          )

        ],
      ),
    );
  }
  Widget getCoupon() {
    if (couponSelection == CouponSelection.TextField)
      return Flex(
        direction: Axis.horizontal,
        children: [
          Expanded(
            flex: 8,
            child: Container(
              margin: EdgeInsets.all(7),
              child: TextFormField(
                controller: couponController,
                textCapitalization: TextCapitalization.characters,
                decoration: InputDecoration(
                  labelText: LocalLanguageString().entercoupon,
                  //fillColor: Colors.green
                ),
              ),
            ),
          ),
          Expanded(
              flex: 2,
              child: GestureDetector(
                onTap: () {
                  _coupon = coupons.firstWhere((element) => element.code
                      .toLowerCase() == couponController.text.toLowerCase(),
                      orElse: () => null);
                  if (_coupon != null) {
                    bool couponAppicableOnProducts = getIsCouponValidInAllProducts(
                        _coupon);
                    bool couponAppicableOnCategories = getIsCouponValidInAllCategories(
                        _coupon);


                    double minimum_amount = double.parse(
                        _coupon.minimum_amount != null &&
                            _coupon.minimum_amount != "" ? _coupon
                            .minimum_amount : "0.0");
                    double maximum_amount = double.parse(
                        _coupon.maximum_amount != null &&
                            _coupon.maximum_amount != "" ? _coupon
                            .maximum_amount : "0.0");
                    bool inAmountInCouponRange = totalCost > minimum_amount &&
                        totalCost < maximum_amount;
                    bool isDateNotPassed = DateTime.now().isBefore(
                        DateTime.parse(_coupon.date_expires).toLocal());
                    bool isUsageInLimit = _coupon.usage_count <
                        _coupon.usage_limit;


                    print("");
                    if (isDateNotPassed && isUsageInLimit &&
                        inAmountInCouponRange && (couponAppicableOnProducts ||
                        couponAppicableOnCategories)) {
                      couponSelection = CouponSelection.Accepted;
                      print("");
                    }
                  }
                  else {
                    couponSelection = CouponSelection.ErrorMessage;
                  }
                  setState(() {});
                },
                child: Container(
                  alignment: Alignment.center,
                  child: Text(
                    LocalLanguageString().apply,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: "Header",
                      fontWeight: FontWeight.bold,
                      fontSize: 17,
                      color: themeTextColor,
                    ),
                  ),
                ),
              )
          )


        ],
      );
    if (couponSelection == CouponSelection.ErrorMessage)
      return Container(
        margin: EdgeInsets.all(7),
        child: Flex(
          direction: Axis.horizontal,
          children: [
            Expanded(
              flex: 1,
              child: Text(
                LocalLanguageString().couponnotfound,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: themeTextColor,
                ),
              ),
            ),
            Expanded(
                flex: 1,
                child: GestureDetector(
                  onTap: () {
                    couponSelection = CouponSelection.TextField;
                    setState(() {});
                  },
                  child: Text(LocalLanguageString().reentercoupon,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: "Header",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: themeTextColor,
                    ),
                  ),
                )
            )
          ],
        ),
      );
    if (couponSelection == CouponSelection.Accepted)
      return Container(
          margin: EdgeInsets.all(7),
          child: Text(
            LocalLanguageString().couponapplied,

            style: TextStyle(
              fontFamily: "Header",
              fontWeight: FontWeight.bold,
              fontSize: 17,
              color: themeTextColor,
            ),
          )
      );
    else
      return Container();
  }

  Future<String> getTotalPrice() async {
    totalCost=0.0;
      cartList=getCartProductsPref();
      //GetAllProducts getallproduct= getProductFromId(cartList[1].product_id);
      cartList.forEach((element) async {
        if(getProductFromId(element.product_id)!=null) {
          double price;
          try {
            price= double.parse( getProductFromId(element.product_id).price);
          } on Exception catch (e) {
            price =0.0;
          }

          totalCost+=price*element.quantity;
        }
    });
      if(totalCost==0){
      checkOutHeight=0;
    }else
      checkOutHeight=100;
  }

  Widget specialWCFMHeader() {
    return Container(
      padding: EdgeInsets.all(10),
      color: themeTextColor.withAlpha(60),
      alignment: Alignment.centerLeft,
      height: 150.0,
      child: FadeAnimatedTextKit(
          onTap: () {
          },
          text: [
            "WooFlux !",
            "Weekly tag sales",
            "Dokan & WCFM"
          ],
          textStyle: TextStyle(
              color: themeBG,
              fontSize: 22.0,
              fontWeight: FontWeight.bold
          ),
          textAlign: TextAlign.center,
          alignment: AlignmentDirectional.topStart // or Alignment.topLeft
      ),
    );
  }
  Widget getPopularProductUI() {
    return Container(
      child:  Column(
        children: [
          Container(
            padding:  EdgeInsets.all( 8.0,),
            margin:  EdgeInsets.only(top: 13.0,),
            alignment: Alignment.centerLeft,
            child: Text(
              LocalLanguageString().popularproducts,
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.w900,
                fontSize: 18,
                letterSpacing: 0.27,
                fontFamily: "Normal",
                color: themeTextColor,
              ),
            ),
          ),
          Container(
              child: ( prefs.getBool(ISGRID) ?? false)?
              StreamBuilder(
                stream: homeBloc.getProductStreamController.stream,
                initialData: products,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data!=null?Container(
                    child: HomeProductGridView(
                      products: snapshot.data,
                      callBack: (String productId) {
                        Navigator.pushNamed(context, '/homeproductdetail', arguments: {'_productId': productId});
                      },
                    ),
                  ):Container();
                },
              ):
              StreamBuilder(
                stream: homeBloc.getProductStreamController.stream,
                initialData: products,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  return snapshot.data!=null?HomeProductListView(
                    products: snapshot.data,
                    callBack: (String productId) {
                      Navigator.pushNamed(context, '/homeproductdetail', arguments: {'_productId': productId});
                    },
                  ):Container();
                },
              ),
          ),

        ],
      ),
    );

  }


  Widget getSearchBarUI() {

    return Padding(
      padding: const EdgeInsets.only(top: 0, left: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 6,
            child: Padding(
              padding: const EdgeInsets.only(top: 0, bottom: 10),
              child: Row(
                children: <Widget>[
                  SizedBox(
                      width: 60,
                      height: 60,
                      child: Icon(
                        Icons.search,
                        color: themeTextColor,
                      )
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        style: TextStyle(
                          fontFamily: "Normal",
                          fontWeight: FontWeight.w600,
                          fontSize: 12,
                          color: themeTextColor,
                        ),
                        decoration: InputDecoration(
                          labelText: LocalLanguageString().searchforproducts,
                          border: InputBorder.none,
                          helperStyle: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Normal",
                            color: themeTextColor,
                          ),
                          labelStyle: TextStyle(
                            fontSize: 12,
                            color: themeTextColor,
                            fontWeight: FontWeight.w600,
                            fontFamily: "Normal",
                          ),
                        ),
                        onChanged: (value) {
                          List<GetAllProducts> _products=new List();

                          products.forEach((data){
                            if (data.title.toLowerCase().contains(value.toLowerCase())){
                              _products.add(data);
                            }
                          });
                          homeBloc.refreshProducts(_products);

                        },
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child:  IconButton(
                icon: Icon(
                  Icons.list,
                  color: themeTextColor,
                ),
                onPressed: () {
                  prefs.setBool(ISGRID,!( prefs.getBool(ISGRID) ?? false)).then((isDone){
                    setState(() {});
                  });
                },
              ),
            ),
          ),Expanded(
            flex: 1,
            child:Center(
              child:  IconButton(
                icon: Icon(
                  Icons.filter_list,
                  color: themeTextColor,
                ),
                onPressed: () {
                  showModalBottomSheet(
                    backgroundColor: themeBG,
                    context: context,
                    builder: (sheetContext) => BottomSheet(
                      builder: (_) => Filters( ),
                      onClosing: (){},
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }


}
