import 'package:flutter/material.dart';
import 'package:mapview/constants/routes.dart';
import 'package:mapview/services/auth/auth_service.dart';
import 'package:mapview/services/chat_message.dart';
import 'package:mapview/services/firebase_database.dart';
import 'package:mapview/views/chat_view.dart';
import 'package:mapview/widgets/loading_overlay.dart';

extension Count<T extends Iterable> on Stream<T> {
  Stream<int> get getLength => map((event) => event.length);
}

class ChatManagerView extends StatefulWidget {
  final bool fullScreen;
  const ChatManagerView({Key? key, required this.fullScreen}) : super(key: key);

  @override
  _ChatManagerViewState createState() => _ChatManagerViewState();
}

class _ChatManagerViewState extends State<ChatManagerView> {
  late final FocusNode _messageFocus;
  late final TextEditingController _send;
  late final FirebaseCloudDatabase _chatService;
  String get username => AuthService.firebase().currentUser?.username ?? "bob";

  @override
  void initState() {
    _messageFocus = FocusNode();
    _send = TextEditingController();
    _chatService = FirebaseCloudDatabase();
    _messageFocus.addListener(() {
      if (_messageFocus.hasFocus && !widget.fullScreen) {
        _messageFocus.unfocus();
        Navigator.of(context).pushNamed(chatRoute);
      }
    });
    super.initState();
  }

  @override
  void dispose() {
    _messageFocus.dispose();
    _send.dispose();
    super.dispose();
  }

  FocusNode getFocusNode() {
    return _messageFocus;
  }

  void sendMessage() async {
    _chatService.sendMessage(
        sender: username, text: _send.text, destination: "global");
  }

  @override
  Widget build(BuildContext context) {
    Widget body = Column(
      children: [
        Expanded(
          child: StreamBuilder(
            stream: _chatService.allMessages(destination: "global"),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  if (snapshot.hasData) {
                    final allMessages = snapshot.data as Iterable<ChatMessage>;
                    return ChatView(
                      messages: allMessages,
                    );
                  } else {
                    return const LoadingOverlay();
                  }
                default:
                  return const LoadingOverlay();
              }
            },
          ),
        ),
        Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
              child: TextFormField(
                focusNode: _messageFocus,
                autofocus: (widget.fullScreen) ? true : false,
                textInputAction: TextInputAction.send,
                controller: _send,
                onEditingComplete: () {
                  if (_send.text.isEmpty) return;
                  sendMessage();
                  _send.clear();
                },
                decoration: const InputDecoration(
                  fillColor: Colors.pink,
                  border: OutlineInputBorder(),
                  hintText: "Start typing...",
                ),
                enableSuggestions: true,
                autocorrect: true,
                keyboardType: TextInputType.multiline,
              ),
            )),
      ],
    );

    if (widget.fullScreen) {
      return Scaffold(appBar: AppBar(title: const Text("Event Chat")), body: body);
    } else {
      return Scaffold(body: body);
    }
  }
}
