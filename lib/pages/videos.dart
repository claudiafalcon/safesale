import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:safesale/models/media.dart';
import 'package:safesale/models/property.dart';

import 'package:safesale/variables.dart';
import 'package:safesale/widgets/circle_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safesale/services/search_service.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _searchService = SearchService();

  @override
  initState() {
    super.initState();
  }

  buildprofile() {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: (60 / 2) - (50 / 2),
            child: Container(
              width: 50,
              height: 50,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color.fromARGB(20, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SvgPicture.asset(
                  'images/CAMPANA.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: (60 / 2),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(
                Icons.add,
                size: 20,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  buildicon(String svgname, Text text) {
    return Container(
      width: 40,
      height: 70,
      child: Stack(
        children: [
          Positioned(
            top: 0,
            child: Container(
                width: 40,
                height: 40,
                padding: EdgeInsets.all(1),
                child: SvgPicture.asset(
                  svgname,
                  color: Colors.white,
                )),
          ),
          Positioned(
            bottom: 0,
            child: Container(height: 30, width: 40, child: text),
          ),
        ],
      ),
    );
  }

  buildmusicalalbum() {
    return Container(
      width: 69,
      height: 60,
      child: Column(children: [
        Container(
          padding: EdgeInsets.all(11.0),
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              gradient:
                  LinearGradient(colors: [Colors.grey[800], Colors.grey[700]]),
              borderRadius: BorderRadius.circular(25)),
          // child: Image(
          // image: NetworkImage(
          //   'https://homepages.cae.wisc.edu/~ece533/images/baboon.png'),
          //fit: BoxFit.cover,
          //
          //)
        )
      ]),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Property>>(
          future: _searchService.fetchProperties(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(child: CircularProgressIndicator());
            }
            return PageView.builder(
                itemCount: snapshot.data.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Property property = snapshot.data[index];
                  return Stack(children: [
                    VideoPlayerItem(property.video.key)
                    //video
                    ,
                    Column(children: [
                      // top section
                      Container(
                        height: 150,
                        child: Row(
                          //crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text("Following",
                                style: farsiSimpleStyle(
                                    12, Colors.white, FontWeight.bold)),
                            Text("For you",
                                style: farsiSimpleStyle(
                                    12, Colors.white, FontWeight.bold)),
                          ],
                        ),
                      ),

                      //Middle section
                      Expanded(
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Expanded(
                                  child: Container(
                                height: 80,
                                color: Colors.black26,
                                padding: EdgeInsets.only(left: 20),
                                child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        buildicon(
                                            'images/RECAMARA.svg',
                                            Text(
                                              "2",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        buildicon(
                                            'images/BANO.svg',
                                            Text(
                                              "2",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        buildicon(
                                            'images/MEDIOBANO.svg',
                                            Text(
                                              "2",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        buildicon(
                                            'images/ESTACIONAMIENTO.svg',
                                            Text(
                                              "2",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        buildicon(
                                            'images/TERRENO.svg',
                                            Text(
                                              "2",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        buildicon(
                                            'images/CONSTRUCCION.svg',
                                            Text(
                                              "1200 m2",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                        buildicon(
                                            'images/CITAS.svg',
                                            Text(
                                              "12 yr",
                                              textAlign: TextAlign.center,
                                              style: GoogleFonts.raleway(
                                                textStyle: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                            )),
                                      ],
                                    ),
                                  ],
                                ),
                              )),
                              //rigth section
                              Container(
                                  width: 100,
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          12),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      buildprofile(),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 50,
                                          ),
                                          SvgPicture.asset(
                                            'images/CORAZON LIKE.svg',
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          )
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/FOTOS.svg',
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/UBICACION.svg',
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/INFORMACION.svg',
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/DUDAS.svg',
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/CITAS.svg',
                                            width: 50,
                                            height: 50,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
                                      CircleAnimation(buildmusicalalbum()),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                    ],
                                  ))
                            ]),
                      ),
                    ])
                  ]);
                });
          }),
    );
  }
}

class VideoPlayerItem extends StatefulWidget {
  final String video;

  VideoPlayerItem(this.video);

  @override
  _VideoPlayerItemState createState() => _VideoPlayerItemState();
}

class _VideoPlayerItemState extends State<VideoPlayerItem> {
  VideoPlayerController _controller;
  String _videoUrl;
  Future<void> _initializeVideoPlayerFuture;

  @override
  initState() {
    super.initState();
    _loadVideo(_videoUrl);

    // _controller = VideoPlayerController.network(_videoUrl)
    // ..initialize().then((value) {
    // _controller.play();
    // });
  }

  void _loadVideo(String key) async {
    await Media.getURL(widget.video).then((String result) {
      _videoUrl = result;
    });

    _controller = VideoPlayerController.network(_videoUrl)
      ..initialize().then((_) {
        setState(() {});
      });
    _controller.setLooping(true);
    _controller.play();

    // _controller = VideoPlayerController.network(_videoUrl);

    // _controller.addListener(() {
    //  setState(() {});
    //}//);

    //await _controller.initialize();
    //await _controller.play();
    //controller.setLooping(true);
    // _controller.setVolume(1.0);

    // Use the controller to loop the video.
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  // @override
  Widget build(BuildContext context) {
    return (_controller == null || _controller.value.initialized == false)
        ? Center(child: CircularProgressIndicator())
        : Stack(fit: StackFit.expand, children: [
            AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller))
          ]);
  }
}
