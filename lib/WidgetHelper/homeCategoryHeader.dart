import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:progress_indicators/progress_indicators.dart';

class CategoryButton {

  Widget getCategoryUI(BuildContext context) {

    return Container(
      height: 100,
        padding: const EdgeInsets.only(left: 16, right: 16),
        child: StreamBuilder(
          stream: homeBloc.getProductCategoryStreamController.stream,
          initialData: categories,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            return snapshot.data!=null?
            categories.length>0? ListView(
              children: categories.map((index) => getButtonUI(context,index)).toList(),
              physics: const BouncingScrollPhysics(),
              scrollDirection: Axis.horizontal,
            ):Container()
                :Container();
          },
        )
    );

  }

  Widget getButtonUI(BuildContext context,GetAllProductCategories categoryIndex) {
    return Container(
        margin: const EdgeInsets.only(top: 15, bottom: 15, left: 10, right: 10),
        child: GestureDetector(
          onTap: (){
            List<GetAllProducts> _subProduct=List();
            products.forEach((element) {
              if(element.categories.contains(categoryIndex.name.toString()))
                {
                  _subProduct.add(element);
                }
            });
            Navigator.pushNamed(context, '/subproduct', arguments: {'_subProducts': _subProduct, '_title': categoryIndex.name});
          },
          child: Flex(
            direction: Axis.vertical,
            children: [
              Expanded(
                flex: 4,
                child: categoryIndex.image!=null&&categoryIndex.image.src!=null?
                ClipOval(
                  child: CachedNetworkImage(
                    imageUrl: categoryIndex.image.src,
                    imageBuilder: (context, imageProvider) => Container(
                      width: 50,
                      height: 50,
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

                ):Container( color :Colors.transparent,width: 50, height: 50,),
              ),
              Expanded(
                flex: 1,
                child: Container(
                  child: Text(
                    categoryIndex.name,
                    textAlign: TextAlign.left,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 12,
                      fontFamily: "Normal",
                      color: themeTextColor,
                    ),
                  ),
                )
              ),
            ],
          ),
        )
    );

  }
}