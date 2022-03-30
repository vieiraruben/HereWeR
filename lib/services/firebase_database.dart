import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/chat_message.dart';
import 'package:mapview/services/exceptions.dart';

const usernameField = "username";

@immutable
class Username {
  final String username;

  const Username({
    required this.username,
  });

  Username.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : username = snapshot.data()[usernameField];
}

class FirebaseCloudDatabase {
  final usernames = FirebaseFirestore.instance.collection('users');
  final messages = FirebaseFirestore.instance.collection('messages');

// Static query
  Future<Iterable<ChatMessage>> getMessages(
      {required String destination}) async {
    try {
      return await messages
          .where(destinationField, isEqualTo: destination)
          .get()
          .then(
            (value) => value.docs.map((doc) => ChatMessage.fromSnapshot(doc)),
          );
    } catch (e) {
      throw CouldNotGetDocumentException();
    }
  }

  // Dynamic query (live changes)
  Stream<Iterable<ChatMessage>> allMessages({required String destination}) =>
      messages.orderBy("dateTime", descending: true).snapshots().map((event) =>
          event.docs
              .map((doc) => ChatMessage.fromSnapshot(doc))
              .where((message) => message.destination == destination));

  Future<ChatMessage> sendMessage(
      {required String sender,
      required String text,
      required String destination}) async {
    final document = await messages.add({
      senderUserField: sender,
      textField: text,
      destinationField: destination,
      dateTimeField: Timestamp.now()
    });
    final fetchedMessage = await document.get();
    return ChatMessage(
      documentId: fetchedMessage.id,
      senderId: sender,
      text: text,
      dateTime: Timestamp.now(),
      destination: destination,
    );
  }

  void addUsername(String username) async {
    await usernames.add({"username": username});
  }

  void addProfilePic(String username, String photoUrl) async {
    usernames.where("username", isEqualTo: username).get().then((value) async {
      await usernames.doc(value.docs.first.id).update({"photoUrl": photoUrl});
    });
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUser(String user) async {
    try {
      return await usernames.where('username', isEqualTo: user).limit(1).get();
    } catch (e) {
      throw CouldNotGetDocumentException();
    }
  }

  Future<String?> getProfilePic(String user) async {
    QuerySnapshot<Map<String, dynamic>> value = await getUser(user);
    try {
      if (value.docs.first.data().keys.contains("photoUrl")) {
        return await FirebaseStorage.instance
            .ref()
            .child(value.docs.first.data()['photoUrl'])
            .getDownloadURL();
      } else {
        return "default";
      }
    } catch (e) {
      throw CouldNotGetDocumentException();
    }
  }

  Future<bool> isUsernameTaken(String username) async {
    var query = await usernames.where("username", isEqualTo: username).get();
    if (query.docs.isEmpty) {
      return false;
    }
    return true;
  }

  static final FirebaseCloudDatabase _shared =
      FirebaseCloudDatabase._sharedInstance();
  FirebaseCloudDatabase._sharedInstance();
  factory FirebaseCloudDatabase() => _shared;
}
