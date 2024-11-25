import 'dart:io';

import 'package:flutter/material.dart';
import 'home.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';

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
                        widget.date.imagesPath!.length,
                        (index) => Image.file(
                            File(widget.date.imagesPath![index]),
                            fit: BoxFit.cover))),
              ),
            ),
            Text(widget.date.name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'ArgentumSans',
                    fontSize: 32)),
            Text(widget.date.date,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'ArgentumSans',
                    fontSize: 32)),
            Text(widget.date.boardingGames!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'ArgentumSans',
                    fontSize: 32)),
            Text(widget.date.description!,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'ArgentumSans',
                    fontSize: 32)),
          ],
        ));
  }
}
