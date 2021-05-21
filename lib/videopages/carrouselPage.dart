import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:safesale/models/property.dart';

import 'package:carousel_slider/carousel_slider.dart';

import 'package:safesale/painters/softpaint.dart';
import 'package:safesale/variables.dart';

class CarrouselPage extends StatefulWidget {
  final List keys;
  final int index;
  CarrouselPage(this.keys, this.index);

  @override
  _CarrouselPageState createState() => _CarrouselPageState();
}

class _CarrouselPageState extends State<CarrouselPage> {
  List<Widget> imageSliders;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: Container(
        height: MediaQuery.of(context).size.height,
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
                  10),
              child: Container(
                width: double.infinity,
                //color: Color.fromRGBO(67, 73, 75, 0.83),
                height: MediaQuery.of(context).size.height,
                child: InkWell(
                  onTap: () => Navigator.of(context).pop(),
                  child: Stack(
                    children: [
                      Stack(
                        children: [
                          Positioned(
                            right: MediaQuery.of(context).size.height *
                                factorRighBarVideoIconSize,
                            top: MediaQuery.of(context).size.height *
                                factorRighBarVideoIconSize *
                                2,
                            child: SvgPicture.asset(
                              'images/CLOSE.svg',
                              width: MediaQuery.of(context).size.height *
                                  factorRighBarVideoIconSize,
                              height: MediaQuery.of(context).size.height *
                                  factorRighBarVideoIconSize,
                            ),
                          ),
                        ],
                      ),
                      CarouselSlider(
                        options: CarouselOptions(
                            height: MediaQuery.of(context).size.height,
                            initialPage: widget.index,
                            autoPlay: true,
                            enlargeCenterPage: false,
                            viewportFraction: 0.9),
                        items: widget.keys
                            .map((item) => Container(
                                  child: Center(
                                      child: Image.network(
                                    cloudfronturl + item,
                                    //fit: BoxFit.cover,
                                    //  height:
                                    //    MediaQuery.of(context).size.height * 0.75,
                                  )),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),

                /*     ClipRRect(
                  child: Container(
                      width: double.infinity,
                      height: MediaQuery.of(context).size.height / 10 * 9 / 15 * 2,
                      color: Color.fromRGBO(191, 191, 191, 0.78),
                      child: Text("Hi modal sheet")),*/
              ),
            )),
      ),
    );
  }
}
