import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/bloc/bloc_productdetail.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:progress_indicators/progress_indicators.dart';


Widget getImageProductSlider(BuildContext context,List<Images> images ) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: [
      images!=null&&images.length>0?
      StreamBuilder(
        stream: productDetailBloc.selectCarouselStreamController.stream,
        initialData: 0,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return Container(
            child: Container(
              height: MediaQuery.of(context).size.height*0.25,
              margin: EdgeInsets.all(5.0),
              child: ClipRRect(
                  borderRadius: BorderRadius.all(Radius.circular(5.0)),
                  child: Stack(
                    children: <Widget>[
                      CachedNetworkImage(
                        imageUrl: snapshot.data>=images.length?images[0].src:images[snapshot.data].src,
                        imageBuilder: (context, imageProvider) => Container(
                          width: MediaQuery.of(context).size.width,
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

                    ],
                  )
              ),
            ),
          );
        },
      ):Container(
        height: MediaQuery.of(context).size.height*0.25,
      ),
      images!=null&&images.length>0?
      Container(
        height: 80,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: images.map((item) => GestureDetector(
            onTap: (){
              productDetailBloc.selectCarouselIndex(images.indexOf(item));
            },
            child: Container(
              padding: EdgeInsets.all(2),
              child: CachedNetworkImage(
                imageUrl: item.src,
                imageBuilder: (context, imageProvider) => Container(
                  width: 100.0, height: 100.0,
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
            )
          )).toList(),
        ),
      ):
        Container(
          height: 80,
        )
    ],
  );

}