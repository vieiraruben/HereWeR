import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


//Fonctions de convertion entre les formats GeoPoint et LatLng
LatLng geoToLatLng(GeoPoint geo){
  double lat = geo.latitude;
  double lng = geo.longitude;
  return LatLng(lat, lng);
}

GeoPoint latLngToGeo(LatLng latlng){
  double lat = latlng.latitude;
  double lng = latlng.longitude;
  return GeoPoint(lat, lng);
}