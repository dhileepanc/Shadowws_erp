import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class MyHeaderDrawer extends StatefulWidget {
  @override
  _MyHeaderDrawerState createState() => _MyHeaderDrawerState();
}

class _MyHeaderDrawerState extends State<MyHeaderDrawer> {

  var _clientName;
  var _clientEmail;

  @override
  void initState() {
    super.initState();
    _getProjectCount();

  }

  Future<void> _getProjectCount() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getString('user_id');
    final clientName=prefs.getString('client_name');
    final clientEmail=prefs.getString('client_email');
    final response = await http.get(
      Uri.parse(
          'http://192.168.0.14/d_shadowws_client_5/getCount1.php?user_id=$userId'),
      headers: {'Content-Type': 'application/json'},
    );
    print(response.body);

    setState(() {

      _clientName= clientName;
      _clientEmail= clientEmail;

    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 70,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: AssetImage('images/shadowws.jpg'),
              ),
            ),
          ),
          Text(
            "$_clientName",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          Text(
            "$_clientEmail",
            style: TextStyle(
              color: Colors.grey[200],
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
