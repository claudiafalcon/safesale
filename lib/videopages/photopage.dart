import 'dart:core';
import 'dart:ffi';

import 'package:amplify_flutter/amplify.dart';
import 'package:amplify_storage_s3/amplify_storage_s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/variables.dart';
import 'package:safesale/widgets/loading.dart';

class PhotoPage extends StatefulWidget {
  final String id;
  PhotoPage(this.id);
  @override
  _PhotoPageState createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  final _formKey = GlobalKey<FormState>();
  List _keys = <String>[];

  Future<String> getPhotos() async {
    try {
      S3ListOptions options =
          S3ListOptions(accessLevel: StorageAccessLevel.guest);
      ListResult res = await Amplify.Storage.list(
          path: "images/" + widget.id, options: options);

      await Future.forEach(res.items, (item) async {
        if (item.key.startsWith("images/" + widget.id) &&
            item.key.toUpperCase().endsWith("JPG")) {
          try {
            //GetUrlResult result = await Amplify.Storage.getUrl(key: item.key);
            _keys.add(item.key);
          } catch (e) {
            print(e.message);
          }
        }
      });
    } catch (e) {
      print(e.message);
    }

    return "Finalized";
  }

  @override
  void initState() {
    super.initState();
    // getPhotos();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10), topRight: Radius.circular(10)),
        child: Container(
          height: MediaQuery.of(context).size.height / 10 * 9.5,
          width: double.infinity,
          child: ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: CustomPaint(
                painter: PainterSoft(
                    Color.fromRGBO(52, 57, 59, 0.5),
                    Color.fromRGBO(0, 59, 139, 0.5),
                    Color.fromRGBO(52, 57, 59, 0.5),
                    0,
                    20),
                child: Container(
                  width: double.infinity,
                  //color: Color.fromRGBO(67, 73, 75, 0.83),
                  height: MediaQuery.of(context).size.height / 10 * 9.5,
                  child: Wrap(children: [
                    Container(
                      height: 5,
                    ),
                    Container(
                      height: MediaQuery.of(context).size.height / 10 * 8.5,
                      child: FutureBuilder<String>(
                          future: getPhotos(),
                          builder: (BuildContext context,
                              AsyncSnapshot<String> snapshot) {
                            if (snapshot.hasData) {
                              return StaggeredGridView.countBuilder(
                                  padding: const EdgeInsets.all(12.0),
                                  crossAxisCount: 2,
                                  mainAxisSpacing: 24,
                                  crossAxisSpacing: 12,
                                  itemCount: _keys.length,
                                  itemBuilder: (BuildContext context,
                                          int index) =>
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        child: Image.network(
                                          cloudfronturl + _keys[index],
                                        ),
                                      ),
                                  staggeredTileBuilder: (int index) =>
                                      index == 0
                                          ? StaggeredTile.fit(2)
                                          : StaggeredTile.fit(1));
                            } else if (snapshot.hasError) {
                              return Text('Error: ${snapshot.error}');
                            } else {
                              return LoadingPage(
                                opacity: 0.2,
                              );
                            }
                          }),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(
                                Color.fromRGBO(58, 184, 234, 1)),
                            minimumSize:
                                MaterialStateProperty.all(Size(100, 40)),
                          ),
                          child: Text("Cerrar",
                              textAlign: TextAlign.center,
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                    )
                  ]),

                  /*     ClipRRect(
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 10 * 9 / 15 * 2,
                      color: Color.fromRGBO(191, 191, 191, 0.78),
                      child: Text("Hi modal sheet")),*/
                ),
              )),
        ),
      ),
    );
  }
}
