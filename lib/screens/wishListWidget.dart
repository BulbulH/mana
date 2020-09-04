import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/homeCategoryHeader.dart';
import 'package:flutterecom/WidgetHelper/orderButton.dart';
import 'package:flutterecom/bloc/bloc_order.dart';
import 'package:flutterecom/emuns/ratingType.dart';
import 'package:flutterecom/emuns/orderType.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/commonMethod.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:progress_indicators/progress_indicators.dart';

class WishListScreen extends StatefulWidget {
  WishListScreen({Key key}) : super(key: key);


  @override
  _WishListScreenState createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen>   {

  double boxSize=70;
  @override
  Widget build(BuildContext context) {

    return Scaffold(
        backgroundColor: themeBG,
        body: Container(
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
                          LocalLanguageString().wishlist,
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
                child: ListView(
                    children: getWhishlistPref().length==0? [Container(
                      height: 200,
                      child: Center(
                        child: Text(
                          " No items marked yet ",
                          style: TextStyle(
                            fontFamily: "Normal",
                            fontWeight: FontWeight.w600,
                            fontSize: 19,
                            color: themeTextColor,
                          ),),
                      ),
                    )]:getWhishlistPref().map((id) {
                      return favItems(id);
                    }).toList()
                )
              )

            ],
          ),
        )
    );

  }

  Widget favItems(int productId) {
    GetAllProducts getallproduct = getProductFromId(productId);

    if(getallproduct==null)
      return Container();
    return Container(
      height: 110,
      padding: const EdgeInsets.all(10),
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
        children: <Widget>[
          Container(
              child:getallproduct.images.length>0?
              CachedNetworkImage(
                imageUrl: getallproduct.images[0].src,
                imageBuilder: (context, imageProvider) =>
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(10.0) //                 <--- border radius here
                        ),
                        image: DecorationImage(
                          image: imageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                placeholder: (context, url) =>
                    Center(child: JumpingDotsProgressIndicator(
                      fontSize: 20.0,)),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.filter_b_and_w),),
              ) :Container(height: 80,width: 80,)
          ),
          Flexible(
            child: Container(
              margin: EdgeInsets.only(left: 14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Flexible(
                        child: Text(
                          "${getallproduct != null ? getallproduct.title : ""}".toUpperCase(),
                          overflow: TextOverflow.fade,
                          softWrap: true,
                          style: TextStyle(
                              color: themeTextColor,
                              fontSize: 15,
                              fontFamily: "Normal",
                              fontWeight: FontWeight.w700
                          ),
                        ),
                      ),
                      Container(
                        width: 40,
                        child: IconButton(
                          onPressed: () {
                            removeFromWishList(productId);
                            setState(() {});
                          },
                          color: themePrimary,
                          icon: Icon(Icons.delete),
                          iconSize: 20,
                        ),
                      )

                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text(LocalLanguageString().price + " :",
                        style: TextStyle(
                            color: themeTextColor,
                            fontSize: 14,
                            fontFamily: "Normal",
                            fontWeight: FontWeight.w700
                        ),
                      ),

                      Text(
                        "${getallproduct != null ? getallproduct.price+" $currencyCode" : ""}",
                        style: TextStyle(
                          fontFamily: "Normal",
                          color: themeTextColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 14,
                        ),
                      ),

                    ],
                  ),
                  Text(
                    "${getallproduct != null ? getallproduct.tags : ""}",
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontFamily: "Normal",
                      color: themeTextColor,
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                    ),
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
