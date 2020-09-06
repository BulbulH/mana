import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:progress_indicators/progress_indicators.dart';


class CategoryScreen extends StatefulWidget {

  @override
  _CategoryScreenState createState() => new _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen>  {



  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {

    List<Widget> catagory= List();

    categories.forEach((element) {
        if(element.image!=null)
          catagory.add( ItemView(data: element));
    });

    return Scaffold(
      backgroundColor: themeBG,
      body: Container(
        padding: EdgeInsets.all(10),
          child: GridView(
             // shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 3.0,
                crossAxisSpacing: 4.0,
               // childAspectRatio: .65, //w/h
              ),
            children: catagory
//            Container(height: 90,width: 90,color: Colors.lightBlueAccent,)
          )
      ),
    );

  }

}

class ItemView extends StatelessWidget {
  const ItemView({Key key, this.data }) : super(key: key);

  final GetAllProductCategories data;

  @override
  Widget build(BuildContext context) {
    //double ITEMHEIGHT=120;
    List<GetAllProducts> _subProduct=List();
    products.forEach((element) {
      if(element.categories.contains(data.name.toString()))
      {
        _subProduct.add(element);
      }

    });

    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, '/subproduct', arguments: {'_subProducts': _subProduct, '_title': data.name});
      },
      child: Card(
        color: themeBG,
        //margin: EdgeInsets.all(8),
        child: Stack(
          children: <Widget>[
            data.image!=null?
            Container(
               // height: ITEMHEIGHT,
                child: CachedNetworkImage(
                  imageUrl: data.image.src,
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(
                          Radius.circular(8.0) //                 <--- border radius here
                      ),
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
                :Container(),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                alignment: Alignment.bottomRight,
               // height: ITEMHEIGHT,
                decoration: BoxDecoration(
                  border: Border.all(width: 0.0),
                  borderRadius: BorderRadius.all(
                      Radius.circular(8.0) //                 <--- border radius here
                  ),
                  image: DecorationImage(
                    image: AssetImage("assets/cornorRB.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Container(
                  margin: EdgeInsets.only(right: 15),
                  child: Text(
                    data.name  ,
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      fontFamily: "Header",
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.black
                    ),
                  ),
                )
              ),
            )

          ],
        ),
      )
    );

  }
}
