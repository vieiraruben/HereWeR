import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mapview/services/chat_message.dart';
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

Future<CachedNetworkImageProvider?> downloadPic(String username) async {
  String? url = await FirebaseCloudDatabase().getProfilePic(username);
  if (url != null && url != "default") {
    return CachedNetworkImageProvider(url);
    // Image.network(url);
  }
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
                future: downloadPic(widget.messages.elementAt(index).senderId),
                builder: (context,
                    AsyncSnapshot<CachedNetworkImageProvider?> snapshot) {
                  // switch (snapshot.connectionState) {
                  //   case ConnectionState.done:
                      if (snapshot.hasData) {
                        return CircleAvatar(
                            radius: 20,
                            backgroundColor:
                                const Color.fromARGB(255, 192, 229, 228),
                            foregroundImage: snapshot.data);
                      }
                      // break;
                    // default:
                    else {
                      return CircleAvatar(
                        radius: 20,
                        backgroundColor:
                            const Color.fromARGB(255, 192, 229, 228),
                        foregroundImage:
                            Image.asset('assets/images/defaultprofile.png')
                                .image,
                      );
                  }
                }),
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
