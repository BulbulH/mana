import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/list_views/home_product_grid_view.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/prefrences.dart';


class CategoryProductsScreen extends StatefulWidget {

  @override
  _CategoryProductState createState() => new _CategoryProductState();
}

class _CategoryProductState extends State<CategoryProductsScreen> with TickerProviderStateMixin{

  List<GetAllProducts> thisProductList=List();
  String categoryName;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    Map map= ModalRoute.of(context).settings.arguments as Map;
    int categoryId=map['_categoryId'];
    categoryName=map['_categoryName'];
    products.forEach((_Product){
      _Product.categories.forEach((cat){
        if(cat==categoryName)
          thisProductList.add(_Product);
      });
    });

    return Scaffold(
        key: _scaffoldKey,
        backgroundColor: themeBG,
        body: body()
    );
  }

  Widget body() {
    List cartList=getCartProductsPref();

    return Container(
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
                      categoryName,
                      style: TextStyle(color: themeAppBarItems,
                          fontSize: 20.0,
                          fontFamily: "Header"),
                    ),
                    cartList.length > 0 ? Container(
                        padding: EdgeInsets.all(15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/cart', arguments: {'_showAppBar': true});
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
                                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
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
            flex: 13,
            child: Center(
              child: StreamBuilder(
                stream: homeBloc.getProductCategoryStreamController.stream,
                initialData: thisProductList,
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
              )
            )
          ),
        ],
      ),
    );
  }

}