import 'package:flutter/material.dart';

class MenuWidget extends StatelessWidget {
  final Function(String, String) onItemClick;

  const MenuWidget({Key key, this.onItemClick}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.green,
      padding: const EdgeInsets.only(top: 30),
      child: Container(
        color: Colors.blueGrey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              height: 48,
              color: Colors.green,
              child: Center(child: Text("Menu",
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
              )),
            ),
            logo(MediaQuery.of(context).size),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    sliderItem('Image Compressor', Icons.photo_library, "image"),
                    sliderItem('Video Compressor', Icons.video_library, "video"),
                    sliderItem('Donate', Icons.monetization_on, "donate"),
                    sliderItem('Term & Conditions', Icons.launch, "term"),
                    sliderItem('Privacy Policy', Icons.security, "policy"),
                    sliderItem('Check Update', Icons.update, "update"),
                    sliderItem('Rate Us', Icons.stars, "rate"),
                    sliderItem('More Apps', Icons.apps, "more_app"),
                    sliderItem('About Us', Icons.supervised_user_circle, "about"),

                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget sliderItem(String title, IconData icons, String id) => ListTile(
      title: Text(
        title,
        style:
        TextStyle(color: Colors.white, fontFamily: 'BalsamiqSans_Regular',),
      ),
      leading: Icon(
        icons,
        color: Colors.white,
      ),
      onTap: () {
        onItemClick(title, id);
      });

  logo(var size) {
    return Container(
      decoration: BoxDecoration(
        gradient: new LinearGradient(
            colors: [
              Colors.green,
              Colors.green.withOpacity(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            stops: [0.0, 1.0],
            tileMode: TileMode.clamp),
      ),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(8),
            width: size.width/2.7,
            child: ClipRRect(
                borderRadius: BorderRadius.circular(500),
                child: Image.asset("assets/images/logo.PNG",fit: BoxFit.cover,),),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("AppPanda",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.w700
            ),),
          ),
          Divider(
            height: 1,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}