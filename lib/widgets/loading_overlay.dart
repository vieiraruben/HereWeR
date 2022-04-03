import 'package:flutter/material.dart';

class LoadingOverlay extends StatelessWidget {
  const LoadingOverlay({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    CircularProgressIndicator loading = const CircularProgressIndicator(
      strokeWidth: 10,);
    return Stack(children: [Container(decoration: BoxDecoration(color: Colors.white.withOpacity(0.5))),
      Positioned(top:100, left: 100, bottom: 100, right: 100,
      child: Center(
        child: loading))]
    );
  }
}
