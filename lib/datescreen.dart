import 'dart:io';

import 'package:flutter/material.dart';
import 'home.dart';
// ignore: unused_import
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

// ignore: must_be_immutable
class Datescreen extends StatefulWidget {
  Date date;
  Datescreen({super.key, required this.date});

  @override
  State<Datescreen> createState() => _DatescreenState();
}

class _DatescreenState extends State<Datescreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF9A3135),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 400),
              child: Center(
                child: CarouselView(
                  itemExtent: MediaQuery.sizeOf(context).width - 8,
                  shrinkExtent: 200,
                  padding: EdgeInsets.all(12.5),
                  children: List.generate(
                    widget.date.imagesPath?.length ?? 0,
                    (index) => widget.date.imagesPath!.first != "notExists"
                        ? Image.file(File(widget.date.imagesPath![index]),
                            fit: BoxFit.cover)
                        : Image.asset("assets/images/image_placeholder.png"),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 48.0),
              child: Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, right: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(8.0),
                        bottomRight: Radius.circular(8.0)),
                    color: Color(0xFFFC4850)),
                child: Center(
                  child: Text(widget.date.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontFamily: 'ArgentumSans',
                          fontSize: 28)),
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(top: 8.0, left: 128.0, bottom: 8.0),
              child: Container(
                padding: EdgeInsets.only(top: 5.0, bottom: 5.0, left: 5.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(8.0),
                        bottomLeft: Radius.circular(8.0)),
                    color: Color(0xFFFC4850)),
                child: Center(
                  child: Text(widget.date.date,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w100,
                          fontFamily: 'ArgentumSans',
                          fontSize: 20)),
                ),
              ),
            ),
            Spacer(),
            ConstrainedBox(
              constraints: BoxConstraints(
                  minHeight: MediaQuery.sizeOf(context).height * 0.4),
              child: Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(16.0),
                        topRight: Radius.circular(16.0)),
                    color: Color(0xFFFC4850)),
                child: Column(
                  children: [
                    Text("Další informace:",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w100,
                            fontFamily: 'ArgentumSans',
                            fontSize: 24)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Deskovky:   ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'ArgentumSans',
                                fontSize: 18)),
                        Text(widget.date.boardingGames!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'ArgentumSans',
                                fontSize: 16)),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Popisek:   ",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w100,
                                fontFamily: 'ArgentumSans',
                                fontSize: 18)),
                        Text(widget.date.description!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'ArgentumSans',
                                fontSize: 16)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ));
  }
}
