import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  int _projectsCount = 0;

  @override
  void initState() {
    super.initState();
    getProjectsCount();
  }

  Future<void> getProjectsCount() async {
    dynamic token = await FlutterSession().get("token");
    final response = await http.get(
        Uri.parse('http://192.168.0.14/d_shadowws_client/getCount.php'),
        headers: {'Authorization': 'Bearer $token'});

    if (response.statusCode == 200) {
      setState(() {
        _projectsCount = int.parse(response.body);
      });
    } else {
      throw Exception('Failed to get projects count');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dashboard'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'You have $_projectsCount project(s)',
              style: TextStyle(fontSize: 24.0),
            ),
            ElevatedButton(
              child: Text('Log out'),
              onPressed: () async {
                await FlutterSession().set("token", "");
                Navigator.pushReplacementNamed(context, '/login');
              },
            )
          ],
        ),
      ),
    );
  }
}
