import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProjectStatus extends StatefulWidget {
  @override
  State<ProjectStatus> createState() => _ProjectStatusState();
}

class _ProjectStatusState extends State<ProjectStatus> {
  var _projectName;
  int _openTask = 0;
  int _completedTask = 5;
  int _totalTask = 6;
 var _deadline;
 var _projectTeamLeaderName;
 var _teamName;
 double _progress=0.0;

  @override
  void initState() {
    super.initState();

    Task();
    Project();
  }

  Future<void> Task() async {
    final prefs = await SharedPreferences.getInstance();

    final project_id = prefs.getString('project_id');
    print(project_id);
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
      _progress=_totalTask==0?0:(_completedTask/_totalTask)*100;

    });
  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final teamLeaderId = prefs.getString('team_leader_id');
    final team = prefs.getString('team');
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_5/cli_project_status.php?user_id=$userId&team_leader_id=$teamLeaderId&team=$team'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      _projectName = data['project_name'];
      _deadline=data['deadline'];
      _projectTeamLeaderName=data['project_leader_name'];
      _teamName=data['team'];

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
            child: GestureDetector(
              onTap: () {print('clicked');
                // Navigate to a new page or perform any other desired action
              },
              child: Text(
                '$_projectName',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.blue, // Use a different color to indicate that it's clickable
                   // Add an underline to indicate that it's clickable
                ),
              ),
            ),
          ),
          Container(
            child: Text('$_openTask:open task'),
          ),
          Container(
            child: Text('$_completedTask:completed task'),
          ),
          Container(
            child: Text('$_totalTask:total task'),
          ),
          Container(
            child: Column(
              children: [
                Text(
                  "Deadline",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  '$_deadline',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                Text(
                  "Project Leader",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  '$_projectTeamLeaderName',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                Text(
                  "Team",
                  style: TextStyle(fontSize: 16, color: Colors.black),
                ),
                SizedBox(height: 8),
                Text(
                  '$_teamName',
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                child: LinearProgressIndicator(
                  value: _progress / 100,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
              ),
              Text('${_progress.toStringAsFixed(2)}%'),
            ],
          ),
        ],
      ),
    );
  }


}
