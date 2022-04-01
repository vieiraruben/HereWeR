import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:mapview/constants/icon_imgs_paths.dart';
import 'package:mapview/geolocation/user_location_permission.dart';
import 'package:mapview/services/circle.dart';
import 'package:mapview/services/circle_service.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';
import 'package:mapview/widgets/admin_widgets/marker_creation_form.dart';
import 'package:mapview/widgets/floating_menu.dart';
import '../services/marker.dart';
import '../services/marker_service.dart';
import '../utilities/calculate_distance.dart';

//Variables servant à stocker les infos des cercles et marker ajoutés en mode admin
late String markerType;
late String markerName;
late double radius;

class MapSample extends StatefulWidget {
  const MapSample({Key? key}) : super(key: key);
  @override
  State<MapSample> createState() => MapSampleState();
}

class MapSampleState extends State<MapSample> {
//instances des class permettant la gestion des Markers et des Cercles vis à vis de fireStore
  final FireStoreMarkerCloudStorage _markersService =
      FireStoreMarkerCloudStorage();
  final FireStoreCircleCloudStorage _circlesService =
      FireStoreCircleCloudStorage();

//Controller pour gérer les zooms de la caméra
  late GoogleMapController _controller;

//Instance de géolocalisation
  late Location location;

//Variables temporaires qui stockent les nouveaux éléments ajoutés à la map
  Set<MarkerModel> tempMarkers = HashSet<MarkerModel>();
  Set<Polygon> tempPolygons = HashSet<Polygon>();
  List<LatLng> tempPolygonLatLngs = <LatLng>[];
  Set<Circle> tempCircles = HashSet<Circle>();

//Id des markers temporaires (un id est nécessaire pour créer un Marker google)
  int tempPolygonIdCounter = 1;
  int tempCircleIdCounter = 1;
  int tempMarkerIdCounter = 1;

  //Booléens qui gèrent les fonctionnalités lièes à l'ajout de marqueurs sur la carte.
  bool isAdmin = true;
  bool isPolygon = false;
  bool isCircle = false;
  bool isMarker = false;
  bool isInteract = false;

  //Booléens qui gèrent la caméra
  //centrage de la caméra sur l'utilisateur
  bool isUserCentered = false;
  //L'utilisateur est il dans le perimêtre d'une scène?
  bool isLocalScene = false;
  //L'utilisateur a -t-il activivé le mode local dans ce cas?
  bool isLocalSceneActivated = false;
  //Sur quelle scène/ dans quel cercle l'utilisateur est il?
  late Circle? currentScene;

  //Position de départ de la caméra
  static const CameraPosition startCam = CameraPosition(
    target: LatLng(51.5089, -0.1729),
    zoom: 17,
  );

  //Fonction qui sera appelé pour recentrer la caméra sur l'évènement
  void _goToTheEvent() {
    _controller.animateCamera(CameraUpdate.newCameraPosition(startCam));
  }

