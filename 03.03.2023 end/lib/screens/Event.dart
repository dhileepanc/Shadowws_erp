import 'package:flutter/material.dart';

class Event extends StatelessWidget {
  const Event({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.red,
        title: Text('Event '),
      ),
      body: Container(
        child: Text('Event  Page'),
      ),
    );
  }
}

