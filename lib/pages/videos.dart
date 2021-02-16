import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart' show Location, LocationData;

import 'package:safesale/models/media.dart';
import 'package:safesale/models/property.dart';
import 'package:safesale/services/video_mod.dart';

import 'package:safesale/variables.dart';
import 'package:safesale/videopages/searchview.dart';
import 'package:safesale/widgets/circle_animation.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safesale/services/search_service.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:yoyo_player/yoyo_player.dart';
//import 'package:location_permissions/location_permissions.dart';

class VideoPage extends StatefulWidget {
  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _searchService = SearchService();

  LocationData currentLocation;

  List<Property> result;

  //PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  initState() {
    super.initState();
    //  _listenForPermissionStatus();
    setInitialLocation();
  }

  // void _listenForPermissionStatus() {
  // final Future<PermissionStatus> statusFuture =
  //   LocationPermissions().checkPermissionStatus();

  //statusFuture.then((PermissionStatus status) {
  // setState(() {
  //  _permissionStatus = status;
  //});
  //});
  //}

  Future<void> setInitialLocation() async {
    Location location = new Location();
    // establece la ubicación inicial tirando del usuario
    // ubicación actual de getLocation () de la ubicación
    currentLocation = await location.getLocation();
    _searchService.fetchProperties(
        currentLocation.latitude, currentLocation.longitude);

    // destino codificado para este ejemplo
  }

  buildprofile() {
    return Container(
      width: 40,
      height: 40,
      child: Stack(
        children: [
          Positioned(
            left: (40 / 2) - (30 / 2),
            child: Container(
              width: 30,
              height: 30,
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
            left: (40 / 2),
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
          padding: EdgeInsets.all(8.0),
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
      backgroundColor: Colors.black,
      body: StreamBuilder<SearchState>(
          stream: _searchService.searchStateController.stream,
          builder: (context, snapshot) {
            if (!snapshot.hasData ||
                snapshot.data.searchFlowStatus == SearchFlowStatus.started) {
              return Container(
                  alignment: Alignment.center,
                  width: 70,
                  height: 70,
                  child: Container() //Image.asset(
                  // "images/loading.gif",
                  //),
                  );
            }
            result = _searchService.getProperties();
            return PageView.builder(
                itemCount: result.length,
                controller: PageController(initialPage: 0, viewportFraction: 1),
                scrollDirection: Axis.vertical,
                itemBuilder: (context, index) {
                  Property property = result[index];
                  return Stack(children: [
                    VideoPlayerItem(property.id)
                    //video
                    ,
                    Column(children: [
                      // top section
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        height: 140,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            //CircleAnimation(buildmusicalalbum()),

                            Flexible(
                                child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 50),
                                    child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 8.0),
                                              child: Text(
                                                property.nombre,
                                                style: GoogleFonts.raleway(
                                                  textStyle: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 24,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ))
                                        ])))
                            /* Text(
                              property.nombre,
                              overflow: TextOverflow.ellipsis,
                              softWrap: true,
                              textAlign: TextAlign.left,
                              style: GoogleFonts.raleway(
                                textStyle: TextStyle(
                                  color: Colors.white,
                                  fontSize: 27.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            )*/
                          ],
                        ),
                      ),
                      //Middle section
                      Expanded(
                        child: Row(
                            mainAxisSize: MainAxisSize.max,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              //rigth section
                              Container(
                                  width: MediaQuery.of(context).size.width - 10,
                                  margin: EdgeInsets.only(
                                      top: MediaQuery.of(context).size.height /
                                          25),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            Expanded(
                                              flex: 1,
                                              child: InkWell(
                                                onTap: () =>
                                                    showModalBottomSheet<void>(
                                                  isScrollControlled: true,
                                                  context: context,
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.vertical(
                                                              top: Radius
                                                                  .circular(
                                                                      10.0))),
                                                  builder: (context) =>
                                                      SearchPage("22"),
                                                ),
                                                child: SvgPicture.asset(
                                                  'images/filter.svg',
                                                  width: 30,
                                                  height: 30,
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                              height: 20,
                                            )
                                          ],
                                        ),
                                      ),
                                      buildprofile(),
                                      Column(
                                        children: [
                                          SizedBox(
                                            height: 60,
                                          ),
                                          SvgPicture.asset(
                                            'images/CORAZON LIKE.svg',
                                            width: 30,
                                            height: 30,
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
                                            width: 30,
                                            height: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/UBICACION.svg',
                                            width: 30,
                                            height: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/INFORMACION.svg',
                                            width: 30,
                                            height: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/DUDAS.svg',
                                            width: 30,
                                            height: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 20,
                                          ),
                                        ],
                                      ),
                                      Column(
                                        children: [
                                          SvgPicture.asset(
                                            'images/CITAS.svg',
                                            width: 30,
                                            height: 30,
                                            color: Colors.white,
                                          ),
                                          SizedBox(
                                            height: 10,
                                          ),
                                        ],
                                      ),
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
  Future<void> _initializeVideoPlayerFuture;

  @override
  initState() {
    super.initState();
    //_loadVideo(_videoUrl);

    // _controller = VideoPlayerController.network(_videoUrl)
    // ..initialize().then((value) {
    // _controller.play();
    // });
  }

  //void _loadVideo(String key) async {
  //await Media.getURL(widget.video).then((String result) {
  //_videoUrl = result;
  //});

  //_controller = VideoPlayerController.network(_videoUrl)
  //..initialize().then((_) {
  // setState(() {});
  // });
  //_controller.setLooping(true);
  //_controller.play();

  // _controller = VideoPlayerController.network(_videoUrl);

  // _controller.addListener(() {
  //  setState(() {});
  //}//);

  //await _controller.initialize();
  //await _controller.play();
  //controller.setLooping(true);
  // _controller.setVolume(1.0);

  // Use the controller to loop the video.
  // }

  bool fullscreen = false;
  // @override
  Widget build(BuildContext context) {
    return Stack(fit: StackFit.expand, children: [
      SafeSalePlayer(
        aspectRatio: 16 / 9,
        url: "https://didsugvpn60.cloudfront.net/public/" +
            widget.video +
            "/" +
            widget.video +
            ".m3u8",
        // "https://player.vimeo.com/external/440218055.m3u8?s=7ec886b4db9c3a52e0e7f5f917ba7287685ef67f&oauth2_token_id=1360367101",
        // "https://sfux-ext.sfux.info/hls/chapter/105/1588724110/1588724110.m3u8",
        onfullscreen: (t) {
          setState(() {
            fullscreen = t;
          });
        },
      )
    ]);
  }
}
