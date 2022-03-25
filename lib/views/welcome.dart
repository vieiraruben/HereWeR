import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mapview/firestoreData/markers_data.dart';

class Welcome extends StatefulWidget {
  const Welcome({Key? key}) : super(key: key);

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

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
    print(MediaQuery.of(context).size.width);
    double width = MediaQuery.of(context).size.width;
    var conditionalStyle = [1.0, 20.0];
    if (MediaQuery.of(context).size.width <= 320) {
      conditionalStyle[0] = 15;
      conditionalStyle[1] = 14.5;
    } else {
      conditionalStyle[0] = 40.0;
      conditionalStyle[1] = 17.0;
    }
    double height = MediaQuery.of(context).size.height;
    final List<String> imgList = [
      'assets/images/map.png',
      'assets/images/chat.png',
      'assets/images/micro.png',
      'assets/images/mega.png',
    ];
    final List<String> detailsList = [
      'Easily find your way\nthrough the crowd',
      'Connect with your fellow festival goers',
      'Check out showtimes for your most anticipated concerts',
      "Don't miss out on news throughout the event"
    ];

    final List<Widget> imageSliders = imgList
        .map((item) => Container(
              margin: const EdgeInsets.all(1.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Image.asset(
                    item,
                    fit: BoxFit.contain,
                    width: width / 1.5,
                  ),
                  Container(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: conditionalStyle[0]),
                      child: Text(
                        detailsList[imgList.indexOf(item)],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: conditionalStyle[1],
                          // fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();

    return Scaffold(
      body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 15),
        Flexible(
          flex: 3,
          child: CarouselSlider(
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
        ),
        Expanded(
          flex: 1,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: imgList.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(
                      vertical: 15.0, horizontal: 4.0),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: (Theme.of(context).brightness == Brightness.dark
                              ? Colors.white
                              : Colors.black)
                          .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                ),
              );
            }).toList(),
          ),
        ),
        Expanded(
          flex: 2,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/signup/',
                    );
                  },
                  child: const Text(
                    "Get Started",
                    textScaleFactor: 1.3,
                  )),
              TextButton(
                  onPressed: () {
                    Navigator.of(context).pushNamed(
                      '/login/',
                    );
                  },
                  child: const Text("I Already Have an Account")),
              // TextButton(
              //     onPressed: () async {
              //       await getMarkers("wc");
              //       Navigator.of(context).popAndPushNamed('/mapview/');
              //     },
              //     child: const Text("Map")),
            ],
          ),
        ),
        Align(
          alignment: FractionalOffset.bottomCenter,
          child: Container(
            height: 50,
            child: GestureDetector(
                child: Text("Powered by HereWeR © 2022"), onTap: () async {
                    await getMarkers("wc");
                    Navigator.of(context).popAndPushNamed('/mapview/');
                  },),
          ),
        ),
      ])),
    );
  }
}
