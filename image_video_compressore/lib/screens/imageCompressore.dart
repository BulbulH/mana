import 'dart:async';
import 'dart:io';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_video_compressore/utilits/TimeLogger.dart';
import 'package:image_video_compressore/utilits/resource.dart';
import 'package:path_provider/path_provider.dart' as path_provider;

class ImageCompressor extends StatefulWidget {
  @override
  _ImageCompressorState createState() => _ImageCompressorState();
}

class _ImageCompressorState extends State<ImageCompressor> {

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
  bool newItem=true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Total 1 Images"),
      ),
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
      body: Container(
        margin: EdgeInsets.all(7),
        child: Column(
          children: [
            ItemNewOrOrginalButton(),
            
          ],
        ),
      )
    );
  }

  Widget ItemNewOrOrginalButton() {
    return Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.green),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Expanded(
                  child: FlatButton(
                    child: Text("New",
                    style: TextStyle(
                      color: newItem?Colors.green:Colors.black
                    ),),
                    onPressed: (){
                      setState(() {
                        newItem=true;
                      });
                    },
                  ),
                ),

                Expanded(
                  child: FlatButton(
                    child: Text("Orginal",style: TextStyle(
                        color: !newItem?Colors.green:Colors.black
                    ),),
                    onPressed: (){
                      setState(() {
                        newItem=false;
                      });
                    },
                  ),
                ),
              ],
            ),
          );
  }

  Future<Directory> getTemporaryDirectory() async {
    return Directory.systemTemp;
  }

  File createFile(String path) {
    final file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }

    return file;
  }

  Future<String> getExampleFilePath() async {
    final img = AssetImage("assets/images/logo.PNG");
    print("pre compress");
    final config = new ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final dir = await path_provider.getTemporaryDirectory();

    File file = createFile("${dir.absolute.path}/test.png");
    file.createSync(recursive: true);
    file.writeAsBytesSync(data.buffer.asUint8List());
    return file.absolute.path;
  }

  void getFileImage() async {
    final img = AssetImage("assets/images/logo.PNG");
    print("pre compress");
    final config = new ImageConfiguration();

    AssetBundleImageKey key = await img.obtainKey(config);
    final ByteData data = await key.bundle.load(key.name);
    final dir = await path_provider.getTemporaryDirectory();

    File file = createFile("${dir.absolute.path}/test.png");
    file.writeAsBytesSync(data.buffer.asUint8List());

    final targetPath = dir.absolute.path + "/temp.jpg";
    final imgFile = await testCompressAndGetFile(file, targetPath);

    provider = FileImage(imgFile);
    setState(() {});
  }

  Future<Uint8List> testCompressFile(File file) async {
    print("testCompressFile");
    final result = await FlutterImageCompress.compressWithFile(
      file.absolute.path,
      minWidth: 2300,
      minHeight: 1500,
      quality: 94,
      rotate: 180,
    );
    print(file.lengthSync());
    print(result.length);
    return result;
  }

  Future<File> testCompressAndGetFile(File file, String targetPath) async {
    print("testCompressAndGetFile");
    final result = await FlutterImageCompress.compressAndGetFile(
      file.absolute.path,
      targetPath,
      quality: 90,
      minWidth: 1024,
      minHeight: 1024,
      rotate: 90,
    );

    print(file.lengthSync());
    print(result.lengthSync());

    return result;
  }

  Future compressListExample() async {
    final data = await rootBundle.load("assets/images/logo.PNG");

    final memory = await testComporessList(data.buffer.asUint8List());

    setState(() {
      this.provider = MemoryImage(memory);
    });
  }

  Future<Uint8List> testComporessList(Uint8List list) async {
    final result = await FlutterImageCompress.compressWithList(
      list,
      minHeight: 1080,
      minWidth: 1080,
      quality: 96,
      rotate: 270,
      format: CompressFormat.webp,
    );
    print(list.length);
    print(result.length);
    return result;
  }

  void writeToFile(List<int> list, String filePath) {
    final file = File(filePath);
    file.writeAsBytes(list, flush: true, mode: FileMode.write);
  }

  void _compressAndroidWebpExample() async {
    // Android compress very nice, but the iOS encode UIImage to webp is slow.
    final logger = TimeLogger();
    logger.startRecoder();
    print("start compress webp");
    final quality = 90;
    final tmpDir = (await getTemporaryDirectory()).path;
    final target =
        "$tmpDir/${DateTime.now().millisecondsSinceEpoch}-$quality.webp";
    final srcPath = await getExampleFilePath();
    final result = await FlutterImageCompress.compressAndGetFile(
      srcPath,
      target,
      format: CompressFormat.webp,
      minHeight: 800,
      minWidth: 800,
      quality: quality,
    );
    print("Compress webp success.");
    logger.logTime();
    print("src, path = $srcPath length = ${File(srcPath).lengthSync()}");
    print(
        "Compress webp result path: ${result.absolute.path}, size: ${result.lengthSync()}");

    provider = FileImage(result);
    setState(() {});
  }


}

Future<Uint8List> getAssetImageUint8List(String key) async {
  final byteData = await rootBundle.load(key);
  return byteData.buffer.asUint8List();
}

double calcScale({
  double srcWidth,
  double srcHeight,
  double minWidth,
  double minHeight,
}) {
  final scaleW = srcWidth / minWidth;
  final scaleH = srcHeight / minHeight;

  final scale = math.max(1.0, math.min(scaleW, scaleH));

  return scale;
}
