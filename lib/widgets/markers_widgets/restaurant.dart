import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:mapview/utilities/here_we_r_icons_icons.dart';
import '../../constants/restaurant_carousel.dart';

class RestaurantWidget extends StatefulWidget {
  const RestaurantWidget({Key? key}) : super(key: key);

  @override
  State<RestaurantWidget> createState() => RestaurantWidgetState();
}

//Widget qui est appelé par le bouton 'Learn more' de marker_on_tap
class RestaurantWidgetState extends State<RestaurantWidget> {
  //Booléens pour la navigation au sein du widget
  bool isPhotos = true;
  bool isMenu = false;

  //Liste de Maps entre des images (paths) et des descriptions
  //Ici le contenu est ajouté en dur mais l'idée est de récupérer ces contenus à partir de firestore (liés au marker)
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

              //Bouttons de navigation entre les différentes 'pages' du widget
              child: ButtonBar(
                mainAxisSize: MainAxisSize.min, // this will take space as minimum as posible(to center)
                children: <Widget>[
                  //Bouton pour passer en mode menu
                  ElevatedButton(
                      child: const Icon(HereWeRIcons.icons8_hamburger_64),
                      onPressed: () {
                        isPhotos = false;
                        isMenu = true;
                        setState(() {});
                      }),
                  //Pour passer en mode photos
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
            //Le contenu est chargé en fonction du booléen qui est vrai
            Container(
              color: Colors.white,
              child: isPhotos ? restaurantPhotos(contents) : restaurantMenu(), //fit: BoxFit.fill
            ),
          ],
        ),
      ),
    );
  }

  //Ce Widget est constitué d'une liste view de carroussels
  //Chaque carroussel est généré pour chaque Map dans la Liste contents
  Widget restaurantPhotos(List<Map<String, String>> contents) {
    return Container(
      width: 350,
      alignment: Alignment.center,
      child: ListView.builder(
          shrinkWrap: true,
          itemCount: contents.length,
          itemBuilder: (BuildContext context, int index) {
            //On itère sur la list et à chaque index, on appel carouselBuilder avec la Map correspondante.
            var content = contents[index];
            return carouselBuilder(content);
          }),
    );
  }

  //Génère un carrousel à partir d'une Map de paths et de descriptions
  Widget carouselBuilder(Map<String, String> content) {
    var paths = content.keys.toList();//Les clefs sont les paths car uniques, ici on les convertie en liste pour facilité la suite
    var descr = content.values.toList();//Idem pour les descriptions qui sont les values de la map
    final List<Widget> imageSliders = paths.map((path)  //Pour chaque paths(clefs) de la map on retourne le widget suivant
    => Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Image.asset(         //On charge l'image
                    path,
                    fit: BoxFit.contain,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      descr.elementAt(paths.indexOf(path)),  // et la description correspondante
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
        .toList();    // On converti le tout en list

    //on fait appel à la librairie carrousel slider comme définie dans la documentation
    //avec la list précedement créée et le controller associé.
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

//placeholder pour la page menu du toast
restaurantMenu() {
  return Image.asset("assets/images/food/menu.jpeg", );
}
