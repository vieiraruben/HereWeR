import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/chat_message.dart';
import 'package:mapview/utilities/profile_pic_loader.dart';
import 'package:mapview/services/firebase_database.dart';

class ChatView extends StatefulWidget {
  final Iterable<ChatMessage> messages;

  const ChatView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  State<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends State<ChatView> {
  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600),
      child: ListView.builder(
        itemCount: widget.messages.length,
        reverse: true,
        itemBuilder: (context, index) {
          return ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 20),
            visualDensity: const VisualDensity(horizontal: -4, vertical: -4),
            leading: FutureBuilder(
                future: FirebaseCloudDatabase().getUser(widget.messages.elementAt(index).senderId),
                builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if (snapshot.hasData && snapshot.data!.docs.isNotEmpty) {
                    return CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            const Color.fromARGB(255, 192, 229, 228),
                        foregroundImage: (snapshot.data!.docs.first
                        .data().keys.contains("photoUrl"))
                          ? CachedNetworkImageProvider(
                              "https://firebasestorage.googleapis.com/v0/b/herewer-a1d7b.appspot.com/o/" +
                                  snapshot.data!.docs.first["photoUrl"] +
                                  "?alt=media")
                          : Image.asset('assets/images/defaultprofile.png')
                              .image);
                  } else {
                    return const CircleAvatar(
                      radius: 20,
                      backgroundColor: Color.fromARGB(255, 192, 229, 228),
                    );
                  }
                }),

            //       FutureBuilder(
            // future: downloadPic(widget.messages.elementAt(index).senderId),
            // builder: (context, AsyncSnapshot<ImageProvider?> snapshot) {
            //   if (snapshot.hasData) {
            //     return CircleAvatar(
            //         radius: 20,
            //         backgroundColor: const Color.fromARGB(255, 192, 229, 228),
            //         foregroundImage: snapshot.data);
            //   } else {
            //     return const CircleAvatar(
            //       radius: 20,
            //       backgroundColor:  Color.fromARGB(255, 192, 229, 228),

            //     );
            //   }
            // }) ,

            title: Text(
              widget.messages.elementAt(index).text,
              softWrap: true,
              overflow: TextOverflow.visible,
            ),
            subtitle: Text(widget.messages.elementAt(index).senderId),
          );
        },
      ),
    );
  }
}
