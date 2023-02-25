import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../color_utils.dart';
import '../dashboard.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController userNameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();


  bool isLoading = false;
  String errorMessage = '';
  Future<void> login() async {
    final userName = userNameController.text;
    final password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      // show error message if either field is empty
      showAlertDialog(context, 'Error', 'Please enter both username and password');
      return;
    }

  final response = await http.post(
      Uri.parse('http://192.168.0.14/d_shadowws_client_5/cli_login.php'), body: {
    'u_name': userName,
    'password': password,
  });


  final data = jsonDecode(response.body);

    if (data.containsKey('error')) {
      // show error message if login was unsuccessful
      showAlertDialog(context, 'Error', data['error']);
    } else {
      // save user_id to shared preferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_id', data['user_id']);
      await prefs.setString('client_name', data['client_name']);
      await prefs.setString('client_email', data['client_email']);


      // navigate to dashboard
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Dashboard()),
      );
    }
  }

  void showAlertDialog(BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor('#FF0000'),
            hexStringToColor('#4c4c4c'),
            hexStringToColor('#696969'),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              logoWidget('images/logo_shadowws_orginal.png'),
              const SizedBox(
                height: 110,
              ),
              ReusableTextField('Enter UserName', Icons.person_outline, false,
                  userNameController),
              const SizedBox(
                height: 30,
              ),
              ReusableTextField(
                'Enter Password',
                Icons.lock_outline,
                true,
                passwordController,
              ),
              const SizedBox(
                height: 30,
              ),
              ElevatedButton(
                onPressed: () {
                  login();
                },
                child: Text(
                  'LOG IN',
                  style: TextStyle(
                      color: Colors.black87, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.resolveWith((states) {
                      if (states.contains(MaterialState.pressed)) {
                        return Colors.black26;
                      }
                      return Colors.white;
                    }),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)))),
              ),
              SignUpOption()
            ],
          ),
        )),
      ),
    );
  }

  Row SignUpOption() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Dont have account?',
          style: TextStyle(color: Colors.white70),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeScreen(),
                ));
          },
          child: const Text(
            'Sign Up',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
    );
  }
}
