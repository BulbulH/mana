import 'dart:collection';
import 'dart:convert';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/productImageSlider.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:flutter_html/flutter_html.dart';

class HomeProdcutDetailScreen extends StatefulWidget {
  @override
  _ProductItemDetailState createState() => _ProductItemDetailState();
}

class _ProductItemDetailState extends State<HomeProdcutDetailScreen> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, String> optionSelected = Map();
  Variations variation;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Map map = ModalRoute
        .of(context)
        .settings
        .arguments as Map;
    int productId = map['_productId'];
    GetAllProducts thisProduct;
    products.forEach((_Product) {
      if (_Product.id == productId)
        thisProduct = _Product;
    });


    variation = null;
    thisProduct.variations.forEach((variant) {
      if (variant.visible) {
        bool attrOptionMatches = true;
        variant.attributes.forEach((attr) {
          if (optionSelected.containsKey(attr.name) &&
              (optionSelected[attr.name].toLowerCase() == attr.option.toLowerCase())||(attr.option.toLowerCase() == "")) {
            print(variant.price+"");
          }
          else {
            attrOptionMatches = false;
          }
        });
        if (attrOptionMatches) {
          variation = variant;
        }
      }
    });

    return Scaffold(
        backgroundColor: themeBG,
        key: _scaffoldKey,
        body: SafeArea(
          child: screen(thisProduct),
        )
    );
  }


  Widget screen(GetAllProducts thisProduct) {
    List cartList = getCartProductsPref();

    return Container(
      child: Flex(
        direction: Axis.vertical,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
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
                          child: Icon(Icons.arrow_back,
                            color: themeAppBarItems,
                            size: 25,),
                        )
                    ),
                    Text(
                      LocalLanguageString().detailedproduct,
                      style: TextStyle(
                          color: themeAppBarItems,
                          fontSize: 20.0,
                          fontFamily: "Header"),
                    ),
                    cartList.length > 0 ? Container(
                        padding: EdgeInsets.all(15),
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/cart',
                                  arguments: {'_showAppBar': true});
                            },
                            child: Container(
                              height: 30,
                              width: 30,
                              child: Stack(
                                children: [
                                  Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Icon(Icons.shopping_cart,
                                      color: themeAppBarItems,
                                      size: 25,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.topRight,
                                    child: Container(
                                      height: 16,
                                      width: 16,
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.all(
                                              Radius.circular(10.0)),
                                          color: Colors.orange),
                                      child: Text(
                                        cartList.length.toString(),
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: "Normal",
                                          fontWeight: FontWeight.w600,
                                          fontSize: 11,
                                          color: themeBG,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                            )
                        )
                    ) : Container(),

                  ],
                ),
              )
          ),
          Expanded(
            flex: 10,
            child: body(thisProduct),
          )

        ],
      ),
    );
  }


  Widget body(GetAllProducts thisProduct) {
    bool isCartItem=getCartProductsPref().firstWhere((element) => element.product_id==thisProduct.id,orElse: () => null)!=null;

    return Container(
      child: ListView(
        shrinkWrap: true,
        children: [
          Center(
              child: getImageProductSlider(
                  context,
                  variation == null ? thisProduct.images : (variation.images ==
                      null ? "" : variation.images)
              )
          ),
          Container(
            child: getAttributes(thisProduct),
          ),
          Container(
            padding: EdgeInsets.all(10),
            child: Html(
                data: thisProduct.short_description
            ),
          ),
          Container(
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                LocalLanguageString().description,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: themeTextHighLightColor,
                ),
              ),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),

                    child: Html(
                        data: thisProduct.description
                    )
                ),
              ],
            ),
          ),
          Container(
            child: ExpansionTile(
              initiallyExpanded: true,
              title: Text(
                LocalLanguageString().details,
                style: TextStyle(
                  fontFamily: "Normal",
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: themeTextHighLightColor,
                ),
              ),
              children: <Widget>[
                Padding(
                    padding: EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: EdgeInsets.all(3),
                          child: getReviews(thisProduct),
                        ),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            LocalLanguageString().totalsales + " :" +
                                "  ${thisProduct.total_sales}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontFamily: "Normal",
                              fontWeight: FontWeight.w600,
                              fontSize: 12,
                              color: themeTextColor,
                            ),
                          ),
                        ),
                        Container(
                            padding: EdgeInsets.all(3),
                            child: Row(
                              children: [
                                Text(
                                  LocalLanguageString().cost + " :" +
                                      " ${variation == null
                                          ? thisProduct.price
                                          : variation.price} ${currencyCode==null?"":currencyCode}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Normal",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: themeTextColor,
                                  ),
                                ),

                                thisProduct.on_sale ?Text(
                                  " ${variation == null ? thisProduct
                                      .regular_price : variation
                                      .regular_price} ${currencyCode==null?"":currencyCode}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Normal",
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 10,
                                    color: themeTextColor.withOpacity(0.5),
                                  ),
                                )
                                    : Container()
                              ],
                            )
                        )
                      ],
                    )
                ),
              ],
            ),
          ),

          Divider(),
          GestureDetector(
            onTap: () {
              if (variation != null &&
                  (!variation.in_stock || !variation.purchaseable))
                _scaffoldKey.currentState.showSnackBar(
                    new SnackBar(content: new Text(LocalLanguageString().notavailable,)));
              else
                {
                  if(isCartItem)
                    delCartProductsPref(thisProduct.id);
                  else
                    addORupdateCartProductsPref(Line_items(thisProduct.id, variation == null ? -1 : variation.id, 1));
                }

              setState(() {});
            },
            child: Center(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      isCartItem ?LocalLanguageString().removefromcart:LocalLanguageString().addtocart,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontFamily: "Normal",
                          color:isCartItem?themeTextColor:themeTextHighLightColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w700
                      ),
                    ),
                    Image.asset(
                      isCartItem?"assets/removecart.png":"assets/addcart.png",width: 25,height: 25,color:isCartItem?themeTextColor:themeTextHighLightColor,
                    ),
                  ],
                )
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget getAttributes(GetAllProducts thisProduct) {
    List<ProductAttributes> attributes = thisProduct.attributes;


    return (attributes != null && attributes.length > 0) ? Container(
        padding: EdgeInsets.all(10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: []
              ..addAll(attributes.map((attr) {
                return attr.visible ?
                Container(
                  child: Wrap(
                      direction: Axis.vertical,
                      children: []..add(
                        Text(
                          attr.name,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: themeTextHighLightColor,
                          ),
                        ),
                      )..add(
                          Container(
                            height: 50,
                            width: MediaQuery
                                .of(context)
                                .size
                                .width,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: attr.options.map((options) {

                                var foundOptionInVariant = false;
                                if (optionSelected.length > 0 && !optionSelected.containsKey(attr.name)) {
                                  thisProduct.variations.forEach((variant) {

                                    var attributeFound = true;
                                    variant.attributes.forEach((varAttr) {

                                      var viewMatchVarAttr=(attr.name.toLowerCase()==varAttr.name.toLowerCase()&& (options.toLowerCase()==varAttr.option.toLowerCase()||varAttr.option==""));
                                      var selectedMatchVarAttr=(optionSelected.containsKey(varAttr.name)&& (varAttr.option.toLowerCase()== optionSelected[varAttr.name].toLowerCase()||varAttr.option==""));
                                      var nonSelectedVarAttr=!optionSelected.containsKey(varAttr.name)&& attr.name.toLowerCase()!= varAttr.name.toLowerCase();
                                      print("");
                                      if(!viewMatchVarAttr&&!selectedMatchVarAttr&& !nonSelectedVarAttr){
                                          attributeFound=false;
                                      }
                                      else
                                        print("");

                                    });
                                    if(attributeFound)
                                      foundOptionInVariant=true;
                                    else
                                      print("");

                                  });

                                }
                                else  if ( optionSelected.containsKey(attr.name)) {
                                  var selectedMatchView=(optionSelected.containsKey(attr.name)&& (options.toLowerCase()== optionSelected[attr.name].toLowerCase() ));
                                  print("");
                                  if(selectedMatchView){
                                    foundOptionInVariant=true;
                                  }
                                }
                                else
                                  foundOptionInVariant = true;

                                print("");
                                return foundOptionInVariant ? GestureDetector(
                                  onTap: () {
                                    optionSelected[attr.name] = options;
                                    setState(() {});
                                  },
                                  child: Container(
                                    constraints: BoxConstraints(minWidth: 60),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.all(10),
                                    padding: EdgeInsets.all(5),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(10)),
                                        border: Border.all(
                                            color: themeTextColor.withAlpha(30)
                                            , width: 1),
                                        color: (optionSelected.containsKey(
                                            attr.name) &&
                                            optionSelected[attr.name] == options)
                                            ?  themeTextColor.withAlpha(20)
                                            : transparent
                                    ),
                                    child: Text(
                                      options,
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontFamily: "Normal",
                                        fontWeight: FontWeight.w600,
                                        fontSize: 12,
                                        color: (optionSelected.containsKey(
                                            attr.name) &&
                                            optionSelected[attr.name] ==
                                                options)
                                            ? themeTextHighLightColor
                                            : themeTextColor,
                                      ),
                                    ),
                                  ),
                                ) : Container();
                              }).toList(),
                            ),
                          )
                      )
                  ),
                ) : Container();
              }).toList()
              )
              ..add(
                  GestureDetector(
                    onTap: () {
                      optionSelected = Map();
                      setState(() {});
                    },
                    child: Container(
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.all(5),
                      child: Text(
                        LocalLanguageString().clear,
                        textAlign: TextAlign.end,
                        style: TextStyle(
                          fontFamily: "Header",
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: themeTextHighLightColor,
                        ),
                      ),
                    ),
                  )
              )
        )
    ) : Container();
  }
}
