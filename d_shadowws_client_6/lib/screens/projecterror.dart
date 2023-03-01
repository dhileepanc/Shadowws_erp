import 'package:flutter/material.dart';

class ProjectError extends StatelessWidget {
  const ProjectError({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar( backgroundColor: Colors.red,
        title: Text('Project Error '),
      ),
      body: Container(
        child: Text('Project Error Page'),
      ),
    );
  }
}
