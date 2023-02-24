
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class completedproject extends StatefulWidget {

  @override
  State<completedproject> createState() => _completedprojectState();
}

class _completedprojectState extends State<completedproject> {
  var _projectName;

  @override
  void initState() {
    super.initState();
    Project();

  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getString('user_id');
    final projectName = prefs.getString('project_name');


    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_5/getCount1.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {

      _projectName=projectName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.red,
        title: Text('Completed Project'),
      ),
      body: Container(
        child: Text('$_projectName'),
      ),
    );
  }
}