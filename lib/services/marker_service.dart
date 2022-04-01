
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:mapview/services/marker.dart';
import 'package:mapview/utilities/geo_to_latlng.dart';
import '../constants/icon_imgs_paths.dart';
import '../widgets/markers_widgets/marker_on_tap.dart';

Map <String, String> iconPaths = {};
Set<Marker> markersSet = {};
class FireStoreMarkerCloudStorage {
  final markers = FirebaseFirestore.instance.collection('markers');

  void addMarker({
    required MarkerModel marker,
  }) async {
    await markers.add({
      "position": marker.markerPosition,
      "type" : marker.type,
      "name" : marker.name
    });
  }


  getBytesFromAsset( String path, int width) async {
    Uint8List iconUint8;
    ByteData data = await rootBundle.load(path);
    ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(), targetWidth: width);
    ui.FrameInfo fi = await codec.getNextFrame();
    iconUint8 = (await fi.image.toByteData(format: ui.ImageByteFormat.png))!.buffer.asUint8List();
    return iconUint8;

  }


  loadIconPaths() async {
    for (var path in iconImgs){
      var iconName = path.replaceAll("assets/images/icons8-", "");
      iconName = iconName.replaceAll("-500.png", "");
      iconPaths[iconName] = path;
    }
  }

  Future<Marker> initMarker(MarkerModel marker) async{
    final MarkerId markerId = MarkerId(marker.documentId);
    LatLng markerLatLng = geoToLatLng(marker.markerPosition);
    var iconUint8 = await getBytesFromAsset(iconPaths[marker.type]!, 70);
    final Marker googleMarker = Marker(
      markerId: markerId, position: markerLatLng,
      icon: BitmapDescriptor.fromBytes(iconUint8),
      consumeTapEvents: true,
      onTap:() {markerOnTapWidget(marker);}
    );
    return googleMarker;
  }





}
