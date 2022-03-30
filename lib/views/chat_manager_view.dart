import 'package:flutter/material.dart';
import 'package:mapview/services/auth/auth_service.dart';
import 'package:mapview/services/chat_message.dart';
import 'package:mapview/services/firebase_database.dart';
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
  late final FirebaseCloudDatabase _chatService;
  String get username => AuthService.firebase().currentUser?.username ?? "bob";

  @override
  void initState() {
    _send = TextEditingController();
    _chatService = FirebaseCloudDatabase();
    super.initState();
  }

  @override
  void dispose() {
    _send.dispose();
    super.dispose();
  }

  void sendMessage() async {
    _chatService.sendMessage(
        sender: username, text: _send.text, destination: "global");
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
          children: [
            Expanded(
              child: StreamBuilder(
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
              ),
            ),
            Align(
                alignment: FractionalOffset.bottomCenter,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                  child: TextFormField(
                    autofocus: true,
                    textInputAction: TextInputAction.send,
                    controller: _send,
                    onEditingComplete: () {
                      if (_send.text.isEmpty) return;
                      sendMessage();
                      _send.clear();
                    },
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: "Start typing...",
                    ),
                    enableSuggestions: true,
                    autocorrect: true,
                    keyboardType: TextInputType.multiline,
                  ),
                )),
          ],
        ));
  }
}
