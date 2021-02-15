import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:orientation/orientation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:screen/screen.dart';
import 'package:video_player/video_player.dart';
import 'package:wakelock/wakelock.dart';
import 'package:http/http.dart' as http;
import 'package:yoyo_player/src/utils/utils.dart';
import 'package:yoyo_player/src/widget/widget_bottombar.dart';
import 'package:safesale/models/audio.dart';
import 'package:safesale/models/m3u8.dart';
import 'package:safesale/models/m3u8s.dart';
import 'package:safesale/responses/regex_response.dart';

typedef VideoCallback<T> = void Function(T t);

class SafeSalePlayer extends StatefulWidget {
  final String url;

  final double aspectRatio;

  final VideoCallback<bool> onfullscreen;

  final VideoCallback<String> onpeningvideo;

  SafeSalePlayer({
    Key key,
    @required this.url,
    @required this.aspectRatio,
    this.onfullscreen,
    this.onpeningvideo,
  }) : super(key: key);

  @override
  _SafeSalePlayerState createState() => _SafeSalePlayerState();
}

class _SafeSalePlayerState extends State<SafeSalePlayer>
    with SingleTickerProviderStateMixin {
  String playtype;

  VideoPlayerController controller;

  bool hasInitError = false;

  String videoDuration;

  String videoSeek;

  Duration duration;

  double videoSeekSecond;

  double videoDurationSecond;

  List<M3U8pass> safesale = List();

  List<AUDIO> audioList = List();

  String m3u8Content;

  bool m3u8show = false;

  bool fullscreen = false;

  bool offline;

  String m3u8quality = "Auto";

  Timer showTime;

  Size get screenSize => MediaQuery.of(context).size;

  @override
  void initState() {
    urlcheck(widget.url);
    super.initState();
    var widgetsBinding = WidgetsBinding.instance;

    widgetsBinding.addPostFrameCallback((callback) {
      widgetsBinding.addPersistentFrameCallback((callback) {
        if (context == null) return;
        var orientation = MediaQuery.of(context).orientation;
        bool _fullscreen;
        if (orientation == Orientation.landscape) {
          //Horizontal screen
          _fullscreen = true;
          SystemChrome.setEnabledSystemUIOverlays([]);
        } else if (orientation == Orientation.portrait) {
          _fullscreen = true;
          SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
        }
        if (_fullscreen != fullscreen) {
          setState(() {
            fullscreen = !fullscreen;
            _navigateLocally(context);
            if (widget.onfullscreen != null) {
              widget.onfullscreen(fullscreen);
            }
          });
        }
        //
        widgetsBinding.scheduleFrame();
      });
    });
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    Screen.keepOn(true);
  }

  @override
  void dispose() {
    m3u8clean();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final videoChildrens = <Widget>[
      GestureDetector(
        onTap: () {
          togglePlay();
        },
        onDoubleTap: () {
          togglePlay();
        },
        child: ClipRect(
          child: Container(
            width: double.infinity,
            height: double.infinity,
            color: Colors.black,
            child: Center(
                child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: AspectRatio(
                aspectRatio: controller.value.aspectRatio,
                child: VideoPlayer(controller),
              ),
            )),
          ),
        ),
      ),
    ];
    videoChildrens.addAll(videoBuiltInChildrens());
    return AspectRatio(
        aspectRatio: 16 / 9,
        child: controller.value.initialized
            ? Stack(children: videoChildrens)
            : Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Center(
                        child: Container(
                      width: 70,
                      height: 70,
                      child: Image.asset(
                        "images/loading.gif",
                      ),
                    ))
                  ],
                ),
              ));
  }

  /// Vieo Player ActionBar

  Widget m3u8list() {
    return m3u8show == true
        ? Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 5),
              child: SingleChildScrollView(
                child: Column(
                  children: safesale
                      .map((e) => InkWell(
                            onTap: () {
                              m3u8quality = e.dataquality;
                              m3u8show = false;
                              onselectquality(e);
                              print(
                                  "--- quality select ---\nquality : ${e.dataquality}\nlink : ${e.dataurl}");
                            },
                            child: Container(
                                width: 90,
                                color: Colors.grey,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "${e.dataquality}",
                                    style: const TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )),
                          ))
                      .toList(),
                ),
              ),
            ),
          )
        : Container();
  }

  List<Widget> videoBuiltInChildrens() {
    return [
      m3u8list(),
    ];
  }

  void urlcheck(String url) {
    final netRegx = new RegExp(r'^(http|https):\/\/([\w.]+\/?)\S*');
    final isNetwork = netRegx.hasMatch(url);
    final a = Uri.parse(url);

    print("parse url data end : ${a.pathSegments.last}");
    if (isNetwork) {
      setState(() {
        offline = false;
      });
      if (a.pathSegments.last.endsWith("mp4")) {
        if (widget.onpeningvideo == null) {
          setState(() {
            playtype = "MP4";
          });
          print("urlend : mp4 $playtype");
          // widget.onpeningvideo("MP4");
        }
        print("urlend : mp4");
        videoControllSetup(url);
      } else if (a.pathSegments.last.endsWith("m3u8")) {
        if (widget.onpeningvideo == null) {
          setState(() {
            playtype = "HLS";
          });
          // widget.onpeningvideo("M3U8");
        }
        print("urlend : m3u8");
        videoControllSetup(url);
        getm3u8(url);
      } else {
        print("urlend : null");
        videoControllSetup(url);
        getm3u8(url);
      }
      print("--- Current Video Status ---\noffline : $offline");
    } else {
      setState(() {
        offline = true;
        print(
            "--- Current Video Status ---\noffline : $offline \n --- :3 done url check ---");
      });
      videoControllSetup(url);
    }
  }

