import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/homeCategoryHeader.dart';
import 'package:flutterecom/WidgetHelper/orderButton.dart';
import 'package:flutterecom/bloc/bloc_order.dart';
import 'package:flutterecom/emuns/ratingType.dart';
import 'package:flutterecom/emuns/orderType.dart';
import 'package:flutterecom/models/responce/getAllOrderResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/commonMethod.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:progress_indicators/progress_indicators.dart';

class OrdersScreen extends StatefulWidget {
  OrdersScreen({Key key}) : super(key: key);


  @override
  _ListPageState createState() => _ListPageState();
}

class _ListPageState extends State<OrdersScreen> with OrderButton {

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
                  flex: 13,
                  child: ListView(
                      children: [

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
                                        padding: EdgeInsets.all(5),
                                        child: Icon(Icons.arrow_back,
                                          color: themeAppBarItems,
                                          size: 25,),
                                      )
                                  ),
                                  Text(
                                    LocalLanguageString().orderhistory,
                                    style: TextStyle(color: themeAppBarItems,
                                      fontSize: 20.0,
                                      fontFamily: "Header",
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Container()

                                ],
                              ),
                            )
                        ),
                        getSearchBarUI(),
                        Container(
                          height: 50,
                          child:  StreamBuilder(
                            stream: orderBloc.selectOrderTypeStreamController.stream,
                            initialData: OrderStatus.any,
                            builder: (BuildContext context, AsyncSnapshot snapshot) {
                              return snapshot.data!=null? getOrderTypes(snapshot.data):Container();
                            },
                          ),
                        ),
                        Divider(
                          thickness: 1,
                        ),
                        StreamBuilder(
                          stream: orderBloc.getOrderStreamController.stream,
                          initialData: orders,
                          builder: (BuildContext context, AsyncSnapshot snapshot) {
                            return snapshot.data!=null? Column(
                                children: List<GetOrderResponce>.from(snapshot.data).map((data) => _item(data)).toList()
                            ):Container();
                          },
                        )
                      ]
                  )
              )
            ],
          ),
        )
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
                          List<GetOrderResponce> _orders=new List();

                          orders.forEach((data){
                            if (data.order_key.toLowerCase().contains(value.toLowerCase())||data.billing.first_name.toLowerCase().contains(value.toLowerCase())){
                              _orders.add(data);
                            }
                          });
                          orderBloc.refreshOrders(_orders);

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
            child: Container(),
          )
        ],
      ),
    );
  }

  Widget _item(GetOrderResponce orderResponce) {
    GetAllProducts thisproduct=getProductFromId(orderResponce.line_items[0].product_id);
    return Column(
      children: [
        Row(
          children: [
            (orderResponce.line_items!=null&&orderResponce.line_items.length>0)?
            Container(
              padding: EdgeInsets.all(12),
              child:( thisproduct!=null&&thisproduct.images.length>0)?
              CachedNetworkImage(
                  imageUrl: thisproduct.images[0].src,
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
            ) :Container( width: 80.0, height: 80.0),
            ):
            Container(),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "${thisproduct==null?"Product Not Found":thisproduct.title}".toUpperCase(),
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: themeTextColor,
                      fontSize: 16,
                      fontFamily: "Normal",
                      fontWeight: FontWeight.w900
                  ),
                ),Text(
                  LocalLanguageString().charges+": ${orderResponce.total} $currencyCode",
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      color: themeTextColor,
                      fontSize: 15,
                      fontFamily: "Normal",
                      fontWeight: FontWeight.w600
                  ),
                ),

              ],
            ),

          ],
        ),

      ],
    );
  }

}
