import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutterecom/WidgetHelper/CustomIcons.dart';
import 'package:flutterecom/WidgetHelper/homeCategoryHeader.dart';
import 'package:flutterecom/WidgetHelper/filters.dart';
import 'package:flutterecom/bloc/bloc_home.dart';
import 'package:flutterecom/list_views/home_product_grid_view.dart';
import 'package:flutterecom/list_views/home_product_list_view.dart';
import 'package:flutterecom/main.dart';
import 'package:flutterecom/models/responce/getAllProductsResponceModel.dart';
import 'package:flutterecom/screens/homefragments/cartWidget.dart';
import 'package:flutterecom/screens/homefragments/categoryWidget.dart';
import 'package:flutterecom/screens/homefragments/productsWidget.dart';
import 'package:flutterecom/screens/homefragments/settingwidget.dart';
import 'package:flutterecom/screens/splashWidget.dart';
import 'package:flutterecom/screens/userProfileWidget.dart';
import 'package:flutterecom/utils/appTheme.dart';
import 'package:flutterecom/utils/consts.dart';
import 'package:flutterecom/utils/languages_local.dart';
import 'package:flutterecom/utils/prefrences.dart';
import 'package:rate_my_app/rate_my_app.dart';
import 'package:share/share.dart';

int tabIndex = 0;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List cartList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool enabled = false; // tracks if drawer should be opened or not
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    prefs.setBool(ISFIRSTOPEN, false);
  }

  @override
  Widget build(BuildContext context) {
    cartList = getCartProductsPref();
    return DefaultTabController(
        // Added
        length: TabBarCount, // Added
        initialIndex: tabIndex, //Added
        child: Scaffold(
            key: _scaffoldKey,
            // assign key to Scaffold
            drawer: drawerWidget(),
            backgroundColor: themeBG,
            bottomNavigationBar: navTabItem(),
            body: SafeArea(
              child: body(),
            )));
  }

  Widget body() {
    tabIndex = 0;
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
                    drawerButtonIcon(() {
                      _scaffoldKey.currentState.openDrawer();
                    }, Icons.menu),
                    Text(
                      APPNAME,
                      style: TextStyle(
                        color: themeAppBarItems,
                        fontSize: 20.0,
                        fontFamily: "Header",
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Container(),
                  ],
                ),
              )),
          Expanded(
            flex: 10,
            child: TabBarView(
              children: [
                ProductScreen(),
                CategoryScreen(),
                CartScreen(false),
                SettingScreen(() {
                  setState(() {});
                }),
              ],
            ),
          ),
        ],
      ),
    );
  }

  drawerWidget() {
    return Drawer(
        child: StreamBuilder(
      stream: homeBloc.getProductCategoryStreamController.stream,
      initialData: categories,
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        return snapshot.data != null
            ? Container(
                color: themeBG,
                child: ListView(
                  children: [
                    Container(
                        alignment: Alignment.center,
                        height: MediaQuery.of(context).size.height * 0.2,
                        child: Image.asset(
                          'assets/logo.png',
                          width: 80,
                          height: 80,
                        )),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, "/home");
                      },
                      child: Container(
                        color: themeBG,
                        padding: EdgeInsets.all(20),
                        child: Text(
                          LocalLanguageString().home,
                          style: TextStyle(
                            fontFamily: "Header",
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                            color: themeTextColor,
                          ),
                        ),
                      ),
                    ),
                    Container(
                        child: Container(
                      color: themeBG,
                      padding: EdgeInsets.only(
                          top: 20.0, left: 6.0, right: 6.0, bottom: 6.0),
                      child: Column(
                        children: [
                          ExpansionTile(
                            initiallyExpanded: true,
                            title: Text(
                              LocalLanguageString().bycategory,
                              style: TextStyle(
                                fontFamily: "Header",
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: themeTextColor,
                              ),
                            ),
                            children: []
                              ..add(Divider(
                                height: 1,
                              ))
                              ..addAll(
                                List.generate(categories.length, (index) {
                                  print(categories.length);
                                  /* print("________________________");
                                  print(categories[index].toJson());
                                  print(categories.length);
*/
                                  if (categories[index].image == null) {
                                    if (categories[index].name == "All") {
                                      return getListItem(
                                          categories[index].image != null
                                              ? categories[index].image.src
                                              : "",
                                          categories[index].name,
                                          "",
                                          categories[index].description,
                                          Icons.arrow_forward_ios, () {
                                        List<GetAllProducts> _subProduct =
                                            List();
                                        products.forEach((element) {
                                          if (element.categories.contains(
                                              categories[index]
                                                  .name
                                                  .toString())) {
                                            _subProduct.add(element);
                                          }
                                        });
                                        Navigator.pushNamed(
                                            context, '/subproduct', arguments: {
                                          '_subProducts': _subProduct,
                                          '_title': categories[index].name
                                        });
                                      });
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return getListItem(
                                        categories[index].image != null
                                            ? categories[index].image.src
                                            : "",
                                        categories[index].name,
                                        "",
                                        categories[index].description,
                                        Icons.arrow_forward_ios, () {
                                      List<GetAllProducts> _subProduct = List();
                                      products.forEach((element) {
                                        if (element.categories.contains(
                                            categories[index]
                                                .name
                                                .toString())) {
                                          _subProduct.add(element);
                                        }
                                      });
                                      Navigator.pushNamed(
                                          context, '/subproduct', arguments: {
                                        '_subProducts': _subProduct,
                                        '_title': categories[index].name
                                      });
                                    });
                                  }
                                }),
                              ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 7),
                            child: InkWell(
                              onTap: () async {
                                tabIndex = 3;
                                Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (BuildContext context) =>
                                            HomeScreen()));
                              },
                              child: ListTile(
                                title: Text(
                                  "Setting",
                                  style: TextStyle(
                                      color: themeTextColor,
                                      fontSize: 14,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                            ),
                          ),
                          getListItemLogout(
                              Icons.call_missed_outgoing,
                              (prefs.getBool(ISLOGIN) ?? false)
                                  ? LocalLanguageString().logout
                                  : LocalLanguageString().login,
                              "",
                              "",
                              null, () {
                            if (prefs.getBool(ISLOGIN) ?? false) {
                              prefs.setBool(ISLOGIN, false);
                              setState(() {});
                            } else {
                              Navigator.pushNamed(context, '/login',
                                  arguments: {
                                    '_amount': 0.0,
                                    '_nextToGo': "/home"
                                  });
                            }
                          }),
                        ],
                      ),
                    ))
                  ],
                ))
            : Container(
                color: themeBG,
              );
      },
    ));
  }

  Widget getListItemLogout(IconData icon, String title, String extendedTitle,
      String description, IconData trailing, Function callback) {
    return ListTile(
      onTap: callback,
      title: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
                color: themeTextColor,
                fontSize: 14,
                fontWeight: FontWeight.w600),
          ),
          SizedBox(
            width: 16.0,
          ),
          Text(
            extendedTitle,
            style: TextStyle(
              fontWeight: FontWeight.w400,
              fontSize: 14,
              color: themeTextColor,
            ),
          ),
        ],
      ),
      subtitle: Text(
        description,
        style: TextStyle(
          fontWeight: FontWeight.w400,
          fontSize: 14,
          color: themeTextColor,
        ),
      ),
      trailing: Icon(
        trailing,
      ),
    );
  }

  Widget getListItem(String categoryUrl, String title, String extendedTitle,
      String description, IconData trailing, Function callback) {
    return ListTile(
      onTap: callback,
      title: Row(
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              fontFamily: "Normal",
              fontWeight: FontWeight.w600,
              fontSize: 13,
              color: themeTextColor,
            ),
          ),
          SizedBox(
            width: 16.0,
          ),
          Text(
            extendedTitle,
            style: TextStyle(
              fontFamily: "Normal",
              fontWeight: FontWeight.w600,
              fontSize: 12,
              color: themeTextColor,
            ),
          ),
        ],
      ),
//      subtitle: Text(description,overflow: TextOverflow.ellipsis,
//        style: TextStyle(
//          fontFamily: "Normal",
//          fontWeight: FontWeight.w600,
//          fontSize: 12,
//          color: themeTextColor,
//        ),
//      ),
      trailing: Icon(
        trailing,
        size: 12,
      ),
    );
  }
}
