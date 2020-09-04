import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/request/cupdateCustomerUpdateModel.dart';
import 'package:flutterecom/models/responce/getAllCouponResponceModel.dart';
import 'package:flutterecom/models/responce/getAllPaymentMethodResponceModel.dart';
import 'package:flutterecom/models/responce/getShippingZoneMethodsResponce.dart';
import 'package:flutterecom/paymentBraintree.dart';

import 'package:flutterecom/models/request/customerCreateModel.dart';
import 'package:flutterecom/models/request/customerGetModel.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/payments/config.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:flutterecom/models/responce/createCustomerResponceModel.dart';
class WooHttpRequest {

//-----------------------------------HEROKU SERVER-----------------------------------------------------//

  Future<String> getToken() async {

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final response = await http.get(HEROKUTOKEN_SERVER+"braintreetoken.php",headers: headers);
    if (response.statusCode == 200) {
      return response.body;
    } else {
      return null;
    }
  }

  Future<bool> payNow(String nonce,double amount) async {

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
    };
    final response = await http.get(HEROKUTOKEN_SERVER+"braintreepay.php?payment_method_nonce=${nonce}&amount=${amount}",headers: headers);
    if (response.statusCode == 200) {
      return response.body.toLowerCase() == 'true';
    } else {
      return false;
    }
  }

//-----------------------------------WOOCOMMERCE SERVER-----------------------------------------------------//

  //CUSTOMER
  Future<int> getUserWithId(CreateCustomer createCustomer) async {
    int userId=0;
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    final response = await http.get(WP_JSON_WC+"customers",headers: headers );
    if (response.statusCode == 200) {
      print(response.body);

      List responseJson = json.decode(response.body);
      List<GetCustomer> customers= responseJson.map((data) => GetCustomer.fromJson(data)).toList();
      for(int index=0;index<customers.length;index++){
        if(customers[index].email==createCustomer.email)
        {
          userId=customers[index].id;
          break;
        }
      }
      return userId;
    } else {
      return userId;
    }
  }

  Future<CreateCustomerResponce> addCustomer(CreateCustomer createCustomer) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    var body = json.encode(createCustomer.toJson());
    final response = await http.post(WP_JSON_WC+"customers",headers: headers ,body: body);

    if (response.statusCode == 200||response.statusCode == 201) {
      var responseJson = json.decode(response.body);
      CreateCustomerResponce createCustomerResponce=CreateCustomerResponce.fromJson(responseJson);
      return createCustomerResponce;
    }else if (response.statusCode == 400 && json.decode(response.body)["code"]=="registration-error-email-exists") {
      return null;
    } else {
      return null;
    }
  }

  Future<CreateCustomerResponce> updateNewUser(int id,UpdateCustomer updateCustomer) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    var body = json.encode(updateCustomer.toJson());
    final response = await http.put(WP_JSON_WC+"customers/${id}",headers: headers ,body: body);
    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body);
      CreateCustomerResponce createCustomerResponce=CreateCustomerResponce.fromJson(responseJson);
      return createCustomerResponce;
    } else {
      return null;
    }
  }


  //PRODUCTS
  Future<List> getProducts() async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
      };

    final response = await http.get(WC_API+"products?filter[limit] =-1",headers: headers);


    if (response.statusCode == 200) {
      var responseJson = json.decode(response.body)["products"];
      return List<GetAllProducts>.from(responseJson.map((data) => GetAllProducts.fromJson(data)));
    } else {
      return List();

    }
  }

  //PRODUCTS CATEGORY
  Future<List> getProductCategories() async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    final response = await http.get(WP_JSON_WC+"products/categories",headers: headers);

    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);

      List catDataList=responseJson.map((data) {
        return GetAllProductCategories.fromJson(data);
      }).toList();
      return catDataList;
    } else {
      return List();
    }
  }

  //ORDERS
  Future<List> getOrders() async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    final response = await http.get(WP_JSON_WC+"orders",headers: headers);

    if (response.statusCode == 200) {
      List responseJson = json.decode(response.body);
      List<GetOrderResponce> listResponce=responseJson.map((data) => GetOrderResponce.fromJson(data)).toList();
      List<GetOrderResponce> _tempListResponce=List();
      listResponce.forEach((data){
        if(data.billing.email==getCustomerDetailsPref().email)
          {
            _tempListResponce.add(data);
          }
      });
      return _tempListResponce;
    } else {
      return List();

    }
  }

  Future putNewOrder(String payment_method,String payment_method_title) async {
    List<Line_items> lineItems=getCartProductsPref();
    CreateCustomer createCustomer=getCustomerDetailsPref();
    CreateOrder createOrder=new CreateOrder(
        payment_method,
        payment_method_title,
        true,
        createCustomer.billing,
        createCustomer.shipping,
        lineItems
    );
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };

    var body = json.encode(createOrder.toJson());
    final response = await http.post(WP_JSON_WC+"orders",headers: headers ,body: body);

    if (response.statusCode == 200||response.statusCode == 201) {
      var responseJson = json.decode(response.body);
      if(responseJson["order_key"]!="") {
        delAllCartProductsPref();
        return true;
      }return false;
    } else {
      return false;
    }
  }


  //SHIPPING ZONE
  Future<List<int>> getShippingZones( ) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    final response = await http.get(WP_JSON_WC+"shipping/zones",headers: headers );
    if (response.statusCode == 200) {
      print(response.body);

      List responseJson = json.decode(response.body);
      List<int> shippingZoneId= List<int>.from(responseJson.map((data) => data["id"]).toList());
      return shippingZoneId;
    } else {
      return List<int>();
    }
  }
  //SHIPPING ZONE METHOD
  Future<List<GetShippingZoneMethods>> getShippingZonesMethod(int id) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    final response = await http.get(WP_JSON_WC+"shipping/zones/$id/methods",headers: headers );
    if (response.statusCode == 200) {
      print(response.body);

      List responseJson = json.decode(response.body);
      List<GetShippingZoneMethods> shippingZoneId= List<GetShippingZoneMethods>.from(responseJson.map((data) => GetShippingZoneMethods.fromJson(data)).toList());
      return shippingZoneId;
    } else {
      return List<GetShippingZoneMethods>();
    }
  }

  //SETTING
  Future<String> getSettings( ) async {
    String code="GBP";
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    final response = await http.get(WP_JSON_WC+"settings/general",headers: headers );
    if (response.statusCode == 200) {
      print(response.body);

      List responseJson = json.decode(response.body);
      responseJson.forEach((element) {
        if(element["id"]=="woocommerce_currency")
          code= element["value"];
      });
      return code;
    } else {
      return code;
    }
  }
  //COUPON
  Future<List<GetAllCoupon>> getCoupon( ) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    final response = await http.get(WP_JSON_WC+"coupons",headers: headers );
    if (response.statusCode == 200) {
      print(response.body);


      List responseJson = json.decode(response.body);
      List<GetAllCoupon> getCoupon= List<GetAllCoupon>.from(responseJson.map((data) => GetAllCoupon.fromJson(data)).toList());
      return getCoupon;
    } else {
      return List<GetAllCoupon>();
    }
  }

  //PAYMENTGATEWAY
  Future<List<PaymentGatewayResponce>> getPaymentGatways( ) async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$WOOCOMM_AUTH_USER:$WOOCOMM_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json",
      "Authorization": basicAuth
    };
    final response = await http.get(WP_JSON_WC+"payment_gateways",headers: headers );
    if (response.statusCode == 200) {
      print(response.body);

      List responseJson = json.decode(response.body);
      List<PaymentGatewayResponce> paymentGateway= List<PaymentGatewayResponce>.from(responseJson.map((data) => PaymentGatewayResponce.fromJson(data)).toList());
      return paymentGateway;
    } else {
      return null;
    }
  }


