import 'package:flutter/material.dart';
import 'package:mapview/services/firebase_database.dart';

class UserProfileView extends StatefulWidget {
  const UserProfileView({ Key? key, required this.username }) : super(key: key);
  
  final String username;

  @override
  State<UserProfileView> createState() => _UserProfileViewState();
}

class _UserProfileViewState extends State<UserProfileView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.username)),
      body: Text("hello world"),
    );
  }
}