/*
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService {
  FirestoreService._();
  static final instance = FirestoreService._();

  Stream<List<T>> collectionStream<T>({
    required String path,
    required T Function(Map<String, dynamic> data, String documentID) builder,
  }) {
    Query query = FirebaseFirestore.instance.collection(path);
    final Stream<QuerySnapshot> snapshots = query.snapshots();
    return snapshots.map((snapshot) {
      final result = snapshot.docs
          .map((snapshot) =>
          builder(snapshot.data() as Map<String, dynamic>, snapshot.id))
          .where((value) => value != null)
          .toList();
      return result;
    });
  }
}*/
