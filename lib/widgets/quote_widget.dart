import 'dart:io';
import 'dart:typed_data';
import 'dart:ui';

import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:quotes_final/pages/About.dart';
import 'package:quotes_final/widgets/faded_pageroute.dart';
import 'package:screenshot/screenshot.dart';

// ignore: must_be_immutable
class QuoteWidget extends StatefulWidget {
  var quote = "";
  var author = "";
  var onShareClick;
  var onLikeClick;
  var bgColor;

  QuoteWidget(
      {this.bgColor,
      this.quote,
      this.author,
      this.onShareClick,
      this.onLikeClick});

  @override
  _QuoteWidgetState createState() => _QuoteWidgetState();
}

class _QuoteWidgetState extends State<QuoteWidget> {
  Uint8List _imageFile;
  var imagefile;
  List<String> imageb64 = [];
  //Create an instance of ScreenshotController
  ScreenshotController screenshotController = ScreenshotController();

  @override
  Widget build(BuildContext context) {
    return Screenshot(
      controller: screenshotController,
      child: SafeArea(
        child: Stack(children: [
          Container(
            color: widget.bgColor,
            padding: EdgeInsets.only(left: 30, right: 30),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Spacer(
                  flex: 2,
                ),
                Image.asset(
                  "assets/quote.png",
                  height: 30,
                  width: 30,
                  color: Colors.white,
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.quote,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(color: Colors.white, fontSize: 30),
                  ),
                ),
                SizedBox(
                  height: 30,
                ),
                Text(
                  widget.author,
                  style: GoogleFonts.lato(
                    textStyle: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                Spacer(),
                Container(
                  alignment: Alignment.center,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              imagefile = null;
                              // screenshotController
                              //     .capture(pixelRatio: 2)
                              //     .then(( Uint8List image) {
                              //   //print("Capture Done");
                              //   setState(() {
                              //     _imageFile = image ;
                              //   });
                              //   ImageGallerySaver.saveImage(_imageFile);
                              //   print("File Saved to Gallery");
                              //   final snackBar = SnackBar(
                              //       content: Text("Image saved to Gallary"));
                              //   ScaffoldMessenger.of(context)
                              //       .showSnackBar(snackBar);
                              // }).catchError((onError) {
                              //   print(onError);
                              // });
                              _savetogallery();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: Colors.white)),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.favorite,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Save to Gallery",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          )
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () async {
                              _takeScreenshotandShare();
                            },
                            child: Container(
                              margin: EdgeInsets.only(left: 10),
                              decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      width: 1, color: Colors.white)),
                              padding: EdgeInsets.all(10),
                              child: Icon(
                                Icons.share,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Share with",
                            style: TextStyle(
                                fontStyle: FontStyle.italic,
                                color: Colors.white),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Spacer(),
              ],
            ),
          ),
          IconButton(
              icon: Icon(Icons.info_outline_rounded, color: Colors.white),
              onPressed: () {
                Navigator.push(context, FadePageRoute(widget: About()));
              }),
        ]),
      ),
    );
  }

  // Future<void> _takescreenshot() async {
  //   Uint8List imagefile = await screenshotController.capture(pixelRatio: 2);
  //   imageb64 = imagefile as List<String>;
  //   await Share.shareFiles();
  // }
  _takeScreenshotandShare() async {
    _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((image) async {
      setState(() {
        _imageFile = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile;
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }

  _savetogallery() async {
    _imageFile = await screenshotController.capture(pixelRatio: 2);
    ImageGallerySaver.saveImage(_imageFile);
    print("File Saved to Gallery");
    final snackBar = SnackBar(content: Text("Image saved to Gallary"));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
