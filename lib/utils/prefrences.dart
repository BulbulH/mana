import 'dart:convert';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/request/customerBillingModel.dart';
import 'package:flutterecom/models/request/customerCreateModel.dart';
import 'package:flutterecom/models/request/customerShippingModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/extentionHelper.dart';
import 'package:flutterecom/woohttprequest.dart';



addWhishlistPref(int productId) {
  String productToAdd=productId.toString();
  List<String> wishListProducts=prefs.getStringList(WISHLIST) ?? [];
  wishListProducts.add(productToAdd);
  prefs.setStringList(WISHLIST,wishListProducts);
}
bool removeFromWishList(int productId) {
  String productToRemove=productId.toString();
  List<String> wishListProducts=prefs.getStringList(WISHLIST) ?? [];
  wishListProducts.remove(productToRemove);
  prefs.setStringList(WISHLIST,wishListProducts);
  return true;
}

List<int> getWhishlistPref() {
  List<String> wishListProducts=prefs.getStringList(WISHLIST) ?? [];
  return wishListProducts.map((e) => int.parse(e)).toList();
}


setCustomerDetailsPref(CreateCustomer createCustomer) {
  prefs.setString(CUSTOMERDETAILS,json.encode(createCustomer.toJson()) );
}

CreateCustomer getCustomerDetailsPref() {
  String createCustomerPref=prefs.getString(CUSTOMERDETAILS) ?? json.encode( CreateCustomer(
      "",
      "",
      "",
      "",
      Billing("", "", "", "", "", "", "", "", "", "", ""),
      Shipping("", "", "", "", "", "", "", "", "")
  ).toJson());

  var responseJson = json.decode(createCustomerPref);
  CreateCustomer createCustomer=CreateCustomer.fromJson(responseJson);

  return createCustomer;
}

List<Line_items> getCartProductsPref(){
    String currCartProductsPref=prefs.getString(CARTPRODUCTS) ?? "[]";
    List responseJson = json.decode(currCartProductsPref);
    List cartList=List<Line_items>.from(responseJson.map((data) => Line_items.fromJson(data)).toList());
    return cartList;
}

Future<bool> addORupdateCartProductsPref(Line_items cartProduct) async {
  String currCartProductsPref=prefs.getString(CARTPRODUCTS) ?? "[]";

  List responseJson = json.decode(currCartProductsPref);
  List<Line_items> cartList=List<Line_items>.from(responseJson.map((data) => Line_items.fromJson(data)).toList());
  bool found=false;
  for(int pos=0;pos<cartList.length;pos++)
    if(cartList[pos].product_id==cartProduct.product_id) {
      cartList.update(pos, cartProduct);
      found=true;
      break;
    }
  if(!found)
    cartList.add(cartProduct);

  var data=cartList.map((data) => json.encode(data.toJson())).toList().toString();
  await prefs.setString(CARTPRODUCTS, data);
  return true;
}

Future<bool> delCartProductsPref(int product_id) async {
  String currCartProductsPref=prefs.getString(CARTPRODUCTS) ?? "[]";

  List responseJson = json.decode(currCartProductsPref);
  List<Line_items> cartList=List<Line_items>.from(responseJson.map((data) => Line_items.fromJson(data)).toList());
  List<Line_items> toRemovecartList  = List();

  cartList.forEach( (value) {
    if(value.product_id==product_id)
      toRemovecartList.add(value);
  });
  cartList.removeWhere( (value) => toRemovecartList.contains(value));

  var data=cartList.map((data) => json.encode(data.toJson())).toList().toString();
  await prefs.setString(CARTPRODUCTS, data);
  return true;
}

Future<bool> delAllCartProductsPref( ) async {
  await prefs.setString(CARTPRODUCTS, "[]");
  return true;
}


String getLanguageCode() {
  String languageCode=prefs.getString(LANGUAGE) ?? "en";
  return languageCode;
}

Future<bool> setLanguageCode(String languageCode) async{
  await prefs.setString(LANGUAGE,languageCode );
  return true;
}


bool isDarkTheme() {
  bool darkTheme=prefs.getBool(DARKTHEME) ??false;
  return darkTheme;
}

Future<bool> setDarkTheme(bool darkTheme) async{
  await prefs.setBool(DARKTHEME,darkTheme );
  return true;
}
