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

  Future<void> updateData(int id, String errorDate, String errorUpdaterName,
      String errorTitle, String desp) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    // Construct the URL for the PHP script
    String url =
        'http://192.168.226.232/d_shadowws_client/update_cli_project_error.php?id=$id&user_id=$userId';

    // Construct the HTTP POST request body
    Map<String, String> body = {
      'error_date': errorDate,
      'error_updater_name': errorUpdaterName,
      'error_title': errorTitle,
      'desp': desp,
    };

    // Send the HTTP POST request to the PHP script
    http.Response response = await http.post(Uri.parse(url), body: body);

    // Check the response status code
    if (response.statusCode == 200) {
      print(response.body);
    } else {
      print('Error updating data: ${response.statusCode}');
    }
  }

  Future<void> fetchProjectErrors() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(Uri.parse(
        'http://192.168.226.232/d_shadowws_client/cli_project_error.php?user_id=$userId'));
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
          'http://192.168.226.232/d_shadowws_client/delete_cli_project_error.php?id=$id'),
    );
    if (response.statusCode == 200) {
      setState(() {
        projectErrors.removeWhere((error) => error['id'] == id);
      });
    } else {
      throw Exception('Failed to delete project error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Project Error',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
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
                          onPressed: () {
                            // Populate the input fields with the selected project error's data
                            selectedProject = projectErrors[i]['project_name'];
                            _dateController.text =
                                projectErrors[i]['error_date'];
                            _updaterNameController.text =
                                projectErrors[i]['error_updater_name'];
                            _titleController.text =
                                projectErrors[i]['error_title'];
                            _descriptionController.text =
                                projectErrors[i]['desp'];

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Edit Project Error'),
                                content: Container(
                                  height: 400,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _dateController,
                                        decoration: InputDecoration(
                                            labelText: 'Error Date'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an error date';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _updaterNameController,
                                        decoration: InputDecoration(
                                            labelText: 'Updater Name'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an updater name';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _titleController,
                                        decoration: InputDecoration(
                                            labelText: 'Error Title'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an error title';
                                          }
                                          return null;
                                        },
                                      ),
                                      TextFormField(
                                        controller: _descriptionController,
                                        decoration: InputDecoration(
                                            labelText: 'Error Description'),
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return 'Please enter an error description';
                                          }
                                          return null;
                                        },
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    child: Text('CANCEL'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                  ElevatedButton(
                                    onPressed: () async {
                                      final error = {
                                        'id': projectErrors[i]['id'],
                                        'project_name': selectedProject,
                                        'error_date': _dateController.text,
                                        'error_updater_name':
                                            _updaterNameController.text,
                                        'error_title': _titleController.text,
                                        'desp': _descriptionController.text,
                                      };
                                      await updateData(
                                          int.parse(projectErrors[i]['id']),
                                          _dateController.text,
                                          _updaterNameController.text,
                                          _titleController.text,
                                          _descriptionController.text);
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('update'),
                                  ),
                                ],
                              ),
                            );
                          },
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
                        String client =
                            ''; // Get the client from the project table using the selected project ID

                        // Make an HTTP POST request to the PHP script to insert the data into the database
                        var response = await http.post(
                            Uri.parse(
                                'https://192.168.226.232/d_shadowws_client/save_cli_project_error.php?user_id=$userId'),
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

class ProjectErrorEdit extends StatefulWidget {
  final Map<String, dynamic> projectError;

  const ProjectErrorEdit({Key? key, required this.projectError})
      : super(key: key);

  @override
  _ProjectErrorEditState createState() => _ProjectErrorEditState();
}

class _ProjectErrorEditState extends State<ProjectErrorEdit> {
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _updaterNameController = TextEditingController();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _dateController.text = widget.projectError['error_date'];
    _updaterNameController.text = widget.projectError['error_updater_name'];
    _titleController.text = widget.projectError['error_title'];
    _descriptionController.text = widget.projectError['error_description'];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Project Error'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Project: ${widget.projectError['project_name']}',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _dateController,
              decoration: InputDecoration(
                labelText: 'Error Date',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _updaterNameController,
              decoration: InputDecoration(
                labelText: 'Updated By',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Error Title',
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: InputDecoration(
                labelText: 'Error Description',
              ),
            ),
            SizedBox(height: 16),
            TextButton(
              onPressed: () async {
                // Construct a Map object with the updated data
                Map<String, dynamic> updatedProjectError = {
                  'id': widget.projectError['id'],
                  'user_id': widget.projectError['client'],
                  'error_date': _dateController.text,
                  'error_updater_name': _updaterNameController.text,
                  'error_title': _titleController.text,
                  'desp': _descriptionController.text,
                };

                // Send an HTTP POST request to the PHP file with the updated data
                http.Response response = await http.post(
                  Uri.parse(
                      'http://192.168.226.232/d_shadowws_client/update_cli_project_error.php'),
                  body: updatedProjectError,
                );

                if (response.statusCode == 200) {
                  // Data updated successfully, go back to previous screen
                  Navigator.pop(context, updatedProjectError);
                } else {
                  // Show an error message
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Failed to update data')),
                  );
                }
              },
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
