import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_video_compressore/screens/imageCompressore.dart';


class ImageCompressorPicker extends StatefulWidget {
  @override
  _ImageCompressorPickerState createState() => _ImageCompressorPickerState();
}

class _ImageCompressorPickerState extends State<ImageCompressorPicker> {

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> compress() async {
    final img = AssetImage("assets/images/logo.PNG");
    print("pre compress");
    final config = new ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);

    final beforeCompress = data.lengthInBytes;
    print("beforeCompress = $beforeCompress");

    final result =
        await FlutterImageCompress.compressWithList(data.buffer.asUint8List());

    print("after = ${result?.length ?? 0}");
  }

  ImageProvider provider;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /* body: ListView(
          children: <Widget>[
            AspectRatio(
              child: Image(
                image: provider ?? AssetImage("assets/images/logo.PNG"),
                width: double.infinity,
                fit: BoxFit.contain,
              ),
              aspectRatio: 1 / 1,
            ),

            FlatButton(
              child: Text('CompressAndGetFile and rotate 90'),
              onPressed: getFileImage,
            ),

            FlatButton(
              child: Text('CompressList and rotate 270'),
              onPressed: compressListExample,
            ),


            FlatButton(
              child: Text('Convert to webp format, Just support android'),
              onPressed: _compressAndroidWebpExample,
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.computer),
          onPressed: () => setState(() => this.provider = null),
          tooltip: "show origin asset",
        ),*/
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(20),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ImageCompressor()));
              },
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        style: BorderStyle.solid, color: Colors.green)),
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.photo_camera),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Pick Images"),
                    )
                  ],
                ),
              ),
            ),
          ),
          Note(),
          Ads(),
        ],
      ),
    );
  }

  Note() {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.green,
        borderRadius: BorderRadius.circular(7),
      ),
      child: Text(
        "you can convert any type of images and also you can convert multiple images at a time.",
        style: TextStyle(color: Colors.white),
      ),
    );
  }

  Ads() {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.all(20),
      child: Image.asset(
        "assets/images/logo.PNG",
        fit: BoxFit.cover,
      ),
    );
  }
}
