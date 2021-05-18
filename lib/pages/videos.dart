import 'dart:collection';
import 'dart:ui';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:location/location.dart' show Location, LocationData;
import 'package:safesale/auth_credentials.dart';

import 'package:safesale/models/property.dart';
import 'package:safesale/services/auth_service.dart';
import 'package:safesale/services/video_mod.dart';
import 'package:safesale/variables.dart';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:safesale/services/search_service.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:safesale/widgets/empyList.dart';
import 'package:safesale/widgets/loading.dart';
import 'package:safesale/widgets/rigthpropertybar.dart';

//import 'package:location_permissions/location_permissions.dart';

class VideoPage extends StatefulWidget {
  final AuthFlowStatus authstatus;
  final SignedCredentials credentials;

  final bool Function() needsreload;
  final void Function() turnoffreloading;

  const VideoPage(
      {Key key,
      this.authstatus,
      this.credentials,
      this.needsreload,
      this.turnoffreloading})
      : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final _searchService = SearchService();

  Stream<SearchState> searchStateController;

  LocationData currentLocation;

  Map<int, List<Property>> _pages = new Map<int, List<Property>>();
  int _element = 0;

  List<Property> _result;

  int _currentProperty = 0;

  //PermissionStatus _permissionStatus = PermissionStatus.unknown;

  @override
  initState() {
    super.initState();
    searchStateController = _searchService.searchStateController.stream;
    // setInitialLocation();
    //  _listenForPermissionStatus();

    // setInitialLocation();
  }

  @override
  void dispose() {
    super.dispose();
    // _searchService.getSearchStreamController().close();
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
    _pages = null;
    _pages = new Map<int, List<Property>>();
    Location location = new Location();
    _element = 0;
    _currentProperty = 0;
    // establece la ubicación inicial tirando del usuario
    // ubicación actual de getLocation () de la ubicación
    await _searchService.checkState();
    currentLocation = await location.getLocation();
    if (!_searchService.isAExternalSearch())
      _searchService.fetchProperties(
          currentLocation.latitude, currentLocation.longitude, null);
    //else
    //_searchService.turnOffExternalSearch();
    // destino codificado para este ejemplo
  }

  buildprofile(int total) {
    return Container(
      width: 60,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: (60 / 2) - (50 / 2),
            child: Container(
              width: 60,
              height: 60,
              padding: EdgeInsets.all(1),
              decoration: BoxDecoration(
                color: Color.fromARGB(20, 255, 255, 255),
                borderRadius: BorderRadius.circular(25),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: SvgPicture.asset(
                  'images/filter.svg',
                  color: Colors.white,
                ),
              ),
            ),
          ),
          Positioned(
            left: (60 / 2) + 10,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.pink,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Text(total.toString(),
                  style: GoogleFonts.raleway(
                    textStyle: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  textAlign: TextAlign.center),
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

  _onNextPage(int page) async {
    print("Current Page: " + page.toString());
    if (page < _searchService.getTotal()) {
      _element = ((page) ~/ resultBlockSize);
      if (_searchService.criterio == null)
        _searchService.fetchProperties(
            null, null, _searchService.getnextToken(_element - 1));
      else
        _searchService.searchProperties(
            null, _searchService.getnextToken(_element - 1));
    }
  }

  _onPreviousPage(int page) async {
    int _index = (page - resultBlockSize) + (resultBlockSize * (_element));

    if (page < resultBlockSize) _element = _element - 1;
    print("Current Page: " + page.toString());
    if (page - resultBlockSize == _result.length &&
        _index < _searchService.getTotal()) {
      _element = ((_index) ~/ resultBlockSize);
      if (_searchService.criterio == null && _index > 0)
        _searchService.fetchProperties(
            null, null, _searchService.getnextToken(_element - 1));
    }

    int previousPage = page;
    if (page != 0)
      previousPage--;
    else
      previousPage = 2;
    print("Previous page: $previousPage");
  }

  bool _openWindow = false;

  bool _transition = false;

  void _thereisanopenwindow(bool isthere) {
    setState(() {
      _transition = true;
      _openWindow = isthere;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.needsreload() && !_transition) {
      // widget.turnoffreloading();
      setInitialLocation();
    }
    if (_transition && !_openWindow) _transition = false;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.white,
      body: new StreamBuilder<SearchState>(
          stream: searchStateController,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Stack(
                children: [
                  EmptyPage(),
                  RightPropertyBar(
                      total: 0, headText: "", status: widget.authstatus)
                ],
              );
            } else {
              switch (snapshot.connectionState) {
                case ConnectionState.none:
                  return LoadingPage();
                  break;
                case ConnectionState.waiting:
                  {
                    if (_searchService.getProperties() != null)
                      _searchService.checkState();

                    return LoadingPage();
                  }
                case ConnectionState.active:
                  if (snapshot.data.searchFlowStatus ==
                      SearchFlowStatus.started) return LoadingPage();
                  if (snapshot.data.searchFlowStatus ==
                      SearchFlowStatus.empty) {
                    _searchService.turnOffExternalSearch();
                    return Stack(
                      children: [
                        EmptyPage(),
                        RightPropertyBar(
                            total: 0, headText: "", status: widget.authstatus)
                      ],
                    );
                  } else {
                    if (_pages.containsKey(_element)) _pages.remove(_element);
                    final initialPage = 0;
                    final itemCount = _searchService.getTotal();
                    return PageView.builder(
                        itemCount: initialPage + _searchService.getTotal(),
                        controller: PageController(
                            initialPage:
                                initialPage + _element * resultBlockSize,
                            viewportFraction: 1),
                        scrollDirection: Axis.vertical,
                        itemBuilder: (context, page) {
                          final index = (page - initialPage);

                          print("[info] This is the current page $index");
                          if ((index) ~/ resultBlockSize < _element) {
                            _element = _element - 1;
                            _result = _pages[(resultBlockSize * _element)];
                          }

                          if ((index == 0 || index % resultBlockSize == 0) &&
                              index < _searchService.getTotal()) {
                            int _ele = ((index) ~/ resultBlockSize);
                            if (!_pages.containsKey(resultBlockSize * _ele)) {
                              if (_ele == _element)
                                _pages[resultBlockSize * _element] =
                                    _searchService.getProperties();
                              else
                                _onNextPage(index);
                            }
                            _result = _pages[resultBlockSize * _ele];
                          }

                          _searchService.turnOffExternalSearch();
                          bool fullscreen = false;
                          if (index < 0) {
                            _element = _element - 1;
                            _result = _pages[(resultBlockSize * _element)];
                          }

                          if (_result != null) {
                            int _idx = index % resultBlockSize;
                            Property property = _result[_idx];
                            return Stack(fit: StackFit.expand, children: [
                              SafeSalePlayer(
                                  onfullscreen: (t) {
                                    setState(() {
                                      fullscreen = t;
                                    });
                                  },
                                  total: _searchService.getTotal(),
                                  property: property,
                                  credentials: widget.credentials,
                                  status: widget.authstatus,
                                  thereisanopenwindow: _thereisanopenwindow,
                                  windowOpen: _openWindow),
                            ]);
                          } else {
                            return Stack(
                              children: [
                                EmptyPage(),
                                RightPropertyBar(
                                    total: 0,
                                    headText: "",
                                    status: widget.authstatus)
                              ],
                            );
                          }
                        });
                  }
                  break;
                case ConnectionState.done:
                  return Stack(
                    children: [
                      EmptyPage(),
                      RightPropertyBar(
                          total: 0, headText: "", status: widget.authstatus)
                    ],
                  );
              }
            }
          }),
    );
  }
}
