import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/ToastUtils.dart';
import 'package:flutterecom/emuns/coupon.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllCouponResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/commonMethod.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:intl/intl.dart';
import 'package:progress_indicators/progress_indicators.dart';

class CartScreen extends StatefulWidget {
  bool showAppBar = false;

  CartScreen(this.showAppBar);
  @override
  _CartScreenState createState() => new _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  int REFRESHDELAY = 1;
  List<Line_items> cartList;
  CouponSelection couponSelection = CouponSelection.TextField;
  TextEditingController couponController = TextEditingController();
  GetAllCoupon _coupon = null;
  double totalCost = 0;
  String itemPriceText;
  String itemSubtotalText;
  double price = 0.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute.of(context).settings.arguments as Map;
    if (map != null && map.containsKey("_showAppBar"))
      widget.showAppBar = map['_showAppBar'];

    cartList = getCartProductsPref();
    getTotalPrice();

    return Scaffold(backgroundColor: themeBG, body: body());
  }

  Widget body() {
    return Container(
        child: widget.showAppBar
            ? Flex(
                direction: Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Expanded(flex: 1, child: Container()),
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
                                  padding: EdgeInsets.all(5),
                                  child: Icon(
                                    Icons.arrow_back,
                                    color: themeAppBarItems,
                                    size: 25,
                                  ),
                                )),
                            Text(
                              LocalLanguageString().productscart,
                              style: TextStyle(
                                color: themeAppBarItems,
                                fontSize: 22.0,
                                fontFamily: "Header",
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(),
                          ],
                        ),
                      )),
                  Expanded(
                      flex: 13,
                      child: Column(
                        children: <Widget>[
                          Flexible(
                            child: ListView.builder(
                              itemCount: cartList.length,
                              itemBuilder: (context, int index) {
                                return cartItems(cartList[index], index);
                              },
                            ),
                          ),
                          Divider(),
                          _checkoutSection(context)
                        ],
                      ))
                ],
              )
            : Column(
                children: <Widget>[
                  Flexible(
                    child: ListView.builder(
                      itemCount: cartList.length,
                      itemBuilder: (context, int index) {
                        return cartItems(cartList[index], index);
                      },
                    ),
                  ),
                  Divider(),
                  _checkoutSection(context)
                ],
              ));
  }

  double boxSize = 70;
  Widget cartItems(Line_items item, int index) {
    GetAllProducts getallproduct = getProductFromId(item.product_id);
    Variations variant = null;
    if (getallproduct == null) return Container();

    variant = item.variation_id == -1
        ? null
        : getallproduct.variations.firstWhere(
            (element) => element.id == item.variation_id,
            orElse: null);

    String image = null;
    if (variant != null)
      image = variant != null
          ? variant.images.length > 0 ? variant.images[0].src : null
          : null;
    else
      image = getallproduct != null
          ? getallproduct.images.length > 0 ? getallproduct.images[0].src : null
          : null;
    if (variant != null)
      price = double.parse(variant.price);
    else {
      try {
        price = double.parse(getallproduct.price);
      } on Exception catch (e) {
        price = 0;
      }
    }

    itemPriceText = LocalLanguageString().price +
        " :" +
        " ${price} ${currencyCode == null ? "" : currencyCode} ";
    itemSubtotalText = LocalLanguageString().subtotal +
        " :" +
        " ${price * item.quantity} ${currencyCode == null ? "" : currencyCode} ";

    if (couponSelection == CouponSelection.Accepted &&
        _coupon != null &&
        (!_coupon.exclude_sale_items ||
            (_coupon.exclude_sale_items && !getallproduct.on_sale))) {
      {
        bool couponAppicableOnProducts =
            getIsCouponValidInProducts(_coupon, getallproduct);
        bool couponAppicableOnCateogries =
            getIsCouponValidInCategories(_coupon, getallproduct);

        print("");
        if (couponAppicableOnCateogries || couponAppicableOnProducts) {
          if (_coupon.discount_type == "fixed_product")
            price = (price - double.parse(_coupon.amount)) <= 0
                ? 0
                : (price - double.parse(_coupon.amount));

          totalCost += (price * item.quantity);

          if (_coupon.discount_type == "fixed_cart" &&
              index == cartList.length - 1)
            totalCost = (totalCost - double.parse(_coupon.amount)) <= 0
                ? 0
                : (totalCost - double.parse(_coupon.amount));
          else if (_coupon.discount_type == "percent" &&
              index == cartList.length - 1)
            totalCost = (totalCost -
                        (double.parse(_coupon.amount) / 100) * totalCost) <=
                    0
                ? 0
                : (totalCost -
                    (double.parse(_coupon.amount) / 100) * totalCost);

          itemPriceText = LocalLanguageString().price +
              " :" +
              " ${price} ${currencyCode == null ? "" : currencyCode} ";
          itemSubtotalText = LocalLanguageString().subtotal +
              " :" +
              " ${price * item.quantity} ${currencyCode == null ? "" : currencyCode} ";
        } else
          totalCost += (price * item.quantity);
      }
    } else
      totalCost += (price * item.quantity);

    return Container(
      height: 130,
      padding: EdgeInsets.all(0),
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: transparent,
        borderRadius: BorderRadius.circular(20.0),
        border: Border.all(
          color: transparent,
          width: 0.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
              padding: EdgeInsets.all(5),
              child: image != null
                  ? CachedNetworkImage(
                      imageUrl: image,
                      imageBuilder: (context, imageProvider) => Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(
                                  10.0) //                 <--- border radius here
                              ),
                          image: DecorationImage(
                            image: imageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      placeholder: (context, url) => Center(
                          child: JumpingDotsProgressIndicator(
                        fontSize: 20.0,
                      )),
                      errorWidget: (context, url, error) => Center(
                        child: Icon(Icons.filter_b_and_w),
                      ),
                    )
                  : Container(color: Colors.transparent)),
          Flexible(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Flexible(
                        child: Container(
                          child: Text(
                            "${getallproduct != null ? getallproduct.title != null ? getallproduct.title : "" : ""}"
                                .toUpperCase(),
                            overflow: TextOverflow.fade,
                            softWrap: true,
                            style: TextStyle(
                                color: themeTextColor,
                                fontSize: 15,
                                fontFamily: "Normal",
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        child: IconButton(
                          onPressed: () {
                            delCartProductsPref(item.product_id)
                                .then((isdeleted) {
                              setState(() {});
                            });
                          },
                          color: themePrimary,
                          icon: Icon(Icons.delete),
                          iconSize: 20,
                        ),
                      )
                    ],
                  ),
                  Text(
                    itemPriceText,
                    style: TextStyle(
                        color: themeTextColor,
                        fontSize: 14,
                        fontFamily: "Normal",
                        fontWeight: FontWeight.w700),
                  ),
                  Text(
                    itemSubtotalText,
                    style: TextStyle(
                      color: themeTextColor,
                      fontSize: 14,
                      fontFamily: "Normal",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Row(
                    children: <Widget>[
                      Spacer(),
                      Row(
                        children: <Widget>[
                          InkWell(
                            onTap: () {
                              if (item.quantity > 1) item.quantity -= 1;
                              addORupdateCartProductsPref(item)
                                  .then((isUpdated) {
                                setState(() {});
                              });
                            },
                            splashColor: transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.remove,
                                  color: themePrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          Card(
                            color: themeBG,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text(
                                "${item.quantity}",
                                style: TextStyle(
                                    fontFamily: "Normal",
                                    color: themeTextColor,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700),
                              ),
                            ),
                          ),
                          SizedBox(
                            width: 4,
                          ),
                          InkWell(
                            onTap: () {
                              if (item.quantity < 30) item.quantity += 1;
                              addORupdateCartProductsPref(item)
                                  .then((isUpdated) {
                                setState(() {});
                              });
                            },
                            splashColor: transparent,
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.add,
                                  color: themePrimary,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
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
              (coupons != null && coupons.length > 0)
                  ? getCoupon()
                  : Container()
            ],
          ),
          Container(
              margin: EdgeInsets.all(7),
              child: Row(
                children: <Widget>[
                  Text(
                    LocalLanguageString().checkoutprice + " :",
                    style: TextStyle(
                      color: themeTextColor,
                      fontFamily: "Normal",
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  /*FutureBuilder(
                      future: getTotalPrice(),
                      initialData: "Loading ..",
                      builder: (BuildContext context, AsyncSnapshot<String> text) {
                        return Text(
                          text.data,
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
                  ),
                ],
              )),
          GestureDetector(
            onTap: () {
              if (totalCost > 0) {
                Future.delayed(Duration(seconds: REFRESHDELAY), () {
                  bool isFreeShipment =
                      (couponSelection == CouponSelection.Accepted &&
                          _coupon != null &&
                          _coupon.free_shipping);
                  if (prefs.getBool(ISLOGIN) ?? false) {
                    Navigator.pushNamed(context, '/checkOutTab', arguments: {
                      '_amount': totalCost,
                      '_freeShipment': isFreeShipment
                    });
                  } else
                    Navigator.pushNamed(context, '/login', arguments: {
                      '_amount': totalCost,
                      '_freeShipment': isFreeShipment,
                      '_nextToGo': "/checkOutTab"
                    });
                });
              } else
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
                      fontWeight: FontWeight.bold),
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
                  _coupon = coupons.firstWhere(
                      (element) =>
                          element.code.toLowerCase() ==
                          couponController.text.toLowerCase(),
                      orElse: () => null);
                  if (_coupon != null) {
                    bool couponAppicableOnProducts =
                        getIsCouponValidInAllProducts(_coupon);
                    bool couponAppicableOnCategories =
                        getIsCouponValidInAllCategories(_coupon);

                    double minimum_amount = double.parse(
                        _coupon.minimum_amount != null &&
                                _coupon.minimum_amount != ""
                            ? _coupon.minimum_amount
                            : "0.0");
                    double maximum_amount = double.parse(
                        _coupon.maximum_amount != null &&
                                _coupon.maximum_amount != ""
                            ? _coupon.maximum_amount
                            : "0.0");
                    bool inAmountInCouponRange = totalCost > minimum_amount &&
                        totalCost < maximum_amount;
                    bool isDateNotPassed = DateTime.now().isBefore(
                        DateTime.parse(_coupon.date_expires).toLocal());
                    bool isUsageInLimit =
                        _coupon.usage_count < _coupon.usage_limit;

                    print("");
                    if (isDateNotPassed &&
                        isUsageInLimit &&
                        inAmountInCouponRange &&
                        (couponAppicableOnProducts ||
                            couponAppicableOnCategories)) {
                      couponSelection = CouponSelection.Accepted;
                      print("");
                    }
                  } else {
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
              ))
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
                  child: Text(
                    LocalLanguageString().reentercoupon,
                    textAlign: TextAlign.end,
                    style: TextStyle(
                      fontFamily: "Header",
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: themeTextColor,
                    ),
                  ),
                ))
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
          ));
    else
      return Container();
  }

  Future<String> getTotalPrice() {
    totalCost = 0.0;
    //cartList = getCartProductsPref();
    //GetAllProducts getallproduct= getProductFromId(cartList[1].product_id);
    cartList.forEach((element) async {
      if (getProductFromId(element.product_id) != null) {
        double price;
        try {
          price = double.parse(getProductFromId(element.product_id).price);
        } on Exception catch (e) {
          price = 0.0;
        }

        totalCost += price * element.quantity;
      }
    });
    setState(() {

    });

/*return Future.delayed(
        Duration(seconds: REFRESHDELAY), () => totalCost.toString());*/
  }
}
