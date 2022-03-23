import 'package:cloud_firestore/cloud_firestore.dart';

import '../marker.dart';

FirebaseFirestore FS = FirebaseFirestore.instance;
CollectionReference markersCollectionReference = FS.collection('markers');

Future<void> addWorker({required MyMarker marker,}) async
{
DocumentReference documentReference = markersCollectionReference.doc();
Map<String, dynamic> data = <String, dynamic>{
  "position": marker.coor,
  "type": marker.icon,
};

await documentReference
    .set(data)
.whenComplete(() => print("Marker added to the firestore"))
.catchError((e) => print(e));
}

Stream<QuerySnapshot> getMarkers() {
return markersCollectionReference.snapshots();
}