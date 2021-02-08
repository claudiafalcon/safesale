import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_player/video_player.dart';
import 'variables.dart';

class ConfirmPage extends StatefulWidget {
  final File videofile;
  final String videopath_asitring;
  final ImageSource imageSource;

  ConfirmPage(this.videofile, this.videopath_asitring, this.imageSource);
  @override
  _ConfirmPageState createState() => _ConfirmPageState();
}

class _ConfirmPageState extends State<ConfirmPage> {
  VideoPlayerController controller;
  TextEditingController musiccontroller = TextEditingController();
  TextEditingController captioncontroller = TextEditingController();

  @override
  void initState() {
    super.initState();
    setState(() {
      controller = VideoPlayerController.file(widget.videofile);
    });
    controller.initialize();
    controller.play();
    controller.setVolume(1);
    // controller.setLooping(true);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  uploadvideo() async {
    //var firebaseuseruid =
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 1.5,
              child: VideoPlayer(controller),
            ),
            SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(left: 10, right: 10),
                      child: TextField(
                        controller: musiccontroller,
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            labelText: "Song name",
                            labelStyle: farsiSimpleStyle(20),
                            prefixIcon: Icon(Icons.music_note),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            )),
                      ),
                    ),
                    Container(
                      width: MediaQuery.of(context).size.width / 2,
                      margin: EdgeInsets.only(right: 40),
                      child: TextField(
                        controller: captioncontroller,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.white,
                          labelText: "Caption",
                          labelStyle: farsiSimpleStyle(20),
                          prefixIcon: Icon(Icons.closed_caption),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                    ),
                  ]),
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                RaisedButton(
                  onPressed: () {},
                  color: Colors.red,
                  child: Text(
                    "Subir video",
                    style: farsiSimpleStyle(20, Colors.white),
                  ),
                ),
                RaisedButton(
                  onPressed: () => Navigator.pop(context),
                  color: Colors.lightBlue,
                  child: Text(
                    "Otro Video",
                    style: farsiSimpleStyle(20, Colors.white),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
