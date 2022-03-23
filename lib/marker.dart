import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as LatLng;




class MyMarker extends StatefulWidget {
  IconData icon;
  LatLng.LatLng coor;
  MyMarker({Key? key, required this.icon, required this.coor}) : super(key:key);

  @override
  State<MyMarker> createState() => _MyMarkerState();
}

class _MyMarkerState extends State<MyMarker> {
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
        radius: 30,
        backgroundColor: const Color.fromRGBO(255,255,255,0),
        child :RawMaterialButton(
          onPressed: () {},
          constraints: const BoxConstraints.expand(width: 40, height: 40),
          child: Icon(
            widget.icon,
            color: Colors.black,
            size: 25,
          ),
        )
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
      print(marker.runtimeType);
      list.add(marker);
      print(marker.toString());
    }
    return MarkerLayerOptions(
        markers: [
          ... list,
        ]
    );
  }
}

Function additionneur(num n) {
  return (num i) => n + i;
}