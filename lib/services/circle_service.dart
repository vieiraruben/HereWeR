import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mapview/services/circle.dart';


class FireStoreCircleCloudStorage{
  final circles = FirebaseFirestore.instance.collection('circles');

  void addCircle({
    required CircleModel circle,
  }) async {
    await circles.add({
      "position": circle.center,
      "radius": circle.radius,
    });
  }

}