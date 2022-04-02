
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/services/marker.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';
import '../widgets/markers_widgets/marker_on_tap.dart';


//Maps avec pour clef des nom d'icon et comme valeures des paths vers les assets correspondants
Map <String, String> iconPaths = {};
Map <String, String> stageIconsPaths = {};

//List des markers à afficher sur la mapview
Set<Marker> markersSet = {};

//class gérant les intéractions avec la firestore pour les Markers
class FireStoreMarkerCloudStorage {
  //Instance de firestore connecté à la collection "markers"
  final markers = FirebaseFirestore.instance.collection('markers');

  //Methode pour ajouté un marker à firestore à partir d'un MarkerModel
  void addMarker({
    required MarkerModel marker,
  }) async {
    await markers.add({
      "position": marker.markerPosition,
      "type" : marker.type,
      "name" : marker.name
    });
  }

  //Fonction qui convertie une image en Uint8List pour pouvoir l'utiliser en temps qu'icon de Marker google map.
  getBytesFromAsset( String path, int width) async {
    Uint8List iconUint8;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    iconUint8 = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return iconUint8;
  }

  //Fonction qui convertie des paths en nom d'icon en enlevant les char superflus
  loadIconPaths(List<String> imgs) async {
    for (var path in imgs){
      var iconName = path.replaceAll("assets/images/icons/icons8-", "");
      iconName = iconName.replaceAll("-64.png", "");
      iconPaths[iconName] = path;
    }
  }

  //Idem pour des assets avec des path ayant un autre format
  loadStageIconPaths(List<String> imgs) async {
    for (var path in imgs){
      var iconName = path.replaceAll(".png", "");
      iconPaths[iconName] = path;
    }
  }

  //Fonction qui créé un Marker google à partir d'un MarkerModel
  Future<Marker> initMarker(MarkerModel marker, int size) async{
    //On converti l'id en MarkerId
    final MarkerId markerId = MarkerId(marker.documentId);
    //La position de GeoPoint à LatLng
    LatLng markerLatLng = geoToLatLng(marker.markerPosition);
    //On charge L'icon en convertissant L'asset en Uint8
    var iconUint8 = await getBytesFromAsset(iconPaths[marker.type]!, size);
    //On créé le Marker
    final Marker googleMarker = Marker(
      markerId: markerId, position: markerLatLng,
      icon: BitmapDescriptor.fromBytes(iconUint8),
      consumeTapEvents: true,
      onTap:() {markerOnTapWidget(marker);}
    );
    return googleMarker;
  }





}
