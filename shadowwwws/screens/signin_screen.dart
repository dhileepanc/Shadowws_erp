import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_session/flutter_session.dart';

import 'dashboard.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;
  String errorMessage = '';

  Future<void> login() async {
    setState(() {
      isLoading = true;
      errorMessage = '';
    });

    final response = await http.post(
      Uri.parse('http://192.168.0.14/d_shadowws_client/login.php'),
      body: {
        'u_name': userNameController.text.trim(),
        'password': passwordController.text.trim(),
      },
    );

    print(response.body);
    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);

      if (jsonData == 'Success') {
        await FlutterSession().set('user_id', jsonData['user_id']);

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Dashboard(),),
        );
      } else {
        setState(() {
          errorMessage = 'Invalid credentials';
        });
      }
    } else {
      setState(() {
        errorMessage = 'Something went wrong. Please try again latr.';
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextField(
              controller: userNameController,
              decoration: InputDecoration(
                labelText: 'User Name',
              ),
            ),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: 'Password',
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: isLoading ? null : login,
              child: isLoading
                  ? CircularProgressIndicator()
                  : Text('Login'),
            ),
            SizedBox(height: 16),
            Text(
              errorMessage,
              style: TextStyle(color: Colors.red),
            ),
          ],
        ),
      ),
    );
  }
}
