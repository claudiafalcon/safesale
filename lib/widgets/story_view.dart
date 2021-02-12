import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:safesale/models/property.dart';

import '../controller/story_controller.dart';

import 'package:google_fonts/google_fonts.dart';
import '../utils.dart';

//import 'story_video.dart';
import 'package:safesale/variables.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:safesale/widgets/circle_animation.dart';
import 'package:location/location.dart' show Location, LocationData;

buildprofile() {
  return Container(
    width: 60,
    height: 60,
    child: Stack(
      children: [
        SizedBox(
          height: 150,
        ),
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

class StoryItem {
  bool shown;

  /// The page content
  final Widget view;
  StoryItem(this.view, {this.shown = false});

  factory StoryItem.pageVideo(
    String url, {
    @required Property property,
    @required StoryController controller,
    Key key,
    BoxFit imageFit = BoxFit.fitWidth,
    bool shown = false,
    Map<String, dynamic> requestHeaders,
  }) {
    return StoryItem(
        Container(
          key: key,
          color: Colors.black,
          child: Stack(
            children: <Widget>[
              //     StoryVideo.url(
              //     url,
              //   controller: controller,
              // requestHeaders: requestHeaders,
              //),
              Column(children: [
                // top section

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
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  buildicon(
                                      'images/RECAMARA.svg',
                                      Text(
                                        property.recamaras.toString(),
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
                                        property.baths.toString(),
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
                                        property.wc.toString(),
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
                                        property.estacionamientos.toString(),
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
                                        property.terrenoM2.toString() + "m2",
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
                                        property.construccionM2.toString() +
                                            "m2",
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
                                        property.edad.toString() + "yr",
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
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                buildprofile(),
                                Column(
                                  children: [
                                    SizedBox(
                                      height: 60,
                                    ),
                                    SvgPicture.asset(
                                      'images/CORAZON LIKE.svg',
                                      width: 40,
                                      height: 40,
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
                                      width: 40,
                                      height: 40,
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
                                      width: 40,
                                      height: 40,
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
                                      width: 40,
                                      height: 40,
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
                                      width: 40,
                                      height: 40,
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
                                      width: 40,
                                      height: 40,
                                      color: Colors.white,
                                    ),
                                    SizedBox(
                                      height: 20,
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
              ]),
              SafeArea(
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.only(bottom: 24),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                  ),
                ),
              )
            ],
          ),
        ),
        shown: shown);
  }
}

/// Widget to display stories just like Whatsapp and Instagram. Can also be used
/// inline/inside [ListView] or [Column] just like Google News app. Comes with
/// gestures to pause, forward and go to previous page.
class StoryView extends StatefulWidget {
  /// The pages to displayed.
  final List<StoryItem> storyItems;

  /// Callback for when a full cycle of story is shown. This will be called
  /// each time the full story completes when [repeat] is set to `true`.
  final VoidCallback onComplete;

  /// Callback for when a vertical swipe gesture is detected. If you do not
  /// want to listen to such event, do not provide it. For instance,
  /// for inline stories inside ListViews, it is preferrable to not to
  /// provide this callback so as to enable scroll events on the list view.
  final Function(Direction) onVerticalSwipeComplete;

  /// Callback for when a story is currently being shown.
  final ValueChanged<StoryItem> onStoryShow;

  /// Should the story be repeated forever?
  final bool repeat;

  /// If you would like to display the story as full-page, then set this to
  /// `false`. But in case you would display this as part of a page (eg. in
  /// a [ListView] or [Column]) then set this to `true`.
  final bool inline;

  // Controls the playback of the stories
  final StoryController controller;

  StoryView({
    @required this.storyItems,
    @required this.controller,
    this.onComplete,
    this.onStoryShow,
    this.repeat = false,
    this.inline = false,
    this.onVerticalSwipeComplete,
  })  : assert(storyItems != null && storyItems.length > 0,
            "[storyItems] should not be null or empty"),
        assert(
          repeat != null,
          "[repeat] cannot be null",
        ),
        assert(inline != null, "[inline] cannot be null");

  @override
  State<StatefulWidget> createState() {
    return StoryViewState();
  }
}

class StoryViewState extends State<StoryView> with TickerProviderStateMixin {
  Timer _nextDebouncer;

  StreamSubscription<PlaybackState> _playbackSubscription;

  VerticalDragInfo verticalDragInfo;

  StoryItem get _currentStory =>
      widget.storyItems.firstWhere((it) => !it.shown, orElse: () => null);

  Widget get _currentView => widget.storyItems
      .firstWhere((it) => !it.shown, orElse: () => widget.storyItems.last)
      .view;

  @override
  void initState() {
    super.initState();

    // All pages after the first unshown page should have their shown value as
    // false

    final firstPage = widget.storyItems.firstWhere((it) {
      return !it.shown;
    }, orElse: () {
      widget.storyItems.forEach((it2) {
        it2.shown = false;
      });

      return null;
    });

    if (firstPage != null) {
      final lastShownPos = widget.storyItems.indexOf(firstPage);
      widget.storyItems.sublist(lastShownPos).forEach((it) {
        it.shown = false;
      });
    }

    this._playbackSubscription =
        widget.controller.playbackNotifier.listen((playbackStatus) {
      switch (playbackStatus) {
        case PlaybackState.play:
          _removeNextHold();
          break;

        case PlaybackState.pause:
          _holdNext(); // then pause animation

          break;

        case PlaybackState.next:
          _removeNextHold();
          _goForward();
          break;

        case PlaybackState.previous:
          _removeNextHold();
          _goBack();
          break;
      }
    });

    _play();
  }

  @override
  void dispose() {
    _clearDebouncer();

    _playbackSubscription?.cancel();

    super.dispose();
  }

  @override
  void setState(fn) {
    if (mounted) {
      super.setState(fn);
    }
  }

  void _play() {
    // get the next playing page
    final storyItem = widget.storyItems.firstWhere((it) {
      return !it.shown;
    });

    if (widget.onStoryShow != null) {
      widget.onStoryShow(storyItem);
    }
    widget.controller.play();
  }

  void _beginPlay() {
    setState(() {});
    _play();
  }

  void _onComplete() {
    if (widget.onComplete != null) {
      widget.controller.pause();
      widget.onComplete();
    }

    if (widget.repeat) {
      widget.storyItems.forEach((it) {
        it.shown = false;
      });

      _beginPlay();
    }
  }

  void _goBack() {
    if (this._currentStory == null) {
      widget.storyItems.last.shown = false;
    }

    if (this._currentStory == widget.storyItems.first) {
      _beginPlay();
    } else {
      this._currentStory.shown = false;
      int lastPos = widget.storyItems.indexOf(this._currentStory);
      final previous = widget.storyItems[lastPos - 1];

      previous.shown = false;

      _beginPlay();
    }
  }

  void _goForward() {
    if (this._currentStory != widget.storyItems.last) {
      // get last showing
      final _last = this._currentStory;

      if (_last != null) {
        _last.shown = true;
        if (_last != widget.storyItems.last) {
          _beginPlay();
        }
      }
    }
  }

  void _clearDebouncer() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _removeNextHold() {
    _nextDebouncer?.cancel();
    _nextDebouncer = null;
  }

  void _holdNext() {
    _nextDebouncer?.cancel();
    _nextDebouncer = Timer(Duration(milliseconds: 500), () {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Stack(
        children: <Widget>[
          _currentView,
          GestureDetector(
            onTapDown: (details) {
              widget.controller.pause();
            },
            onTapCancel: () {
              widget.controller.play();
            },
            onTapUp: (details) {
              // if debounce timed out (not active) then continue anim
              widget.controller.play();
            },
            onVerticalDragStart: (details) {
              widget.controller.pause();
            },
            onVerticalDragCancel: () {
              widget.controller.play();
            },
            onVerticalDragUpdate: widget.onVerticalSwipeComplete == null
                ? null
                : (details) {
                    widget.controller.pause();
                    if (verticalDragInfo == null) {
                      verticalDragInfo = VerticalDragInfo();
                    }

                    verticalDragInfo.update(details.primaryDelta);
                  },
            onVerticalDragEnd: widget.onVerticalSwipeComplete == null
                ? null
                : (details) {
                    if (verticalDragInfo.direction == Direction.up)
                      widget.controller.next();
                    else
                      widget.controller.previous();
                  },
          ),
        ],
      ),
    );
  }
}
