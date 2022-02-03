import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import 'dart:async';

import 'package:safesale/home.dart';

class FirstSplashScreen extends StatefulWidget {
  final bool amplifyConfigured;
  const FirstSplashScreen(this.amplifyConfigured, {Key key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => StartState();
}

class StartState extends State<FirstSplashScreen> {
  String url;

  VideoPlayerController _controller;
  @override
  Widget build(BuildContext context) {
    return initScreen(context);
  }

  @override
  void initState() {
    super.initState();
    url = 'https://didsugvpn60.cloudfront.net/public/Tutorial.mp4';
    startTimer();

    _controller = VideoPlayerController.network(url)
      ..initialize().then((_) {
        _controller.play();
        // Ensure the first frame is shown after the video is initialized, even before the play button has been pressed.
        setState(() {});
      });
  }

  startTimer() async {
    var duration = Duration(seconds: 60);
    return new Timer(duration, route);
  }

  route() {
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomePage(widget.amplifyConfigured)));
  }

  initScreen(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _controller.value.isInitialized
            ? AspectRatio(
                aspectRatio: _controller.value.aspectRatio,
                child: VideoPlayer(_controller),
              )
            : Container(),
      ),
    );
  }
}
