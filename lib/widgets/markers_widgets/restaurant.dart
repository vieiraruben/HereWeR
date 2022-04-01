
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
class RestaurantWidgetState extends State<RestaurantWidget>{
  bool isPhotos = true;
  bool isMenu = false;
  List<Map<String, String>> contents = [FoodImgList, DrinksImgList];
  @override

    Widget build(BuildContext context) {

      return FractionallySizedBox(
            heightFactor: 0.8,
            widthFactor: 0.8,
            child: Card(
              color: Colors.white,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              shape: RoundedRectangleBorder(
                side: const BorderSide(color: Colors.white54, width: 1),
                borderRadius: BorderRadius.circular(10),
              ),

              child : Padding(padding :
              const EdgeInsets.all(8.0),
                child:  Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children:  [
                    Align(
                      alignment: Alignment.topCenter,
                      child: ButtonBar(
                        mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                        children: <Widget>[
                          ElevatedButton(
                            child: const Icon(HereWeRIcons.icons8_hamburger_64),
                            onPressed: () {
                              isPhotos = false;
                              isMenu = true;
                              setState(() {
                              });
                            }
                          ),
                          ElevatedButton(
                            child: const Icon(Icons.photo_sharp),
                              onPressed: () {
                                isPhotos = true;
                                isMenu = false;
                                setState(() {
                                });
                              }
                          ),
                        ],
                      ),
                    ),

                    isPhotos? restaurantPhotos(contents) : restaurantMenu()
                  ],
                ),
              ),
            ),
          );

  }

  Widget restaurantPhotos(List<Map<String, String>> contents){
    print(contents.length);
    return SizedBox(
      height: 450,
      width: 300,

      child: ListView.builder(

          itemCount: contents.length,
          itemBuilder: (BuildContext context, int index){
            var content = contents[index];
            return carouselBuilder(content);
          }
          ),
    );

  }



  Widget carouselBuilder(Map<String, String> content) {
    var paths = content.keys.toList();
    var descr = content.values.toList();
    final List<Widget> imageSliders = paths
        .map((item) => Container(
      margin: const EdgeInsets.all(1.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Image.asset(
            item,
            fit: BoxFit.contain,
          ),
          Padding(
            padding:
            const EdgeInsets.symmetric(horizontal:8),
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
          aspectRatio: 1.0,
          onPageChanged: (index, reason) {
          }),
    );

  }


}



restaurantMenu(){
  return Column();
}

