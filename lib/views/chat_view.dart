import 'package:flutter/material.dart';
import 'package:mapview/services/chat_message.dart';

class ChatView extends StatelessWidget {
  final Iterable<ChatMessage> messages;

  const ChatView({
    Key? key,
    required this.messages,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(maxHeight: 600), child: ListView.builder(
        itemCount: messages.length,
        reverse: true,
        itemBuilder: (context, index) {
          return ListTile(
            visualDensity: VisualDensity.compact,
            leading: CircleAvatar(
              radius: 20,
              backgroundColor:
              const Color.fromARGB(255, 192, 229, 228),
              foregroundImage:
              Image.asset('assets/images/defaultprofile.png')
              .image),
              title: Text(
                messages.elementAt(index).text,
                softWrap: true,
                overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(messages.elementAt(index).senderId),
                );
          },),
    );
  }
}
