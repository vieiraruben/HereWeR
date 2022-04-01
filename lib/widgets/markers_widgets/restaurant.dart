import 'package:bot_toast/bot_toast.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/marker.dart';
import 'package:mapview/utilities/here_we_r_icons_icons.dart';

import '../../constants/restaurant_carousel.dart';

class RestaurantWidget extends StatefulWidget {
  const RestaurantWidget({Key? key}) : super(key: key);

  @override
  State<RestaurantWidget> createState() => RestaurantWidgetState();
}

class RestaurantWidgetState extends State<RestaurantWidget> {
  bool isPhotos = true;
  bool isMenu = false;
  List<Map<String, String>> contents = [FoodImgList, DrinksImgList];
  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.8,
      widthFactor: 0.8,
      child: Card(
        color: Colors.amberAccent,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          side: const BorderSide(color: Colors.white54, width: 1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,

          children: [
            Container(
              color: Colors.amberAccent,
              alignment: Alignment.topCenter,
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                children: <Widget>[
                  ElevatedButton(
                      child: const Icon(HereWeRIcons.icons8_hamburger_64),
                      onPressed: () {
                        isPhotos = false;
                        isMenu = true;
                        setState(() {});
                      }),
                  ElevatedButton(
                      child: const Icon(Icons.photo_sharp),
                      onPressed: () {
                        isPhotos = true;
                        isMenu = false;
                        setState(() {});
                      }),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              child: isPhotos ? restaurantPhotos(contents) : restaurantMenu(), //fit: BoxFit.fill
            ),
          ],
        ),
      ),
    );
  }

  Widget restaurantPhotos(List<Map<String, String>> contents) {
    return Container(
      width: 350,
      alignment: Alignment.center,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: contents.length,
          itemBuilder: (BuildContext context, int index) {
            var content = contents[index];
            return carouselBuilder(content);
          }),
    );
  }

  Widget carouselBuilder(Map<String, String> content) {
    var paths = content.keys.toList();
    var descr = content.values.toList();
    final List<Widget> imageSliders = paths
        .map((item) => Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(
                    item,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      descr.elementAt(paths.indexOf(item)),
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();

    var _controller = CarouselController();

    return CarouselSlider(
      items: imageSliders,
      carouselController: _controller,
      options: CarouselOptions(
          autoPlay: true,
          enlargeCenterPage: true,
          aspectRatio: 1.5,
          onPageChanged: (index, reason) {}),
    );
  }
}

restaurantMenu() {
  return Image.asset("assets/images/food/menu.jpeg", );
}
