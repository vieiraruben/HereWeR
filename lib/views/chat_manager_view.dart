import 'package:flutter/material.dart';
import 'package:mapview/services/auth/auth_service.dart';
import 'package:mapview/services/chat_message.dart';
import 'package:mapview/services/firebase_storage.dart';
import 'package:mapview/views/chat_view.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class ChatManagerView extends StatefulWidget {
  const ChatManagerView({Key? key}) : super(key: key);

  @override
  _ChatManagerViewState createState() => _ChatManagerViewState();
}

class _ChatManagerViewState extends State<ChatManagerView> {
  late final TextEditingController _send;
  late final FirebaseCloudStorage _chatService;
  String get userId => AuthService.firebase().currentUser!.id;

  @override
  void initState() {
    _send = TextEditingController();
    _chatService = FirebaseCloudStorage();
    super.initState();
  }

  @override
  void dispose() {
    _send.dispose();
    super.dispose();
  }

  void sendMessage(String value) async {
    _chatService.sendMessage(
        sender: "test123", text: value, destination: "global");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: StreamBuilder(
            stream: _chatService.allMessages(destination: "global").getLength,
            builder: (context, AsyncSnapshot<int> snapshot) {
              if (snapshot.hasData) {
                final chatCount = snapshot.data ?? 0;
                const text = "Global Chat";
                return Text(text);
              } else {
                return const Text('');
              }
            },
          ),
        ),
        body: Column(
        children: [Container(
          height: MediaQuery.of(context).size.height/1.5,child:
            StreamBuilder(
              stream: _chatService.allMessages(destination: "global"),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.active:
                    if (snapshot.hasData) {
                      final allMessages =
                          snapshot.data as Iterable<ChatMessage>;
                      return ChatView(
                        messages: allMessages,
                      );
                    } else {
                      return const CircularProgressIndicator();
                    }
                  default:
                    return const CircularProgressIndicator();
                }
              },
        ),),
            TextFormField(
              autofocus: true,
              textInputAction: TextInputAction.next,
              onFieldSubmitted: (v) => sendMessage(v),
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              enableSuggestions: true,
              autocorrect: true,
              keyboardType: TextInputType.multiline,
            ),
          ],
        ));
  }
}
