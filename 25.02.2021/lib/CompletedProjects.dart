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
  int _openTask = 0;
  int _completedTask = 5;
  int _totalTask = 6;

  @override
  void initState() {
    super.initState();
    Project();
    Task();
  }

  Future<void> Task() async {
    final prefs = await SharedPreferences.getInstance();
    final project_id = prefs.getString('project_id');
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_5/cli_task.php?project_id=$project_id'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      _openTask = int.parse(data['opentask']);
      _completedTask = int.parse(data['com_task']);
      _totalTask = int.parse(data['total_task']);
    });
  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_5/cli_project_status.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      _projectName = data['project_name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Project Status'),
      ),
      body: Column(
        children: [
          Container(
            child: Text('$_projectName'),
          ),
          Container(
            child: Text('$_openTask'),
          ),
          Container(
            child: Text('$_completedTask'),
          ),
          Container(
            child: Text('$_totalTask'),
          ),
        ],
      ),
    );
  }
}