//-----------------------------------PAYMENTS-----------------------------------------------------//

  //paypal
  Future<String> getAuthPaypal() async {
    String basicAuth = 'Basic ' + base64Encode(utf8.encode('$PAYPAL_AUTH_USER:$PAYPAL_AUTH_PASS'));
    print(basicAuth);

    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization": basicAuth
    };

    Map bodyMap={"grant_type":"client_credentials"};
    final response = await http.post(PAYPAL_SERVER+"oauth2/token",headers: headers ,body:  (bodyMap));
    if (response.statusCode == 200) {
      print(response.body);

      var responseJson = json.decode(response.body);

      return responseJson['access_token'];
    } else {
      return null;
    }
  }

  Future<Map> paymentPaypal(String token,double amount,double shippingAmount,String currencyCode) async {

    String bearerAuth = 'Bearer $token';
    print(bearerAuth);

    Map<String, String> headers = {
      'Content-type' : 'application/json',
      "Accept": "application/json",
      "Authorization": bearerAuth
    };

    Map<dynamic,dynamic> bodyMap=getConfigPaypal(amount, shippingAmount, currencyCode);
    final response = await http.post(PAYPAL_SERVER+"payments/payment",headers: headers ,body:  json.encode(bodyMap).toString());
    if (response.statusCode == 200||response.statusCode == 201) {
      print(response.body);

      var responseJson = json.decode(response.body);
      String approval_url= null;
      String execute= null;
      if(responseJson!=null&&responseJson["links"]!=null) {
        List links=responseJson["links"];
        links.forEach((data) {
          if (data["rel"] == "approval_url")
            approval_url = data["href"];
          else if (data["rel"] == "execute")
            execute = data["href"];
        });
      }
      return {"approval_url":approval_url, "execute":execute};
    } else {
      return null;
    }
  }

  Future<bool> paymentPaypalExecute(String token,String payerid,String executeUrl) async {

    String bearerAuth = 'Bearer $token';
    print(bearerAuth);

    Map<String, String> headers = {
      'Content-type' : 'application/json',
      "Accept": "application/json",
      "Authorization": bearerAuth
    };

    Map bodyMap={"payer_id":"$payerid"};

    final response = await http.post(executeUrl,headers: headers ,body:  json.encode(bodyMap).toString());
    if (response.statusCode == 200||response.statusCode == 201) {
      print(response.body);

      var responseJson = json.decode(response.body);
      return true;
    } else {
      return false;
    }
  }


  //tap
  Future<String> getTapUrl(double amount,double shippingAmount,String currencyCode) async {

    Map<String, String> headers = {
      "Accept": "application/json",
      'Content-type' : 'application/json',
      "Authorization": "Bearer $TAP_KEY"
    };

    Map<dynamic,dynamic> bodyMap=getConfigTap(amount, shippingAmount, currencyCode);
    final response = await http.post(TAP_SERVER+"charges",headers: headers ,body: json.encode(bodyMap).toString());
    if (response.statusCode == 200) {
      print(response.body);

      var responseJson = json.decode(response.body);
      if(responseJson!=null&&responseJson['transaction']!=null&&responseJson['transaction']!="")
        return responseJson["transaction"]["url"];
      else
        return null;
    } else {
      return null;
    }
  }

}