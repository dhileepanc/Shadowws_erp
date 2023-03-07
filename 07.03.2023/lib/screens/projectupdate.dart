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
  List<Map<String, dynamic>> projectUpdates = [];
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

  Future<void> updateData(int id, String updateDate, String updateUpdaterName,
      String updateTitle, String desp) async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    // Construct the URL for the PHP script
    String url =
        'http://192.168.0.14/d_shadowws_client_6/update_cli_project_update.php?id=$id&user_id=$userId';

    // Construct the HTTP POST request body
    Map<String, String> body = {
      'update_date': updateDate,
      'updater_name': updateUpdaterName,
      'update_title': updateTitle,
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

  Future<void> fetchProjectUpdates() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final response = await http.get(Uri.parse(
        'http://192.168.0.14/d_shadowws_client_6/cli_project_update.php?user_id=$userId'));
    print(response.body);
    if (response.statusCode == 200) {
      setState(() {
        projectUpdates =
        List<Map<String, dynamic>>.from(jsonDecode(response.body));
      });
    } else {
      throw Exception('Failed to fetch project errors');
    }
  }

  Future<void> deleteProjectUpdate(String id) async {
    final response = await http.delete(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_6/delete_cli_project_update.php?id=$id'),
    );
    print(id);
    if (response.statusCode == 200) {
      setState(() {
        projectUpdates.removeWhere((update) => update['id'] == id);
      });
    } else {
      throw Exception('Failed to delete project update');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: Text(
          'Project Update',
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
                        'update Date',
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
                        'update Title',
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
                for (var i = 0; i < projectUpdates.length; i++)
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
                          child: Text(projectUpdates[i]['project_name']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectUpdates[i]['update_date']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectUpdates[i]['updater_name']),
                        ),
                      ),
                      TableCell(
                        child: Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text(projectUpdates[i]['update_title']),
                        ),
                      ),
                      TableCell(
                        child: IconButton(
                          icon: Icon(Icons.edit),
                          onPressed: () {
                            // Populate the input fields with the selected project error's data
                            selectedProject = projectUpdates[i]['project_name'];
                            _dateController.text =
                            projectUpdates[i]['update_date'];
                            _updaterNameController.text =
                            projectUpdates[i]['updater_name'];
                            _titleController.text =
                            projectUpdates[i]['update_title'];
                            _descriptionController.text =
                            projectUpdates[i]['desp'];

                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: Text('Edit Project update'),
                                content: Container(
                                  height: 400,
                                  child: Column(
                                    children: [
                                      TextFormField(
                                        controller: _dateController,
                                        decoration: InputDecoration(
                                            labelText: 'update Date'),
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
                                            labelText: 'update Title'),
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
                                            labelText: 'update Description'),
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
                                        'id': projectUpdates[i]['id'],
                                        'project_name': selectedProject,
                                        'update_date': _dateController.text,
                                        'updater_name':
                                        _updaterNameController.text,
                                        'update_title': _titleController.text,
                                        'desp': _descriptionController.text,
                                      };
                                      await updateData(
                                          int.parse(projectUpdates[i]['id']),
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
                            deleteProjectUpdate(projectUpdates[i]['id']);
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
                  title: Text('Add Project update'),
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
                                  labelText: 'update Date',
                                ),
                                controller: _dateController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'update Updater Name',
                                ),
                                controller: _updaterNameController,
                              ),
                              TextField(
                                decoration: InputDecoration(
                                  labelText: 'update Title',
                                ),
                                controller: _titleController,
                              ),
                              TextField(
                                maxLines: 3,
                                decoration: InputDecoration(
                                  labelText: 'update Description',
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

