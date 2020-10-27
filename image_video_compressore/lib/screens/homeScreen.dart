import 'package:flutter/material.dart';
import 'package:flutter_slider_drawer/flutter_slider_drawer.dart';
import 'package:image_video_compressore/utilits/CommonFunctions.dart';
import 'package:image_video_compressore/utilits/const.dart';
import 'package:image_video_compressore/widgets/menuWidget.dart';

var BodyWidgets;

class homeScreen extends StatefulWidget {
  @override
  _homeScreenState createState() => _homeScreenState();
}

class _homeScreenState extends State<homeScreen> {
  GlobalKey<SliderMenuContainerState> _key =
      new GlobalKey<SliderMenuContainerState>();
  String title = "home";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      body: SliderMenuContainer(
        appBarColor: Colors.green,
        key: _key,
        sliderOpen: SliderOpen.LEFT_TO_RIGHT,
        appBarPadding: const EdgeInsets.only(top: 30),
        sliderMenuOpenOffset: MediaQuery.of(context).size.width * 0.7,
        appBarHeight: 60,

        title: Text(
          title,
          style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        ),
        sliderMenu: MenuWidget(
          onItemClick: (title, id) {
            print(id);

            if(id=="image"){

            }if(id=="video"){

            }if(id=="donate"){

            }if(id=="term"){

            }if(id=="policy"){

            }if(id=="update"){
              launchURL(appLink);
            }if(id=="rate"){
              launchURL(appLink);
            }if(id=="more_app"){
              launchURL(appSotre);

            }if(id=="about"){

            }

          },
        ),
        sliderMain: Container(
          color: Colors.blueGrey,
          child: BodyWidgets,
        ),
      ),
    );
  }
}
