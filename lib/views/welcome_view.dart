import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:mapview/constants/carousel.dart';
import 'package:mapview/constants/routes.dart';
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
    double width = MediaQuery.of(context).size.width;
    var conditionalStyle = [1.0, 20.0];
    if (MediaQuery.of(context).size.width <= 320) {
      conditionalStyle[0] = 15;
      conditionalStyle[1] = 14.5;
    } else {
      conditionalStyle[0] = 27.0;
      conditionalStyle[1] = 17.0;
    }

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
                  Padding(
                    padding:
                        EdgeInsets.symmetric(horizontal: conditionalStyle[0]),
                    child: Text(
                      detailsList[imgList.indexOf(item)],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: conditionalStyle[1],
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ))
        .toList();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        const SizedBox(height: 15),
        Flexible(
          flex: 4,
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
                      signupRoute,
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
            ],
          ),
        ),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: SizedBox(
              height: 50,
              child: Column(children: [
                GestureDetector(
                  child: const Text("Powered by HereWeR © 2022 MAP HERE!"),
                  onTap: () async {
                    await getMarkers();
                    Navigator.of(context).pushNamed(mapRoute);
                  },
                ),
                GestureDetector(
                  child: const Text("CHAT HERE!"),
                  onTap: () {
                    // await getMarkers();
                    Navigator.of(context).pushNamed(chatRoute);
                  },
                ),
                GestureDetector(
                  child: const Text("Search HERE!"),
                  onTap: () {
                    // await getMarkers();
                    Navigator.of(context).pushNamed(searchRoute);
                  },
                ),
              ]),
            )),
      ])),
    );
  }
}
