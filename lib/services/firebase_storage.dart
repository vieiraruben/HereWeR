import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
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

class FirebaseCloudStorage {
  final usernames = FirebaseFirestore.instance.collection('usernames');
  final messages = FirebaseFirestore.instance.collection('messages');

  void addUser({
    required String username,
    required String text,
    required String destination,
  }) async {
    await usernames.add({
      usernameField: username,
      textField: text,
      dateTimeField: DateTime.now(),
      destinationField: destination
    });
  }

// TODO: Quey usernames
// TODO: Finish this
  Future<ChatMessage> addMessage({required String senderUserId}) async {
    final document = await messages.add({
      senderUserField: senderUserId,
      textField: 'test',
    });
    final fetchedMessage = await document.get();
    return ChatMessage(
        documentId: fetchedMessage.id,
        senderId: senderUserId,
        text: '',
        destination: "testRecipient",
        dateTime: Timestamp.now());
  }

// Dynamic query (live changes)
  Stream<Iterable<ChatMessage>> allMessages({required String destination}) =>
      messages.orderBy("dateTime", descending: true).
      snapshots().map((event) => event.docs
          .map((doc) => ChatMessage.fromSnapshot(doc))
          .where((message) => message.destination == destination));

// Static query
  Future<Iterable<ChatMessage>> getMessages(
      {required String destination}) async {
    try {
      return await messages
          .where(destinationField, isEqualTo: destination)
          .get()
          .then(
            (value) => value.docs.map(
              (doc) {
                // or
                // ChatMessage.fromSnapshot(doc);
                return ChatMessage(
                  documentId: doc.id,
                  senderId: doc.data()[senderUserField] as String,
                  text: doc.data()[textField] as String,
                  dateTime: doc.data()[dateTimeField] as Timestamp,
                  destination: doc.data()[destinationField] as String,
                );
              },
            ),
          );
    } catch (e) {
      throw CouldNotGetAllDocumentException();
    }
  }

  Future<ChatMessage> sendMessage({required String sender, required String text, required String destination}) async {
    final document = await messages.add({
      senderUserField : sender,
      textField : text,
      destinationField : destination,
      dateTimeField : Timestamp.now()
    });
    final fetchedMessage = await document.get();
    return ChatMessage(
      documentId: fetchedMessage.id,
      senderId: sender,
      text: text,
      dateTime: Timestamp.now(),
      destination: destination
    );
  }

  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();
  factory FirebaseCloudStorage() => _shared;
}
