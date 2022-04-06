import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mapview/models/marker.dart';
import '../../constants/restaurant_carousel.dart';

class DemoContentView extends StatefulWidget {
  final MarkerModel marker;

  const DemoContentView({Key? key, required this.marker}) : super(key: key);

  @override
  State<DemoContentView> createState() => DemoContentViewState();
}

class DemoContentViewState extends State<DemoContentView> {
  static Container makeHeader(BuildContext context, String headerText) {
    return Container(
      height: 40,
      child: SizedBox.expand(
        child: Container(
            color: Theme.of(context).primaryColorLight,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Text(headerText,
                  style: TextStyle(fontWeight: FontWeight.bold, color: Theme.of(context).textTheme.bodyMedium?.color ?? Colors.white)),
            )),
      ),
    );
  }

  static saladMenu() {
    return Padding(padding: EdgeInsets.symmetric(vertical: 20),
      child: Column(children: const [
      Text("Salads:"),
      Text("Chicken Caesar - £12"),
      Text("Shrimp Caesar - £15"),
      Text("Greek - £12"),
      SizedBox(
        height: 10,
      ),
      Text("Sandwiches:"),
      Text("Tuna roll - £9"),
      Text("French Dip - £12")
    ]));
  }

  @override
  Widget build(BuildContext context) {
    if (widget.marker.type == "restaurant") {
      return Column(children: [
        makeHeader(context, "MENU"),
        saladMenu(),
        makeHeader(context, "PHOTOS"),
        Container(
            child: CarouselSlider(
          options: CarouselOptions(),
          items: foodImgList
              .map((item) => Container(
                    child: Center(
                        child: 
                            Image.asset(
                              item,
                              fit: BoxFit.cover, width: 300)),
                  ))
              .toList(),
        )),
      ]);
    } else if (widget.marker.type == "stage") {
      return Column(children: [
        makeHeader(context, "RIGHT NOW"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomRight),
                      ),
                      child: Image.asset(
                        'assets/images/sample/malesinger.jpg',
                        width: 500,
                        height: 150,
                        fit: BoxFit.cover,
                      ))),
              const Positioned(
                  bottom: 5,
                  left: 5,
                  child: Text("Sebastian North",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
        makeHeader(context, "COMING UP"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomRight),
                      ),
                      child: Image.asset(
                        'assets/images/sample/rollers.jpg',
                        width: 500,
                        height: 150,
                        fit: BoxFit.cover,
                      ))),
              const Positioned(
                  bottom: 5,
                  left: 5,
                  child: Text("The Rollers",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
        
      ]);
    } else if (widget.marker.type == "dj") {
      return Column(children: [
        makeHeader(context, "RIGHT NOW"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomRight),
                      ),
                      child: Image.asset(
                        'assets/images/sample/dj.jpg',
                        width: 500,
                        height: 150,
                        fit: BoxFit.cover,
                      ))),
              const Positioned(
                  bottom: 5,
                  left: 5,
                  child: Text("DJ Smiley",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
        makeHeader(context, "COMING UP"),
        Padding(
          padding: const EdgeInsets.all(20),
          child: Stack(
            children: [
              ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Container(
                      foregroundDecoration: const BoxDecoration(
                        gradient: LinearGradient(
                            colors: [Colors.black, Colors.transparent],
                            begin: Alignment.bottomRight),
                      ),
                      child: Image.asset(
                        'assets/images/sample/singer2.jpg',
                        width: 500,
                        height: 150,
                        fit: BoxFit.cover,
                      ))),
              const Positioned(
                  bottom: 5,
                  left: 5,
                  child: Text("Roxanne",
                      textScaleFactor: 1.2,
                      style: TextStyle(
                        color: Colors.white,
                      ))),
            ],
          ),
        ),
        
      ]);
    }
    else
      return SizedBox();
  }
}