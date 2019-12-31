import 'dart:typed_data';
import 'dart:ui';
//import 'package:flutter_exif_rotation/flutter_exif_rotation.dart';

import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker_saver/image_picker_saver.dart' as Saver;
import 'dart:async';
import 'package:tflite/tflite.dart';
import 'package:image/image.dart' as img;
//import 'package:flutter_native_image/flutter_native_image.dart';
import 'package:toast/toast.dart';
import 'package:image_jpeg/image_jpeg.dart';
import 'package:image_cropper/image_cropper.dart';

Uint8List bin;

class Body extends StatefulWidget {
  @override
  _BodyState createState() => _BodyState();
}

class _BodyState extends State<Body> {
  File _image;
  img.Image globalImage;
  double div, x;
  String res;

  void savePhoto(Uint8List file) async {
    await Saver.ImagePickerSaver.saveFile(fileData: file).then((onValue) {
      print("File saved in " + onValue);
      Toast.show("File saved in " + onValue, context,
          duration: Toast.LENGTH_LONG);
    });
  }

  Future snapPhoto() async {
    await Saver.ImagePickerSaver.pickImage(source: Saver.ImageSource.camera)
        .then((image) async{
      if (image != null) {
        await ImageCropper.cropImage(
            sourcePath: image.path,
            aspectRatioPresets: [
              CropAspectRatioPreset.square,
            ],
            androidUiSettings: AndroidUiSettings(
                toolbarTitle: 'Portrait Mode',
                toolbarColor: Colors.blue,
                toolbarWidgetColor: Colors.white,
                initAspectRatio: CropAspectRatioPreset.original,
                lockAspectRatio: false),
            iosUiSettings: IOSUiSettings(
              minimumAspectRatio: 1.0,
            )).then((outputFile) {
          setState(() {
            _image = outputFile;
            div = 0.0;
            x = 0.0;
          });
        });
      }
    });
    /*if (image != null) {
      await FlutterNativeImage.getImageProperties(image.path)
          .then((prop) async {
        image = await FlutterNativeImage.compressImage(image.path,
            quality: 100,
            percentage: 100,
            targetHeight: prop.height,
            targetWidth: prop.width);
        image = await FlutterExifRotation.rotateImage(
          path: image.path,
        );

        setState(() {
          _image = image;
          div = 0.0;
          x = 0.0;
        });
      });
      await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Portrait Mode',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )).then((outputFile) {
        setState(() {
          _image = outputFile;
          div = 0.0;
          x = 0.0;
        });
      });*/
    
  }

  Future pickPhoto() async {
    var image = await Saver.ImagePickerSaver.pickImage(
        source: Saver.ImageSource.gallery);
    if (image != null) {
      /*await FlutterNativeImage.getImageProperties(image.path)
          .then((prop) async {
        image = await FlutterNativeImage.compressImage(image.path,
            quality: 100,
            percentage: 100,
            targetHeight: prop.height,
            targetWidth: prop.width);
        image = await FlutterExifRotation.rotateImage(
          path: image.path,
        );

        setState(() {
          _image = image;
          div = 0.0;
          x = 0.0;
        });
      });*/
      await ImageCropper.cropImage(
          sourcePath: image.path,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
          ],
          androidUiSettings: AndroidUiSettings(
              toolbarTitle: 'Portrait Mode',
              toolbarColor: Colors.blue,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          iosUiSettings: IOSUiSettings(
            minimumAspectRatio: 1.0,
          )).then((outputFile) {
        setState(() {
          _image = outputFile;
          div = 0.0;
          x = 0.0;
        });
      });
    }
  }

  Future<List<int>> blurData(img.Image imageFile) async {
    List<int> data =
        await ImageJpeg.blurImage(img.encodeJpg(imageFile), 10, 4, 0);
    return data;
  }

  Future<Map> imageInfoBlur(File image) async {
    img.Image info = img.decodeImage(image.readAsBytesSync());
    img.Image blur = img.decodeImage(await ImageJpeg.blurImage(
        img.encodeJpg(info), div.floor(), (div / 2).floor(), 0, 90));
    //img.Image blur = info;
    blur = img.copyResize(blur,
        height: (info.height / 2).floor(), width: (info.width / 2).floor());
    blur = img.copyResize(blur, height: info.height, width: info.width);
    Map returnDataMap = {
      'info': info,
      'blur': blur,
    };
    return returnDataMap;
  }

  Future releaseModel() async {
    await Tflite.close();
  }

  Future initModel() async {
    //await releaseModel();
    res = await Tflite.loadModel(
      model: "assets/deeplabv3_257_mv_gpu.tflite",
      //model: 'assets/frozen_inference_graph.tflite',
      labels: "assets/deeplabv3_257_mv_gpu.txt",
      numThreads: 2,
    );
  }

