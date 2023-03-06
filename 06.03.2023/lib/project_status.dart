import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class ProjectStatus extends StatefulWidget {
  @override
  State<ProjectStatus> createState() => _ProjectStatusState();
}

class _ProjectStatusState extends State<ProjectStatus> {
  List<dynamic> _projects = [];
  double _progressValue = 0.0;

  /* var _projectName;
  int _openTask = 0;
  int _completedTask = 5;
  int _totalTask = 6;
 var _deadline;
 var _projectTeamLeaderName;
 var _teamName;
 double _progress=0.0;*/

  @override
  void initState() {
    super.initState();

    // Task();
    Project();
  }

  /*Future<void> Task() async {
    final prefs = await SharedPreferences.getInstance();

    final project_id = prefs.getString('project_id');
    print(project_id);
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_6/cli_task.php?project_id=$project_id'),
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
  }*/

  /*Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final teamLeaderId = prefs.getString('team_leader_id');
    final team = prefs.getString('team');
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_6/cli_project_status.php?user_id=$userId&team_leader_id=$teamLeaderId&team=$team'),
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
  }*/
  Future<Map<String, dynamic>> _getTaskDetails(String projectId) async {
    final response = await http.get(Uri.parse(
        'http://192.168.0.14/d_shadowws_client_6/cli_task.php?project_id=$projectId'));
    final jsonData = json.decode(response.body);
    print(jsonData);
    return jsonData;
  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_6/cli_project_status.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    if (data != null && data['projects'] != null) {
      setState(() {
        _projects = data['projects'];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Project Status'),
      ),
      body: ListView.builder(
        itemCount: _projects.length,
        itemBuilder: (context, index) {
          final project = _projects[index];
          return SingleChildScrollView(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              padding: EdgeInsets.all(10),
              child: FutureBuilder(
                future: _getTaskDetails(project['id']),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final taskDetails = snapshot.data;
                    _progressValue = taskDetails!['progress'] / 100;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ProjectDetailsPage(project: {
                                  'id': project['id'],
                                  'name': project['name'],
                                  'hours': project['hours'],
                                  'e_date': project['e_date'],
                                  'description': project['desp'],
                                  'created': project['s_date'],
                                  'priority': project['priority'],
                                  'created_by': project['created_by'],
                                  'status': project['pm_status'],
                                  'leader_name':
                                      taskDetails!['project_leader_name'],
                                  'team': taskDetails!['team_name'],
                                  'opentask': taskDetails!['opentask'],
                                  'com_task': taskDetails!['com_task'],
                                  'total_task': taskDetails!['total_task'],
                                }),
                              ),
                            );
                          },
                          child: Text(
                            'Project Name: ${project['name']}',
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Deadline: ${project['e_date']}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Open tasks: ${taskDetails!['opentask']}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Completed tasks: ${taskDetails['com_task']}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Total tasks: ${taskDetails['total_task']}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Project Leader: ${taskDetails!['project_leader_name']}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Team: ${taskDetails!['team_name']}',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                        SizedBox(height: 10),
                        LinearProgressIndicator(
                          value: _progressValue,
                          backgroundColor: Colors.grey,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.blue),
                        ),
                        SizedBox(height: 5),
                        Text(
                          '${taskDetails['progress']}%',
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                          ),
                        ),
                      ],
                    );
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Center(child: CircularProgressIndicator());
                  }
                },
              ),
            ),
          );
        },
      ),
    );
  }
}

class ProjectDetailsPage extends StatelessWidget {
  final dynamic project;

  const ProjectDetailsPage({Key? key, required this.project}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(project['name']),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  '${project['total_task']} Total Task',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                  ),
                ),
                SizedBox(
                  width: 5,
                ),
                Text(
                  '${project['opentask']} opentask',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                  ),
                ),
                Text(
                  '${project['com_task']} completed task',
                  style: TextStyle(
                    color: Colors.grey[600],
                    fontSize: 18,
                  ),
                ),
              ],
            ),
            Text(
              'Project Description:',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${project['description']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
              ),
            ),
            SizedBox(height: 24),
            Text(
              'Project Details:',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Table(
              border: TableBorder.all(color: Colors.grey),
              children: [
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total Hours',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${project['hours']}'),
                    ),
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Created',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${project['created']}'),
                    ),
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Deadline',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${project['e_date']}'),
                    ),
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Priority',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${project['priority']}'),
                    ),
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Created by',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${project['created_by']}'),
                    ),
                  ),
                ]),
                TableRow(children: [
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Status',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  TableCell(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '${project['status']}',
                        style: TextStyle(
                          color: Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ]),
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Assigned Leader:',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${project['leader_name']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Assigned Employee:',
              style: TextStyle(
                color: Colors.red,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              '${project['team']}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
