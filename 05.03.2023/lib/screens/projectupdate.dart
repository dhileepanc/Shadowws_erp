import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ProjectUpdate extends StatefulWidget {
  const ProjectUpdate({Key? key}) : super(key: key);

  @override
  State<ProjectUpdate> createState() => _ProjectUpdateState();
}

class _ProjectUpdateState extends State<ProjectUpdate> {
  String selectedProject = '';
  List<Map<String, dynamic>> ProjectUpdates = [];
  List<dynamic> _projects = [];
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _updaterNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProjectUpdates();
    Project();
  }

  Future<void> Project() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse(
          'http://192.168.226.232/d_shadowws_client/cli_project_status.php?user_id=$userId'),
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

  Future<void> fetchProjectUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(Uri.parse(
        'http://192.168.226.232/d_shadowws_client/cli_project_update.php?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        ProjectUpdates =
            List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch project updates');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text('Project update'),
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
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Project Update',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Project',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Date',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Updated By',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Action',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                for (var i = 0; i < ProjectUpdates.length; i++)
                  TableRow(
                    children: [
                      TableCell(
                        child: Text((i + 1).toString()),
                      ),
                      TableCell(
                        child: Text(ProjectUpdates[i]['update_title']),
                      ),
                      TableCell(
                        child: Text(ProjectUpdates[i]['project_name']),
                      ),
                      TableCell(
                        child: Text(ProjectUpdates[i]['update_date']),
                      ),
                      TableCell(
                        child: Text(ProjectUpdates[i]['updater_name']),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // TODO: Implement edit project update logic here
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
                  backgroundColor: Colors.red,
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
                                  labelText: 'Update Date',
                                ),
                                controller: _dateController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: ' Updater Name',
                                ),
                                controller: _updaterNameController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Update Title',
                                ),
                                controller: _titleController,
                              ),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Update Description',
                                  alignLabelWithHint: true,
                                  border: OutlineInputBorder(),
                                ),
                                controller: _descriptionController,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        final userId = prefs.getString('user_id');
                        // Get the selected project ID from the dropdown
                        String projectId = selectedProject;

                        // Get the other data from the text fields
                        String errorDate = _dateController.text;
                        String updaterName = _updaterNameController.text;
                        String errorTitle = _titleController.text;
                        String description = _descriptionController.text;
                        String client =
                            ''; // Get the client from the project table using the selected project ID

                        // Make an HTTP POST request to the PHP script to insert the data into the database
                        var response = await http.post(
                            Uri.parse(
                                'https://192.168.0.14/d_shadowws_client_6/save_cli_project_update.php?user_id=$userId'),
                            body: {
                              'project_id': projectId,
                              'update_date': errorDate,
                              'updater_name': updaterName,
                              'update_title': errorTitle,
                              'desp': description,
                              'client': client,
                            });

                        // Print the response from the server
                        print(response.body);
                      },
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
