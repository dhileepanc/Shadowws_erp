import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectError extends StatefulWidget {
  const ProjectError({Key? key}) : super(key: key);

  @override
  State<ProjectError> createState() => _ProjectErrorState();
}

class _ProjectErrorState extends State<ProjectError> {
  String selectedProject = '';
  List<Map<String, dynamic>> projectErrors = [];
  List<dynamic> _projects = [];

  @override
  void initState() {
    super.initState();
    fetchProjectErrors();
    Project();
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
  Future<void> fetchProjectErrors() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(Uri.parse('http://192.168.0.14/d_shadowws_client_6/cli_project_error.php?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        projectErrors = List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch project errors');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Project Error', style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),),
      ),
      body: ListView(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            child: Table(
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              border: TableBorder.all(
                color: Colors.grey,
                width: 1,
              ),
              children: [
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                  ),
                  children: [
                    TableCell(
                      child: Text(
                        'S.No',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Project',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Error Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Updated By',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Error Title',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Action',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < projectErrors.length; i++)
                  TableRow(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: Colors.grey,
                        width: 1,
                      ),
                    ),
                    children: [
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text((i + 1).toString()),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectErrors[i]['project_name']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectErrors[i]['error_date']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectErrors[i]['error_updater_name']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectErrors[i]['error_title']),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Implement edit project error logic here
                          },
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return Scaffold(
                appBar: AppBar(
                  title: Text('Add Project Error'),
                ),
                body: Column(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        physics: AlwaysScrollableScrollPhysics(),
                        child: Card(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              DropdownButton<String>(
                                value: selectedProject,
                                onChanged: (String? value) {
                                  setState(() {
                                    selectedProject = value!;
                                  });
                                },
                                items: [
                                  DropdownMenuItem<String>(
                                    value: '',
                                    child: Text('Select a project'),
                                  ),
                                  for (var project in _projects)
                                    DropdownMenuItem<String>(
                                      value: project['id'].toString(),
                                      child: Text(project['project_id']),
                                    ),
                                ],
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Error Date',
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Error Updater Name',
                                ),
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Error Title',
                                ),
                              ),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Error Description',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {},
                      child: Text('Save'),
                    ),
                  ],
                ),
              );
            },
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}