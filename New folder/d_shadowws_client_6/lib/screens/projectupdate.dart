import 'package:flutter/material.dart';

class ProjectUpdate extends StatelessWidget {
  const ProjectUpdate({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,
        title: Text('Project Update'),
      ),
      body: Container(
        child: Text('Project Update Page'),
      ),
    );
  }
}