  //Fonction qui va chercher les infos concernant les markers sur firestore
  // et les converties d'abord en MarkerModel puis en Marker.
  chargeMarkers() {
    _markersService.markers.get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          MarkerModel marker = MarkerModel.fromSnapshot(doc);
          markersSet.add(await _markersService.initMarker(marker, 70));
          setState(() {});
        }
      }
    });
  }

  //Fonction qui va chercher les infos concernant les cercles sur firestore
  // et les converties d'abord en CircleModel puis en Circle.
  chargeCircles() {
    _circlesService.circles.get().then((docs) async {
      if (docs.docs.isNotEmpty) {
        for (var doc in docs.docs) {
          CircleModel circle = CircleModel.fromSnapshot(doc);
          circlesSet.add(await _circlesService.initCircle(circle));
          setState(() {});
        }
      }
    });
  }

  //Fonction qui s'execute à la création de la map
  void _onMapCreated(GoogleMapController _cntlr) async {
    //initiallisation des instances de localisation et de controller
    location = Location();
    _controller = _cntlr;

    //Chargement des icons pour leur convertion en bitmap et chargement des cercles et des marker déja présents sur firestore.
    _markersService.loadIconPaths(iconImgs);
    chargeCircles();
    chargeMarkers();

    //Listener qui effectue des actions à chaque notification de position
    location.onLocationChanged.listen((loc) async {
      //Si Le toggle UserCentered est enclenché, la caméra est placé sur sa position
      if (isUserCentered) {
        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(loc.latitude!, loc.longitude!),
              zoom: await _controller.getZoomLevel()),
        ));
      }

      //Pour chaques cercles affichés, on calcul sa distance avec la position actuelle de l'utilisateur
      for (Circle circle in circlesSet) {
        double distance = calculateDistance(loc.latitude!, loc.longitude!,
            circle.center.latitude, circle.center.longitude);
        //Si la distance est plus petite que le rayon du cercle on active localToggle c'est à dire la possibilité de passer en vue scène
        if (distance <= circle.radius) {
          isLocalScene = true;
          radius = circle.radius;
          currentScene = circle;
          setState(() {});
        }
        //Sinon on le désactive
        else {
          isLocalScene = false;
          currentScene = null;
        }
      }

      //Si le localToggle est disponible et activé on centre la caméra sur la currentScene
      if (isLocalScene & isLocalSceneActivated) {
        double zoomLvl = 16 + (1.5 * 100 / radius);
        _controller.animateCamera(CameraUpdate.newCameraPosition(
          CameraPosition(
              target: LatLng(currentScene!.center.latitude,
                  currentScene!.center.longitude),
              zoom: zoomLvl),
        ));
      }
    });
  }

  @override
  void initState() {
    super.initState();
    //Vérification de la permission d'accès à la geolocation
    getUserLocationPermission();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          //On Build la map
          GoogleMap(
            mapType: MapType.terrain,
            initialCameraPosition: startCam,
            //Appel de la fonction vue précédement (chargement des markers...)
            onMapCreated: _onMapCreated,
            //Permet d'afficher le marker correspondant à la localisation de l'utilisateur
            myLocationEnabled: true,
            //Mais sans le boutton googleMap classique
            myLocationButtonEnabled: false,
            //Specification de la source des markers et des cercles
            circles: circlesSet,
            markers: markersSet,
            polygons: tempPolygons,
            //Lorsque l'on tap sur la map, celon le booléen qui vaut vrai, on appel différentes fonctions pour créer nos markers, cercles...
            onTap: (point) {
              if (isPolygon) {
                setState(() {
                  tempPolygonLatLngs.add(point);
                  _setPolygon();
                });
              } else if (isMarker) {
                setState(() {
                  _setMarkers(point, markerType, markerName);
                });
              } else if (isCircle) {
                setState(() {
                  _setCircles(point);
                });
              }
            },
          ),

          //Par dessus la map on affiche différents boutons
          Align(
              alignment: Alignment.centerLeft,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  //Le premier permet de replacer la caméra sur sa position initial (centre de l'évenement)
                  RawMaterialButton(
                    constraints: BoxConstraints.tight(const Size(36, 36)),
                    child: const Icon(Icons.travel_explore, size: 18),
                    shape: const CircleBorder(),
                    onPressed: () {
                      setState(() {
                        isUserCentered = false;
                        _goToTheEvent();
                      });
                    },
                    fillColor: Colors.tealAccent,
                    highlightColor: Colors.blue,
                  ),

                  //Le second est un toggle qui gère le centrage de la caméra sur l'utilisateur
                  RawMaterialButton(
                    constraints: BoxConstraints.tight(const Size(36, 36)),
                    child: const Icon(Icons.center_focus_strong, size: 18),
                    shape: const CircleBorder(),
                    onPressed: () {
                      setState(() {
                        isUserCentered = !isUserCentered;
                      });
                    },
                    fillColor: isUserCentered ? Colors.blue : Colors.grey,
                  ),

                  //Si L'utilisateur se trouve dans un cercle (scène) alors le troisième bouton est affiché
                  if (isLocalScene) getLocalToggle(),
                ],
              )),
          getMenu(context),

          //Si le mode admin est activé alors les contrôles permettant d'ajouter des éléments sont affichés
          if (isAdmin) getAdminTools(),
        ],
      ),
    );
  }

  //Toggle permettant de centrer la caméra sur la scène. A sa desactivation il recentre la caméra sur l'évenement
  Widget getLocalToggle() {
    return RawMaterialButton(
      constraints: BoxConstraints.tight(const Size(36, 36)),
      child: Icon(
          isLocalSceneActivated ? Icons.zoom_out_map : Icons.zoom_in_map,
          size: 18),
      shape: const CircleBorder(),
      onPressed: () {
        isLocalSceneActivated = !isLocalSceneActivated;
        if (!isLocalSceneActivated) {
          _goToTheEvent();
        }
        setState(() {});
      },
      fillColor: isLocalSceneActivated ? Colors.blue : Colors.grey,
    );
  }

  // Fonction qui ajoute les marker sur la carte on tap lorsque l'on a selectionner l'option marker en mode admin
  _setMarkers(LatLng point, String type, String name) async {
    //on définie un id temporaire nécessaire à la création d'un Marker
    final String markerId = "$tempMarkerIdCounter";
    //on cet id pour les prochains markers
    tempMarkerIdCounter++;
    //On créé un markerModel à partir des coordonnés du tap, de l'id et des infos rentrés par l'admin
    MarkerModel markerModel = MarkerModel(
        documentId: markerId,
        markerPosition: latLngToGeo(point),
        type: type,
        name: name);
    //On convertie le model en Marker
    Marker marker = await _markersService.initMarker(markerModel, 70);
    //On l'ajoute à la liste de Marker affichés
    markersSet.add(marker);
    //et à la liste temporaire de Marker
    tempMarkers.add(markerModel);
    //rafraichi le widget pour l'affichage
    setState(() {});
  }

  //Même procédé que pour setMarker cette fois pour les cercles
  void _setCircles(LatLng point) {
    final String circleId = "circle_$tempCircleIdCounter";
    tempCircleIdCounter++;
    setState(() {
      tempCircles.add(
        Circle(
          circleId: CircleId(circleId),
          center: point,
          radius: radius,
          strokeColor: Colors.red,
          strokeWidth: 1,
        ),
      );
    });
  }

  //Même procédé que pour setMarker cette fois pour les polygons
  void _setPolygon() {
    final String polygonId = "polygon_$tempPolygonIdCounter";
    tempPolygonIdCounter++;
    setState(() {
      tempPolygons.add(
        Polygon(
          polygonId: PolygonId(polygonId),
          points: tempPolygonLatLngs,
          fillColor: Colors.transparent,
          strokeWidth: 2,
          strokeColor: Colors.red,
        ),
      );
    });
  }

  //Widget qui s'affiche dans le cas ou isAdmin vaut true
  Widget getAdminTools() {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          //Quand on clique sur un des boutons l'option de création correspondante au texte passe à true
          //Toutes les autres à false
          //Interact correspond à l'absence d'option et à une interaction classique avec la carte
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isInteract ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = false;
                isCircle = false;
                isMarker = false;
                isInteract = true;
              });
            },
            child: const Text(
              'interact',
            ),
          ),

          //Passe en mode polygon
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isPolygon ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = true;
                isCircle = false;
                isMarker = false;
                isInteract = false;
              });
            },
            child: const Text(
              'polygon',
            ),
          ),

          //Passe en mode marker
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isMarker ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = false;
                isCircle = false;
                isMarker = true;
                isInteract = false;
              });
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Define marker',
                            textAlign: TextAlign.center),
                        contentPadding: const EdgeInsets.all(8),
                        content: (
                            //appel un formulaire de création qui permet de définir l'icon et le nom du nouveau Marker
                            const MarkersCreationForm()),
                        actions: [
                          TextButton(
                              onPressed: () async {
                                Navigator.pop(context);
                              },
                              child: const Text("Validate"))
                        ],
                      ));
            },
            child: const Text(
              'marker',
            ),
          ),

          //Passe en mode marker
          RawMaterialButton(
            constraints: BoxConstraints.tight(const Size(66, 36)),
            fillColor: isCircle ? Colors.blue : Colors.grey,
            onPressed: () {
              setState(() {
                isPolygon = false;
                isCircle = true;
                isMarker = false;
                isInteract = false;
              });
              //formulaire de création qui permet de définir le radius du nouveau cercle
              showDialog(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                        title: const Text('Choose radius'),
                        contentPadding: const EdgeInsets.all(8),
                        content: TextField(
                          decoration: const InputDecoration(
                              icon: Icon(Icons.zoom_out_map),
                              hintText: 'ex: 100',
                              suffixText: 'meters'),
                          keyboardType: const TextInputType.numberWithOptions(),
                          onChanged: (input) {
                            setState(() {
                              radius = double.parse(input);
                            });
                          },
                        ),
                        actions: [
                          TextButton(
                              onPressed: () => Navigator.pop(context),
                              child: const Text("ok"))
                        ],
                      ));
            },
            child: const Text(
              'circle',
            ),
          ),

          //Bouton qui permet de sauvegarder dans fireStore les éléments ajoutés
          RawMaterialButton(
            padding: EdgeInsets.all(4.0),
            constraints: BoxConstraints.tight(const Size(66, 36)),

            //Si il y a des nouveaux éléments le bouton est bleu ce qui indique qu'il y a des éléments à sauvegarder
            fillColor: tempMarkers.isNotEmpty || tempCircles.isNotEmpty
                ? Colors.blue
                : Colors.grey,
            onPressed: () {
              setState(() {
                //Pour chaque éléments dans les Listes temporaires de markers et de cercles on les ajoute à fireStore
                for (MarkerModel marker in tempMarkers) {
                  _markersService.addMarker(marker: marker);
                }
                for (Circle circle in tempCircles) {
                  double lat = circle.center.latitude;
                  double lng = circle.center.longitude;
                  GeoPoint centerGeo = GeoPoint(lat, lng);
                  CircleModel myCircle = CircleModel(
                      documentId: circle.circleId.toString(),
                      center: centerGeo,
                      radius: circle.radius);
                  _circlesService.addCircle(circle: myCircle);
                }

                //On vide les Listes temporaires après la sauvegarde pour ne pas les ajoutés plusieurs fois
                tempMarkers.clear();
                tempCircles.clear();
              });
            },
            child: const Text(
              'save',
            ),
          ),
        ],
      ),
    );
  }
}
