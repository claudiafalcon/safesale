import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safesale/confirmation.dart';

import 'package:safesale/variables.dart';

class AddVideoPage extends StatefulWidget {
  @override
  _AddVideoPageState createState() => _AddVideoPageState();
}

class _AddVideoPageState extends State<AddVideoPage> {
  pickvideo(ImageSource src) async {
    Navigator.pop(context);
    final video = await ImagePicker().getVideo(source: src);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) =>
                ConfirmPage(File(video.path), video.path, src)));
  }

  showoptionsdialog() {
    return showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            children: [
              SimpleDialogOption(
                onPressed: () => pickvideo(ImageSource.gallery),
                child: Text(
                  "Galería",
                  style: farsiSimpleStyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => pickvideo(ImageSource.camera),
                child: Text(
                  "Camara",
                  style: farsiSimpleStyle(20),
                ),
              ),
              SimpleDialogOption(
                onPressed: () => Navigator.pop(context),
                child: Text(
                  "Cancel",
                  style: farsiSimpleStyle(20),
                ),
              ),
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InkWell(
        onTap: () => showoptionsdialog(),
        child: Container(
          width: 190,
          height: 80,
          decoration: BoxDecoration(color: Colors.red[200]),
          child: Center(
            child: Text(
              "Add Video",
              style: farsiSimpleStyle(30),
            ),
          ),
        ),
      ),
    );
  }
}
