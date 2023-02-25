import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../CompletedProjects.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  int _projectCount = 0;
 var _clientName;

  @override
  void initState() {
    super.initState();
    _getProjectCount();

  }

  Future<void> _getProjectCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final clientName=prefs.getString('client_name');

    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_5/cli_dash.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      _projectCount = int.parse(data['count']);
      _clientName= clientName;

    });
  }



  @override
  Widget build(BuildContext context) {
    return Row(
      children: [SizedBox(height: 120),
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
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
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(16),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey.shade300,
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>completedproject()));
                  },
                  child: Column(
                    children: [
                      Text(
                        "Completed Project",
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "$_projectCount",
                        style: TextStyle(fontSize: 24,color: Colors.black),
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
              color: Colors.grey.shade300,
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
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                TextButton(
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.all(16),
                    ),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(
                      Colors.grey.shade300,
                    ),
                    overlayColor: MaterialStateProperty.all<Color>(
                      Colors.grey.withOpacity(0.5),
                    ),
                  ),
                  onPressed: () {

                  },
                  child: Column(
                    children: [
                      Text(
                        "Client Name",
                        style: TextStyle(fontSize: 16,color: Colors.black),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "$_clientName",
                        style: TextStyle(fontSize: 24,color: Colors.black),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
