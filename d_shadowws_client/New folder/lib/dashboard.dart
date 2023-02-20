import 'package:flutter/material.dart';
import 'package:flutter_firebase/screens/signin_screen.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

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
    final prefs = await SharedPreferences.getInstance();
    final user_id = prefs.getString('user_id');
    final response = await http.get(
      Uri.parse('http://192.168.165.232/d_shadowws_client/getCount1.php'),
    );

    if (response.statusCode == 200) {
      final jsonData = response.body;
      setState(() {
        _projectsCount = int.parse(jsonData);
      });
    } else {
      await prefs.setString('user_id', null);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => SigninScreen()),
      );
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
                final prefs = await SharedPreferences.getInstance();
                await prefs.setString('user_id', null);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => SigninScreen()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
