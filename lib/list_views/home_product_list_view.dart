import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/models/request/createOrderModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/homefragments/productsWidget.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:progress_indicators/progress_indicators.dart';

class HomeProductListView extends StatefulWidget {
  final List<GetAllProducts> products;
  final Function callBack;

  const HomeProductListView({Key key, this.products, this.callBack})
      : super(key: key);
  @override
  _PopularProductGridViewState createState() => _PopularProductGridViewState();
}

class _PopularProductGridViewState extends State<HomeProductListView>
    with TickerProviderStateMixin {
  AnimationController animationController;
  List wishList;
  @override
  void initState() {
    animationController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);
    super.initState();
  }

  Future<bool> getData() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 200));
    return true;
  }

  @override
  Widget build(BuildContext context) {
    wishList = getWhishlistPref();
    return GridView(
      shrinkWrap: true,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 0.0,
        crossAxisSpacing: 4.0,
        childAspectRatio: 4.0, //w/h
      ),
      padding: const EdgeInsets.all(7),
      physics: const BouncingScrollPhysics(),
      scrollDirection: Axis.vertical,
      children: List<Widget>.generate(
        widget.products.length,
        (int index) {
          return GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, '/homeproductdetail',
                  arguments: {'_productId': widget.products[index].id});
            },
            child: Container(
                height: 100,
                child: itemView(
                  widget.products[index],
                )),
          );
        },
      ),
    );
  }

  Widget itemView(GetAllProducts data) {
    bool isWishListed = false;
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

    wishList.forEach((element) {
      if (element == data.id) isWishListed = true;
    });


    return Card(
      color: themeBG,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 10,
            child: Row(
              children: [
                Container(
                    height: 80,
                    width: 80,
                    child: data.images.length > 0
                        ? ClipRRect(
                            borderRadius: BorderRadius.all(Radius.circular(4)),
                            child: CachedNetworkImage(
                              imageUrl: data.images[0].src,
                              imageBuilder: (context, imageProvider) =>
                                  Container(
                                decoration: BoxDecoration(
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
                            ))
                        : Container(
                            height: 80,
                            width: 80,
                          )),
                SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(top: 2.0),
                    height: 80,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title == null ? "" : data.title,
                          overflow: TextOverflow.fade,
                          softWrap: false,
                          maxLines: 1,
                          textAlign: TextAlign.left,
                          style: TextStyle(
                            fontFamily: "Normal",
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            letterSpacing: 0.27,
                            color: themeTextColor,
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.only(bottom: 8.0),
                          child: Row(
                            children: [
                              data.on_sale
                                  ? data.regular_price != null
                                      ? Text(
                                          " ${data.regular_price} ${currencyCode == null ? "" : currencyCode}",
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: "Normal",
                                            fontWeight: FontWeight.w600,
                                            decoration:
                                                TextDecoration.lineThrough,
                                            fontSize: 12,
                                            color:
                                                themeTextColor.withOpacity(0.5),
                                          ),
                                        )
                                      : Container()
                                  : Container(),
                              data.on_sale
                                  ? data.regular_price != null
                                      ? SizedBox(
                                          width: 12,
                                        )
                                      : Container()
                                  : Container(),
                              Text(
                                data.price +
                                    " ${currencyCode == null ? "" : currencyCode}",
                                // LocalLanguageString().cost+" ${data.price} ${currencyCode==null?"":currencyCode}",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontFamily: "Normal",
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: data.on_sale
                                      ? Colors.red
                                      : themeTextColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 4,
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
          ),
        ],
      ),
    );
  }
}
