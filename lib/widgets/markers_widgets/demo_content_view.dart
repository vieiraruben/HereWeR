import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/marker.dart';
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
                  style: const TextStyle(fontWeight: FontWeight.bold)),
            )),
      ),
    );
  }

  static saladMenu() {
    return Column(children: const [
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
    ]);
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
                            Image.asset(item, fit: BoxFit.cover, height: 300)),
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
        makeHeader(context, "PHOTOS"),
        Container(
            child: CarouselSlider(
          options: CarouselOptions(),
          items: foodImgList
              .map((item) => Container(
                    child: Center(
                        child: Image.asset(item,
                            fit: BoxFit.cover, width: 1000)),
                  ))
              .toList(),
        )),
      ]);
    } else
      return SizedBox();
  }
}



// PopupMenuButton(
//         itemBuilder: (context) => [
//                       const PopupMenuItem<String>(
//       child: ListTile(
//           leading:
//               Icon(HereWeRIcons.icons8_stage_64, color: Colors.white, size: 35),
//           title: Text("Something's broken..."))),
//   const PopupMenuItem<String>(
//       child: ListTile(
//           leading: Icon(HereWeRIcons.icons8_toilet_64,
//               color: Colors.white, size: 35),
//           title: Text("Something's dirty..."))),
//   const PopupMenuItem<String>(
//       child: ListTile(
//           leading:
//               Icon(HereWeRIcons.icons8_about_64, color: Colors.white, size: 35),
//           title: Text("Someone's rowdy..."),),
//                     )],
//                      icon: Icon(HereWeRIcons.icons8_high_importance)
//                     )






//         color: Theme.of(context).canvasColor,
//         clipBehavior: Clip.antiAlias,
//         shape: RoundedRectangleBorder(
//           side: const BorderSide(color: Colors.white54, width: 1),
//           borderRadius: BorderRadius.circular(10),
//         ),
//         child: Column(
//           mainAxisSize: MainAxisSize.max,

//           children: [
//             Container(
//               color: Colors.amberAccent,
//               alignment: Alignment.topCenter,

//               //Bouttons de navigation entre les différentes 'pages' du widget
//               child: ButtonBar(
//                 mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
//                 children: <Widget>[
//                   //Bouton pour passer en mode menu
//                   ElevatedButton(
//                       child: const Icon(HereWeRIcons.icons8_hamburger_64),
//                       onPressed: () {
//                         isPhotos = false;
//                         isMenu = true;
//                         setState(() {});
//                       }),
//                   //Pour passer en mode photos
//                   ElevatedButton(
//                       child: const Icon(Icons.photo_sharp),
//                       onPressed: () {
//                         isPhotos = true;
//                         isMenu = false;
//                         setState(() {});
//                       }),
//                 ],
//               ),
//             ),
//             //Le contenu est chargé en fonction du booléen qui est vrai
//             Container(
//               color: Colors.white,
//               child: isPhotos ? restaurantPhotos(contents) : restaurantMenu(), //fit: BoxFit.fill
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   //Ce Widget est constitué d'une liste view de carroussels
//   //Chaque carroussel est généré pour chaque Map dans la Liste contents
//   Widget restaurantPhotos(List<Map<String, String>> contents) {
//     return Container(
//       width: 350,
//       alignment: Alignment.center,
//       child: ListView.builder(
//           shrinkWrap: true,
//           itemCount: contents.length,
//           itemBuilder: (BuildContext context, int index) {
//             //On itère sur la list et à chaque index, on appel carouselBuilder avec la Map correspondante.
//             var content = contents[index];
//             return carouselBuilder(content);
//           }),
//     );
//   }

//   //Génère un carrousel à partir d'une Map de paths et de descriptions
//   Widget carouselBuilder(Map<String, String> content) {
//     var paths = content.keys.toList();//Les clefs sont les paths car uniques, ici on les convertie en liste pour facilité la suite
//     var descr = content.values.toList();//Idem pour les descriptions qui sont les values de la map
//     final List<Widget> imageSliders = paths.map((path)  //Pour chaque paths(clefs) de la map on retourne le widget suivant
//     => Container(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   Image.asset(         //On charge l'image
//                     path,
//                     fit: BoxFit.contain,
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Text(
//                       descr.elementAt(paths.indexOf(path)),  // et la description correspondante
//                       textAlign: TextAlign.center,
//                       style: const TextStyle(
//                         fontSize: 12,
//                         fontWeight: FontWeight.bold,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ))
//         .toList();    // On converti le tout en list

//     //on fait appel à la librairie carrousel slider comme définie dans la documentation
//     //avec la list précedement créée et le controller associé.
//     var _controller = CarouselController();
//     return CarouselSlider(
//       items: imageSliders,
//       carouselController: _controller,
//       options: CarouselOptions(
//           autoPlay: true,
//           enlargeCenterPage: true,
//           aspectRatio: 1.5,
//           onPageChanged: (index, reason) {}),
//     );
//   }
// }

// //placeholder pour la page menu du toast
// restaurantMenu() {
//   return Image.asset("assets/images/food/menu.jpeg", );
// }
