import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLng;





class MyMarker extends StatefulWidget {
  String type;
  LatLng.LatLng coor;
  IconData icon = Icons.restaurant;
  MyMarker({Key? key, required this.type, required this.coor}) : super(key:key);

  @override
  State<MyMarker> createState() => _MyMarkerState();
}

class _MyMarkerState extends State<MyMarker> {
  @override
  Widget build(BuildContext context) {
    return RawMaterialButton(
      onPressed: () {},
      constraints: const BoxConstraints.expand(width: 40, height: 40),
      child: Icon(
        widget.icon,
        color: Colors.black,
        size: 25,
      ),
    );
  }
}

class MyMarkers {
  List<MyMarker> markers;
  MyMarkers(this.markers);

  MarkerLayerOptions displayMarkers()
  {
    List<Marker> list = [];
    for(var i = 0; i < markers.length; i++){
      Marker marker =  Marker(
        point: markers.elementAt(i).coor,
        builder: (ctx) => markers.elementAt(i),
      );
      list.add(marker);
    }
    return MarkerLayerOptions(
        markers: [
          ... list,
        ]
    );
  }
}
