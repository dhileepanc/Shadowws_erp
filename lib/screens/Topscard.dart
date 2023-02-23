import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/dashboard.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {
  int _projectCount = 0;

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
          'http://192.168.0.14/d_shadowws_client_5/getCount1.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);
    final data = jsonDecode(response.body);
    setState(() {
      _projectCount = int.parse(data['count']);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dasboard'),
      ),
      body: Container(
        child:
          Text(" Completed Projects: $_projectCount",)

        ,)
        // Con Text(
        //   " Completed Projects: $_projectCount",
        //   style: TextStyle(fontSize: 24),
      //  ),
      //);
    );
  }
}
