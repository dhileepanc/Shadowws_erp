import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/projecterror.dart';
import 'package:flutter_firebase/screens/projectupdate.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'project_status.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  int _projectCount = 0;
  int _projectupdates = 0;
  int _projectErrors = 0;
  int _pendingTasks = 0;

  @override
  void initState() {
    super.initState();
    _getProjectCount();
  }

  Future<void> _getProjectCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');

    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_6/cli_dash.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    await prefs.setString('project_id', data['project_id']);
    await prefs.setString('team_leader_id', data['team_leader_id']);
    await prefs.setString('team', data['team']);
    setState(() {
      _projectCount = int.parse(data['count']);
      _projectupdates = int.parse(data['updates']);
      _projectErrors = int.parse(data['errors']);
      _pendingTasks = int.parse(data['opentask']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
      CrossAxisAlignment.stretch, // stretch the children to fill the width
      children: [
        // first row
        SizedBox(height: 20),
        Row(
          children: [
            Expanded(

              child: Container(
                decoration: BoxDecoration(
                    // outer border colour1
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(begin: Alignment.topLeft,
                      end: Alignment.bottomRight,colors: [Colors.red, Colors.purple]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(16),//box outer size1
                child: Column(
                  children: [ Text(
                    "Completed Project",
                    style: TextStyle(fontSize: 25, color: Colors.white),
                  ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15), // box hieght
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Colors.lightGreen.withOpacity(0) //inner colour1
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectStatus()));
                      },
                      child: Column(
                        children: [

                          SizedBox(height: 8),
                          Text(
                            "$_projectCount",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
            SizedBox(width: 20),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // outer border colour1
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(begin: Alignment.topLeft,
                      end: Alignment.bottomRight,colors: [Colors.red, Colors.purple]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(27.5),
                child: Column(
                  children: [Text(
                    "Updates",
                    style: TextStyle(fontSize: 29, color: Colors.white),
                  ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15),
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange.withOpacity(0),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectUpdate()));
                      },
                      child: Column(
                        children: [

                          SizedBox(height: 8),
                          Text(
                            "$_projectupdates",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 16),
        SizedBox(height: 16),
        Row(
          children: [
            SizedBox(height: 120),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // outer border colour1
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(begin: Alignment.topLeft,
                      end: Alignment.bottomRight,colors: [Colors.red, Colors.purple]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(27.5),
                child: Column(
                  children: [ Text(
                    "Errors",
                    style: TextStyle(fontSize: 30, color: Colors.white),
                  ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15),
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.orange.withOpacity(0),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ProjectError()));
                      },
                      child: Column(
                        children: [

                          SizedBox(height: 8),
                          Text(
                            "$_projectErrors",
                            style: TextStyle(fontSize: 30, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  // outer border colour1
                  borderRadius: BorderRadius.circular(10),
                  gradient: LinearGradient(begin: Alignment.topLeft,
                      end: Alignment.bottomRight,colors: [Colors.red, Colors.purple]),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                padding: EdgeInsets.all(22.2),
                child: Column(
                  children: [ Text(
                    "Pending Task",
                    style: TextStyle(fontSize: 24, color: Colors.white),
                  ),
                    TextButton(
                      style: ButtonStyle(
                        padding: MaterialStateProperty.all<EdgeInsets>(
                          EdgeInsets.all(15),
                        ),
                        shape:
                        MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        backgroundColor: MaterialStateProperty.all<Color>(
                          Colors.lightGreen.withOpacity(0),
                        ),
                        overlayColor: MaterialStateProperty.all<Color>(
                          Colors.grey.withOpacity(0.5),
                        ),
                      ),
                      onPressed: () {},
                      child: Column(
                        children: [

                          SizedBox(height: 8),
                          Text(
                            "$_pendingTasks",
                            style: TextStyle(fontSize: 24, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}