// M3U8 Data Setup
  void getm3u8(String video) {
    if (safesale.length > 0) {
      print("${safesale.length} : data start clean");
      m3u8clean();
    }
    print("---- m3u8 fesh start ----\n$video\n--- please wait –––");
    m3u8video(video);
  }

  Future<M3U8s> m3u8video(String video) async {
    safesale.add(M3U8pass(dataquality: "Auto", dataurl: video));
    RegExp regExpAudio = new RegExp(
      Rexexresponse.regexMEDIA,
      caseSensitive: false,
      multiLine: true,
    );
    RegExp regExp = new RegExp(
      r"#EXT-X-STREAM-INF:(?:.*,RESOLUTION=(\d+x\d+))?,?(.*)\r?\n(.*)",
      caseSensitive: false,
      multiLine: true,
    );
    setState(
      () {
        if (m3u8Content != null) {
          print("--- HLS Old Data ----\n$m3u8Content");
          m3u8Content = null;
        }
      },
    );
    if (m3u8Content == null && video != null) {
      http.Response response = await http.get(video);
      if (response.statusCode == 200) {
        m3u8Content = utf8.decode(response.bodyBytes);
      }
    }
    List<RegExpMatch> matches = regExp.allMatches(m3u8Content).toList();
    List<RegExpMatch> audioMatches =
        regExpAudio.allMatches(m3u8Content).toList();
    print(
        "--- HLS Data ----\n$m3u8Content \ntotal length: ${safesale.length} \nfinish");

    matches.forEach(
      (RegExpMatch regExpMatch) async {
        String quality = (regExpMatch.group(1)).toString();
        String sourceurl = (regExpMatch.group(3)).toString();
        final netRegx = new RegExp(r'^(http|https):\/\/([\w.]+\/?)\S*');
        final netRegx2 = new RegExp(r'(.*)\r?\/');
        final isNetwork = netRegx.hasMatch(sourceurl);
        final match = netRegx2.firstMatch(video);
        String url;
        if (isNetwork) {
          url = sourceurl;
        } else {
          print(match);
          final dataurl = match.group(0);
          url = "$dataurl$sourceurl";
          print("--- hls chlid url intergration ---\nchild url :$url");
        }
        audioMatches.forEach(
          (RegExpMatch regExpMatch2) async {
            String audiourl = (regExpMatch2.group(1)).toString();
            final isNetwork = netRegx.hasMatch(audiourl);
            final match = netRegx2.firstMatch(video);
            String auurl = audiourl;
            if (isNetwork) {
              auurl = audiourl;
            } else {
              print(match);
              final audataurl = match.group(0);
              auurl = "$audataurl$audiourl";
              print("url network audio  $url $audiourl");
            }
            audioList.add(AUDIO(url: auurl));
            print(audiourl);
          },
        );
        String audio = "";
        print("-- audio ---\naudio list length :${audio.length}");
        if (audioList.length != 0) {
          audio =
              """#EXT-X-MEDIA:TYPE=AUDIO,GROUP-ID="audio-medium",NAME="audio",AUTOSELECT=YES,DEFAULT=YES,CHANNELS="2",URI="${audioList.last.url}"\n""";
        } else {
          audio = "";
        }
        try {
          final Directory directory = await getApplicationDocumentsDirectory();
          final File file = File('${directory.path}/yoyo$quality.m3u8');
          await file.writeAsString(
              """#EXTM3U\n#EXT-X-INDEPENDENT-SEGMENTS\n$audio#EXT-X-STREAM-INF:CLOSED-CAPTIONS=NONE,BANDWIDTH=1469712,RESOLUTION=$quality,FRAME-RATE=30.000\n$url""");
        } catch (e) {
          print("Couldn't write file");
        }
        safesale.add(M3U8pass(dataquality: quality, dataurl: url));
      },
    );
    M3U8s m3u8s = M3U8s(m3u8s: safesale);
    print(
        "--- m3u8 file write ---\n${safesale.map((e) => e.dataquality == e.dataurl).toList()}\nlength : ${safesale.length}\nSuccess");
    return m3u8s;
  }

