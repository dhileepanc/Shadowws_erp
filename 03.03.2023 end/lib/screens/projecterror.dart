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
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _updaterNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

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
    final response = await http.get(Uri.parse(
        'http://192.168.0.14/d_shadowws_client_6/cli_project_error.php?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        projectErrors =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch project errors');
    }
  }

  Future<void> deleteProjectError(String id) async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_6/delete_cli_project_error.php?id=$id'),
    );
    if (response.statusCode == 200) {
      setState(() {
        projectErrors.removeWhere((error) => error['id'] == id);
      });
    } else {
      throw Exception('Failed to delete project error');
    }
  }

  Future<void> editProjectError(Map<String, dynamic> errorData) async {
    _dateController.text = errorData['error_date'];
    _updaterNameController.text = errorData['error_updater_name'];
    _titleController.text = errorData['error_title'];
    _descriptionController.text = errorData['error_description'];

    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Edit Project Error'),
            content: Form(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                    controller: _dateController,
                    decoration: InputDecoration(labelText: 'Error Date'),
                    keyboardType: TextInputType.datetime,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _updaterNameController,
                    decoration: InputDecoration(labelText: 'Error updater name Date'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid date';
                      }
                      return null;
                    },
                  ),TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Error Date'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid date';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(labelText: 'Error updater name Date'),
                    keyboardType: TextInputType.name,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a valid date';
                      }
                      return null;
                    },
                  ),
                ],),
            ),
          ),
    );
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
                        'Edit',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    TableCell(
                      child: Text(
                        'Delete',
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
                          onPressed: () {/*
                                Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => editProjectError(
                                  errorData: projectErrors[i],
                                ),
                              ),
                            );*/},
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            deleteProjectError(projectErrors[i]['id']);
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
                appBar: AppBar(backgroundColor: Colors.red,
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
                                controller: _dateController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Error Updater Name',
                                ),
                                controller: _updaterNameController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'Error Title',
                                ),
                                controller: _titleController,
                              ),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'Error Description',
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
                        String client = ''; // Get the client from the project table using the selected project ID

                        // Make an HTTP POST request to the PHP script to insert the data into the database
                        var response = await http.post(Uri.parse(
                            'https://192.168.0.14/d_shadowws_client_6/save_cli_project_error.php?user_id=$userId'),
                            body: {
                              'project_id': projectId,
                              'error_date': errorDate,
                              'error_updater_name': updaterName,
                              'error_title': errorTitle,
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

