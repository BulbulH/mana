import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/homefragments/productsWidget.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeProductGridView extends StatefulWidget {
  final List<GetAllProducts> products;
  final Function callBack;

  const HomeProductGridView({Key key, this.products, this.callBack}) : super(key: key);
  @override
  _PopularProductGridViewState createState() => _PopularProductGridViewState();
}

class _PopularProductGridViewState extends State<HomeProductGridView> with TickerProviderStateMixin {
  AnimationController animationController;
  List wishList;
  @override
  void initState() {
    animationController = AnimationController(duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    wishList=getWhishlistPref();
    return  GridView(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 3.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.55,//w/h
      ),
      padding: const EdgeInsets.all(8),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: List<Widget>.generate(
        widget.products.length,
            (int index) {
          return Container(
            height: 100,
            width: double.infinity,
            //color: Colors.red,
            child: GestureDetector(
              onTap: (){
                Navigator.pushNamed(context, '/homeproductdetail', arguments: {'_productId': widget.products[index].id});
              },
              child: itemView(widget.products[index],),
            ),
          );
        },
      ),
    );
  }
  Widget itemView(GetAllProducts data) {
    bool isWishListed=false;
    Line_items item;
    bool isCartItem = getCartProductsPref().firstWhere((element) {
      if( element.product_id == data.id){
        item=element;
        return true;
      }else{
        return false;
      }

    }, orElse: () => null) !=
        null;

   // bool isCartItem=getCartProductsPref().firstWhere((element) => element.product_id==data.id,orElse:() => null)!=null;

    wishList.forEach((element) {
      if(element==data.id)
        isWishListed=true;
    });


    return  Card(
      color: themeBG,
      child: Flex(
        direction: Axis.vertical,
        children: <Widget>[

          Expanded(
              flex: 7,
              child: Stack(
                children: [
                  Container(
                      width: double.infinity,
                      child:data.images.length>0?ClipRRect(
                          borderRadius: BorderRadius.all(Radius.circular(4)),
                          child:  CachedNetworkImage(
                            imageUrl: data.images[0].src,
                            imageBuilder: (context, imageProvider) => Container(
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                  image: imageProvider,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            placeholder: (context, url) => Center(child: JumpingDotsProgressIndicator(fontSize: 20.0,)),
                            errorWidget: (context, url, error) => Center(child:Icon(Icons.filter_b_and_w),),
                          )
                      ):Container(height: 80,width: 80,)
                  ),
                  Align(
                      alignment: Alignment.topCenter,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          data.on_sale?Container(
                              alignment: Alignment.topLeft,
                              height: 40,

                              child: Image.asset("assets/sale.png",width: 40,height: 40,)
                          ):Container(width: 40,height: 40,),

                          InkWell(
                            onTap: (){
                              if(isWishListed)
                                removeFromWishList(data.id);
                              else
                                addWhishlistPref(data.id);
                              setState(() {});
                            },
                            child: Image.asset( isWishListed?"assets/fav.png":"assets/unfav.png",width: 30,height: 30,),
                          ),
                        ],
                      )
                  )
                ],
              )
          ),

          Expanded(
              flex: 5,
              child: Flex(
                direction: Axis.vertical,
                children: <Widget>[
                  Expanded(
                    flex: 7,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        SizedBox(height: 5,),
                        Container(
                          child: Text(
                            data.title==null?"":data.title,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.left,
                            style: TextStyle(
                              fontFamily: "Normal",
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              letterSpacing: 0.27,
                              color: themeTextColor,
                            ),
                          ),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: getReviews(data),
                        ),
                        SizedBox(height: 5,),
                        Container(
                          padding: EdgeInsets.all(3),
                          child: Text(
                            LocalLanguageString().totalsales+" :"+"  ${data.total_sales}",
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
                                  LocalLanguageString().cost+" :"+" ${data.price} ${currencyCode==null?"":currencyCode}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Normal",
                                    fontWeight: FontWeight.w600,
                                    fontSize: 12,
                                    color: themeTextColor,
                                  ),
                                ),
                                data.on_sale?
                                data.regular_price!=null?Text(" ${data.regular_price} ${currencyCode==null?"":currencyCode}",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontFamily: "Normal",
                                    fontWeight: FontWeight.w600,
                                    decoration: TextDecoration.lineThrough,
                                    fontSize: 10,
                                    color: themeTextColor.withOpacity(0.5),
                                  ),
                                ):Container()
                                    :Container()
                              ],
                            )
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 3,
                 /*   child: GestureDetector(
                      onTap: (){
                        if(isCartItem)
                          delCartProductsPref(data.id);
                        else
                          addORupdateCartProductsPref(Line_items(data.id, -1, 1));
                        setState(() {});
                      },
                      child: Image.asset(
                        isCartItem?"assets/removecart.png":"assets/addcart.png",width: 25,height: 25,color:isCartItem?themeTextColor:themeTextHighLightColor,
                      ),

                    ),*/
                    child: isCartItem? Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        InkWell(
                          onTap: () {
                            if(item.quantity==1){
                              delCartProductsPref(item.product_id).then((isdeleted){
                                ProductScreenState.setState(() {});
                              });
                            }else{
                              if(item.quantity>1)
                                item.quantity-=1;
                              addORupdateCartProductsPref(item).then((isUpdated){
                                ProductScreenState.setState(() {});
                              });}
                            setState(() {
                            });
                          },
                          child: Container(
                            height: 40,
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

                        Card(
                          color: themeBG,
                          child: Padding(
                            padding: const EdgeInsets.all(7),
                            child: Text(
                              item.quantity.toString(),
                              style: TextStyle(
                                  fontFamily: "Normal",
                                  color: themeTextColor,

                                  fontSize: 14,
                                  fontWeight: FontWeight.w700
                              ),
                            ),
                          ),
                        ),

                        InkWell(
                          onTap: (){
                            if(item.quantity<30)
                              item.quantity+=1;
                            addORupdateCartProductsPref(item).then((isUpdated){
                              ProductScreenState.setState(() {});
                            });
                            setState(() {
                            });
                          },
                          child: Container(
                            height: 40,
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
                    ): Align(
                      alignment: Alignment.centerRight,
                      child: Card(
                        color: themeBG,
                        child: Container(
                          width: 50,
                          height: 50,
                          child: GestureDetector(
                            onTap: () {
                              if (isCartItem)
                                delCartProductsPref(data.id);
                              else
                                addORupdateCartProductsPref(Line_items(data.id, -1, 1));
                              ProductScreenState.setState(() {});
                              setState(() {
                              });
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(50)),
                              alignment: Alignment.center,
                              child: Padding(
                                padding: const EdgeInsets.all(6.0),
                                child: Icon(
                                  Icons.add,
                                  color: themePrimary,
                                  size: 27,
                                ),
                              ),
                            ),

                          ),
                        ),
                      ),
                    ),
                  )
                ],
              )
          )
        ],
      ),
    );
  }
}