  Future segmentBits(File file) async {
    var result = await Tflite.runSegmentationOnImage(
      path: file.path,
      outputType: "png",
      asynch: true,
      imageStd: 257,
    );
    return result;
  }

  Widget selectorBody() {
    releaseModel().whenComplete(() {
      print("Model Realeased");
    });
    initModel().whenComplete(() {
      print("Model Initialised");
    });
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          FlatButton(
            onPressed: () {
              pickPhoto();
              print("Picked!");
            },
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(Icons.photo),
                Text("Pick a Photo"),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              snapPhoto();
              print("Snaped!");
            },
            child: Row(
              children: <Widget>[
                Icon(Icons.camera),
                Text("Snap a photo"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget editorBody() {
    return Padding(
      padding: EdgeInsets.all(0),
      child: Container(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                child: bin == null
                    ? Image.file(_image)
                    : FutureBuilder(
                        future: imageInfoBlur(_image),
                        initialData: img.decodeImage(_image.readAsBytesSync()),
                        builder: (cont, snap) {
                          if (snap != null && bin != null) {
                            var globalWatch = Stopwatch()..start();
                            img.Image mask = img.copyResize(
                              img.decodeImage(bin),
                              height: snap.data['info'].height.round(),
                              width: snap.data['info'].width.round(),
                            );
                            img.Image front =
                                img.decodeImage(_image.readAsBytesSync());
                            /*img.Image back = img.copyResize(front,
                                width: (front.width / div).floor(),
                                height: (front.height / div).floor());
                            back = img.copyResize(back,
                                width: front.width, height: front.height);*/
                            var stopWatch = Stopwatch()..start();
                            img.Image back = snap.data['blur'];
                            for (var x = 0; x < mask.width; x++) {
                              for (var y = 0; y < mask.height; y++) {
                                if (mask.getPixel(x, y) == 4278190080)
                                  front.setPixel(
                                      x, y, (back.getPixel(x, y)).floor());
                                //front.setPixel(x, y, 3000000000);
                              }
                            }
                            globalImage = front;
                            stopWatch..stop();
                            print(
                                "Adding both images took ${stopWatch.elapsed.inMilliseconds.toString()} millisecond");
                            //Toast.show("Adding both images took ${stopWatch.elapsed.inMilliseconds.toString()} millisecond", context, duration: Toast.LENGTH_LONG, gravity: Toast.TOP);
                            stopWatch..start();
                            var result = Image.memory(img.encodeJpg(front));
                            stopWatch..stop();
                            globalWatch..stop();
                            print(
                                "Encoding result took ${stopWatch.elapsed.inMilliseconds.toString()} millisecond");
                            print(
                                "Global result took ${globalWatch.elapsed.inMilliseconds.toString()} millisecond");
                            return result;
                          } else
                            return CircularProgressIndicator(
                              backgroundColor: Colors.red,
                              value: null,
                              strokeWidth: 2.0,
                            );
                        },
                      ),
              ),
              FlatButton(
                child: Text("Segment"),
                onPressed: () {
                  var stopWatch = Stopwatch()..start();
                  segmentBits(_image).then((arrayPng) {
                    setState(() {
                      stopWatch..stop();
                      print(
                          "Segmanting result took ${stopWatch.elapsed.inMilliseconds.toString()} milliseconds");
                      Toast.show(
                          "Segmanting result took ${stopWatch.elapsed.inMilliseconds.toString()} milliseconds",
                          context,
                          duration: Toast.LENGTH_LONG);
                      bin = arrayPng;
                      releaseModel().whenComplete(() {
                        print("Model released!");
                      }).catchError((onError) {
                        print(
                            "error releasing the model!\n${onError.toString()}");
                      });
                    });
                  });
                },
              ),
              Slider(
                value: x,
                min: 0.0,
                max: 20.0,
                divisions: 20,
                onChanged: (y) {
                  setState(() {
                    x = y;
                  });
                },
                onChangeEnd: (y) {
                  setState(() {
                    div = y;
                    print(div);
                  });
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.delete),
                    Text("Delete"),
                  ],
                ),
                onPressed: () {
                  setState(() {
                    _image = null;
                    bin = null;
                  });
                },
              ),
              FlatButton(
                child: Row(
                  children: <Widget>[
                    Icon(Icons.save),
                    Text("Save"),
                  ],
                ),
                onPressed: () {
                  /*_controller.capture().then((File widget) {
                    savePhoto(widget);
                  });*/
                  savePhoto(img.encodeJpg(globalImage));
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    div = 0.0;
    x = 0.0;
    globalImage = null;
  }

  @override
  Widget build(BuildContext context) {
    return _image == null ? selectorBody() : editorBody();
  }
}
