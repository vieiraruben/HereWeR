import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

const senderUserField = 'sender';
const textField = 'text';
const dateTimeField = 'dateTime';
const destinationField = 'destination';

@immutable
class ChatMessage {
  final String documentId;
  final String senderId;
  final String text;
  final Timestamp dateTime;
  final String destination;

  const ChatMessage({
    required this.documentId,
    required this.senderId,
    required this.text,
    required this.dateTime,
    required this.destination,
  });

  ChatMessage.fromSnapshot(QueryDocumentSnapshot<Map<String, dynamic>> snapshot)
      : documentId = snapshot.id,
        senderId = snapshot.data()[senderUserField] as String,
        text = snapshot.data()[textField] as String,
        dateTime = snapshot.data()[dateTimeField] as Timestamp,
        destination = snapshot.data()[destinationField] as String;

}
