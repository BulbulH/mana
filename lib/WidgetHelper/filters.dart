import 'package:flutter/material.dart';
import 'package:flutterecom/emuns/pricingType.dart';
import 'package:flutterecom/emuns/ratingType.dart';
import 'package:flutterecom/models/responce/getAllCategoriesResponceModel.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/screens/splashWidget.dart';

class Filters extends StatefulWidget {

  const Filters({Key key}) : super(key: key);

  @override
  _QuizOptionsDialogState createState() => _QuizOptionsDialogState();
}

class _QuizOptionsDialogState extends State<Filters> {
  RatingType _selRating = RatingType.All;
  String _selTags = "";
  String _selCategory = "";
  String _selAttribute = "";
  String _selAttributeOption = "";

  @override
  void initState() { 
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    List<String> listTags=List();
    products.forEach((element) {
      if(element.tags.length>0) {
        Set<String> _override =listTags.toSet();
        _override.addAll(element.tags.toSet());
        listTags=(_override.toList());
      }
    });

    Map<String,List<String>> listAttributes=Map();
    products.forEach((_product) {
      _product.attributes.forEach((attr) {
        if (attr.options.length > 0) {
          if (listAttributes.containsKey(attr.name)) {
            Set<String> _override = listAttributes[attr.name].toSet();
            _override.addAll(attr.options.toSet());
            listAttributes[attr.name] = _override.toList();
          } else
            listAttributes[attr.name] = attr.options;
        }
      });
    });

    return SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(right: 20,left: 20),
          color: themeBG,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: double.infinity,
                margin: EdgeInsets.all(16.0),
                color: themeBG,
                child: Text(
                  LocalLanguageString().searchfilters,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: themeTextHighLightColor,
                      fontSize: 15.0,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Header"
                  ),
                ),
              ),
              Divider(height: 2,),
              SizedBox(height: 10.0),

              SizedBox(height: 10.0),
              Text(
                "Tags",
                style: TextStyle(
                  color: themeAppBarItems,
                  fontSize: 17.0,
                  fontFamily: "Header",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: themeBG,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: listTags.map((tag) {
                      return _itemViewTags(tag,(){
                        setState(() {
                          _selTags = tag;
                        });
                      });
                    }).toList(),
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Category",
                style: TextStyle(
                  color: themeAppBarItems,
                  fontSize: 17.0,
                  fontFamily: "Header",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: themeBG,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: categories.map((cat) {
                      return _itemViewCategory(cat.name,(){
                        setState(() {
                          _selCategory = cat.name;
                        });
                      });
                    }).toList(),
                  ),
                ),
              ),

              SizedBox(height: 10.0),
              Text(
                "Attributes",
                style: TextStyle(
                  color: themeAppBarItems,
                  fontSize: 17.0,
                  fontFamily: "Header",
                  fontWeight: FontWeight.bold,
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: themeBG,
                  child: Wrap(
                    alignment: WrapAlignment.start,
                    runAlignment: WrapAlignment.start,
                    children: listAttributes.keys.map((attName) {
                      return _itemViewAttribute(attName,(){
                        setState(() {
                          _selAttribute = attName;
                        });
                      });
                    }).toList()
                  ),
                ),
              ),
              SizedBox(height: 10.0),

              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  color: themeBG,
                  child: Wrap(
                      alignment: WrapAlignment.start,
                      runAlignment: WrapAlignment.start,
                      children: listAttributes[_selAttribute]!=null?listAttributes[_selAttribute].map((attrOptions) {
                        return _itemViewAttributeOptions(attrOptions,(){
                          setState(() {
                            _selAttributeOption = attrOptions;
                          });
                        });
                      }).toList():
                         [Container()]
                  ),
                ),
              ),
              Text(
                "Rating",
                style: TextStyle(
                  color: themeAppBarItems,
                  fontSize: 17.0,
                  fontFamily: "Header",
                  fontWeight: FontWeight.bold,
                ),
              ),
              Container(
                color: themeBG,
                width: double.infinity,
                child: Row(
                  children: RatingType.values.map((type) {
                    return _itemRating(type,(){
                      _selectRating(type);
                    });
                  }).toList(),
                ),
              ),
              Divider(height: 2,),
              RaisedButton(
                child: Text(
                    LocalLanguageString().submitfilter
                ),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0)
                ),
                color: themeBG,
                textColor: themeTextColor,
                onPressed: submit,
              ),
              SizedBox(height: 20.0),
            ],
          ),
        ),
      );
  }


  //------------------------TAGS --------------------------//
  Widget _itemViewTags(String tagsItem,Function callBack) {
    return GestureDetector(
      onTap: () => callBack(),
      child:  Container(
        constraints: BoxConstraints(minWidth: 60),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: themeTextColor.withAlpha(30), width: 1),
            color:_selTags == tagsItem ?  themeTextColor.withAlpha(20) : transparent
        ),
        child: Text(
          tagsItem,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Header",
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _selTags == tagsItem
                ? themeTextHighLightColor
                : themeTextColor,
          ),
        ),
      ),
    );

  }


  //------------------------CATEGORIES --------------------------//
  Widget _itemViewCategory(String categoryItem,Function callBack) {
    return GestureDetector(
      onTap: () => callBack(),
      child:  Container(
        constraints: BoxConstraints(minWidth: 60),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: themeTextColor.withAlpha(30), width: 1),
            color:_selCategory == categoryItem ?  themeTextColor.withAlpha(20) : transparent
        ),
        child: Text(
          categoryItem,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Header",
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _selCategory == categoryItem
                ? themeTextHighLightColor
                : themeTextColor,
          ),
        ),
      ),
    );

  }

  //------------------------ATTRIBUTES --------------------------//
  Widget _itemViewAttribute(String attributeItem,Function callBack) {
    return GestureDetector(
      onTap: () => callBack(),
      child:  Container(
        constraints: BoxConstraints(minWidth: 60),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: themeTextColor.withAlpha(30), width: 1),
            color:_selAttribute == attributeItem ?  themeTextColor.withAlpha(20) : transparent
        ),
        child: Text(
          attributeItem,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Header",
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _selAttribute == attributeItem
                ? themeTextHighLightColor
                : themeTextColor,
          ),
        ),
      ),
    );

  }


  //------------------------ATTRIBUTESOPTIONS --------------------------//
  Widget _itemViewAttributeOptions(String attributeOptionItem,Function callBack) {
    return GestureDetector(
      onTap: () => callBack(),
      child:  Container(
        constraints: BoxConstraints(minWidth: 60),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: themeTextColor.withAlpha(30), width: 1),
            color:_selAttributeOption == attributeOptionItem ?  themeTextColor.withAlpha(20) : transparent
        ),
        child: Text(
          attributeOptionItem,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Header",
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _selAttributeOption == attributeOptionItem
                ? themeTextHighLightColor
                : themeTextColor,
          ),
        ),
      ),
    );
  }

  //------------------------RATTINGS --------------------------//
  Widget _itemRating(RatingType _rating,Function callBack) {
    return GestureDetector(
      onTap: () => callBack(),
      child:  Container(
        constraints: BoxConstraints(minWidth: 60),
        alignment: Alignment.center,
        margin: EdgeInsets.all(10),
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
            border: Border.all(color: themeTextColor.withAlpha(30), width: 1),
            color:_selRating == _rating ?  themeTextColor.withAlpha(20) : transparent
        ),
        child: Text(
          _rating.toString().split(".")[1],
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: "Header",
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: _selRating == _rating
                ? themeTextHighLightColor
                : themeTextColor,
          ),
        ),
      ),
    );
  }

  _selectRating(RatingType _rating) {
    setState(() {
      _selRating = _rating;
    });
  }


  void submit() async {
    List<GetAllProducts> _filteredproducts=new List();
    List tempRating= _selRating==RatingType.All?[0.0,5.0]:
    _selRating==RatingType.Good?[3.5,5.0]:
    _selRating==RatingType.Average?[2.0,3.5]:
    _selRating==RatingType.Below?[0.0,2.0]:[0.0,5.0];



    products.forEach((_product){
      if (double.parse(_product.average_rating)>=tempRating[0] && double.parse(_product.average_rating)<=tempRating[1]
        && (_selTags=="" || (_selTags!="" && _product.tags.contains(_selTags)) )
        && (_selCategory=="" || (_selCategory!="" && _product.categories.contains(_selCategory)) )
          ){

        ProductAttributes productAttr =_product.attributes.firstWhere((_attrs) =>
            (_selAttribute=="" || (_selAttribute!="" && _attrs.name==_selAttribute)
            && (_selAttributeOption=="" || (_selAttributeOption!="" && _attrs.options.contains(_selAttributeOption)) )
            ), orElse: () => null);
        if(productAttr!=null || _selAttribute=="")
          {
            _filteredproducts.add(_product);

          }
      }
    });

    Navigator.pushNamed(context, '/subproduct', arguments: {'_subProducts': _filteredproducts, '_title': "Filter"});
  }
}