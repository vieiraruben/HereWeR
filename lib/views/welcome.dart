import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

import '../firestoreData/markers_data.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  late final TextEditingController _email;
  late final TextEditingController _password;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'assets/images/map.png',
      'assets/images/chat.png',
      'assets/images/micro.png',
      'assets/images/mega.png',
    ];
    final List<String> detailsList = [
      'Easily find your way through the crowd',
      'Connect with your fellow festival goers',
      'Check out showtimes for your most anticipated concerts',
      "Don't miss out on news throughout the event"
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              child: Container(
                margin: const EdgeInsets.all(5.0),
                child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(5.0)),
                    child: Stack(
                      children: <Widget>[
                        Image.asset(item, fit: BoxFit.contain, width: 300.0),
                        Positioned(
                          bottom: 50.0,
                          left: 0.0,
                          right: 0.0,
                          child: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Text(
                              detailsList[imgList.indexOf(item)], textAlign: TextAlign.center,
                              style: const TextStyle(
                                  // color: Colors.white,
                                   fontSize: 17.0,
                                  fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    ),
              ),
            ))
        .toList();

    return Scaffold(
      body: Center(
          child: Column(
        children: [const SizedBox(height: 140,),
          CarouselSlider(
            items: imageSliders,
            carouselController: _controller,
            options: CarouselOptions(
                autoPlay: true,
                enlargeCenterPage: true,
                aspectRatio: 1.0,
                onPageChanged: (index, reason) {
                  setState(() {
                    _current = index;
                  });
                }),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ), const Spacer(),
          ElevatedButton(onPressed: () {
            Navigator.of(context).pushNamed(
                '/signup/',
              );}, child: const Text("Get Started")),
          TextButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                '/login/',
              );
              }, child: const Text("I Already Have an Account")),
              TextButton(onPressed: () async{
                await getMarkers("wc");
                Navigator.of(context).popAndPushNamed('/mapview/');
              }, child: const Text("Map")),
          const SizedBox(height: 70), const Text("Powered by HereWeR © 2022"), SizedBox(height: 40)
        ],
      )),
    );
  }
}