// Video controller
  void videoControllSetup(String url) {
    videoInit(url);
    controller.addListener(listener);
    controller.play();
    controller.setLooping(true);
  }

// video Listener
  void listener() async {
    if (controller.value.initialized && controller.value.isPlaying) {
      if (!await Wakelock.isEnabled) {
        await Wakelock.enable();
      }
      setState(() {
        videoDuration = convertDurationToString(controller.value.duration);
        videoSeek = convertDurationToString(controller.value.position);
        videoSeekSecond = controller.value.position.inSeconds.toDouble();
        videoDurationSecond = controller.value.duration.inSeconds.toDouble();
      });
    } else {
      if (await Wakelock.isEnabled) {
        await Wakelock.disable();
        setState(() {});
      }
    }
  }

  void clearHideControlbarTimer() {
    showTime?.cancel();
  }

  void togglePlay() {
    if (controller.value.isPlaying) {
      controller.pause();
    } else {
      controller.play();
    }
    setState(() {});
  }

  void videoInit(String url) {
    if (offline == false) {
      print(
          "--- Player Status ---\nplay url : $url\noffline : $offline\n--- start playing –––");

      if (playtype == "MP4") {
        // Play MP4
        controller =
            VideoPlayerController.network(url, formatHint: VideoFormat.other)
              ..initialize();
      } else if (playtype == "MKV") {
        controller =
            VideoPlayerController.network(url, formatHint: VideoFormat.dash)
              ..initialize();
      } else if (playtype == "HLS") {
        controller =
            VideoPlayerController.network(url, formatHint: VideoFormat.hls)
              ..initialize()
                  .then((_) => setState(() => hasInitError = false))
                  .catchError((e) => setState(() => hasInitError = true));
      }
    } else {
      print(
          "--- Player Status ---\nplay url : $url\noffline : $offline\n--- start playing –––");
      controller = VideoPlayerController.file(File(url))
        ..initialize()
            .then((value) => setState(() => hasInitError = false))
            .catchError((e) => setState(() => hasInitError = true));
    }
  }

  String convertDurationToString(Duration duration) {
    var minutes = duration.inMinutes.toString();
    if (minutes.length == 1) {
      minutes = '0' + minutes;
    }
    var seconds = (duration.inSeconds % 60).toString();
    if (seconds.length == 1) {
      seconds = '0' + seconds;
    }
    return "$minutes:$seconds";
  }

  void _navigateLocally(context) async {
    if (!fullscreen) {
      if (ModalRoute.of(context).willHandlePopInternally) {
        Navigator.of(context).pop();
      }
      return;
    }
    ModalRoute.of(context).addLocalHistoryEntry(LocalHistoryEntry(onRemove: () {
      if (fullscreen) toggleFullScreen();
    }));
  }

  void onselectquality(M3U8pass data) async {
    controller.value.isPlaying ? controller.pause() : controller.pause();
    if (data.dataquality == "Auto") {
      videoControllSetup(data.dataurl);
    } else {
      try {
        String text;
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file =
            File('${directory.path}/yoyo${data.dataquality}.m3u8');
        print("read file success");
        text = await file.readAsString();
        print("data : $text  :: data");
        localm3u8play(file);
        // videoControllSetup(file);
      } catch (e) {
        print("Couldn't read file ${data.dataquality} e: $e");
      }
      print("data : ${data.dataquality}");
    }
  }

  void localm3u8play(File file) {
    controller = VideoPlayerController.file(
      file,
    )..initialize()
        .then((_) => setState(() => hasInitError = false))
        .catchError((e) => setState(() => hasInitError = true));
    controller.addListener(listener);
    controller.play();
  }

  void m3u8clean() async {
    print(safesale.length);
    for (int i = 2; i < safesale.length; i++) {
      try {
        final Directory directory = await getApplicationDocumentsDirectory();
        final File file =
            File('${directory.path}/${safesale[i].dataquality}.m3u8');
        file.delete();
        print("delete success $file");
      } catch (e) {
        print("Couldn't delete file $e");
      }
    }
    try {
      print("Audio m3u8 list clean");
      audioList.clear();
    } catch (e) {
      print("Audio list clean error $e");
    }
    audioList.clear();
    try {
      print("m3u8 data list clean");
      safesale.clear();
    } catch (e) {
      print("m3u8 video list clean error $e");
    }
  }

  void toggleFullScreen() {
    if (fullscreen) {
      OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    } else {
      OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
    }
  }
}