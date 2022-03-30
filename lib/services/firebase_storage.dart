import 'dart:developer';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:io';

class FireStorage {
  final FirebaseStorage storage = FirebaseStorage.instance;

  Future<void> upload({
    required String fileName,
    required File imageFile,
  }) async {
    try {
      print("f "+ fileName);
      print(imageFile);
      await storage
          .ref(fileName)
          .putFile(imageFile)
          .snapshot
          .ref
          .getDownloadURL();
    } on FirebaseException catch (e) {
      log(e.code);
    } catch (e) {
      log(e.toString());
    }
  }

  Future<List<Map<String, dynamic>>> loadImage() async {
    List<Map<String, dynamic>> files = [];

    final ListResult result = await storage.ref().list();
    final List<Reference> allFiles = result.items;

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();
      final FullMetadata fileMeta = await file.getMetadata();
      files.add({
        "url": fileUrl,
        "path": file.fullPath,
        "uploaded_by": fileMeta.customMetadata?['uploaded_by'] ?? 'Nobody',
        "description":
            fileMeta.customMetadata?['description'] ?? 'No description'
      });
    });

    return files;
  }
}
