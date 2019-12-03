import 'dart:ffi';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ReceiveDetails extends StatefulWidget {
  double length;
  double pitch;

  ReceiveDetails({Key key, this.length, this.pitch}) : super(key: key);

  createState() => _ReceiveDetailsState();
}

class _ReceiveDetailsState extends State<ReceiveDetails> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Editor'),
      ),
      body: Center(
        child: new Text(
          "Screw Length: ${(widget.length).toStringAsFixed(4)} inches\nScrew Thread Pitch: ${(widget.pitch).toStringAsFixed(4)} inches",
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}