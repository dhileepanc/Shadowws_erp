import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '../color_utils.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'home_screen.dart';
import 'signup_screens.dart';
import 'package:http/http.dart' as http;

class SigninScreen extends StatefulWidget {
  const SigninScreen({super.key});

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();

  Future login() async{
    var url =Uri.parse("http://192.168.0.14/shadowwws/login.php");
    var response = await http.post(url,body:{
      "u_name":_emailTextController.text,
      "password":_passwordTextController.text,

    });
    var data =json.decode(response.body);
    if(data == "Success")
      {
        Fluttertoast.showToast(
          msg:'Login Successful',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,
          backgroundColor: Colors.green,
          textColor: Colors.white,
          fontSize: 16,
        );
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
      }
    else{
      Fluttertoast.showToast(
          msg:'Username or password incorrect',
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.CENTER,timeInSecForIosWeb: 1,
          backgroundColor: Colors.red,
          textColor: Colors.white,
          fontSize: 16,);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(colors: [
            hexStringToColor('CB2B93'),
            hexStringToColor('9546C4'),
            hexStringToColor('5E61F4'),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
        ),
        child: SingleChildScrollView(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              20, MediaQuery.of(context).size.height * 0.2, 20, 0),
          child: Column(
            children: [
              logoWidget('images/logo1.png'),
              const SizedBox(
                height: 30,
              ),
              ReusableTextField('Enter UserName', Icons.person_outline, false,
                  _emailTextController),
              const SizedBox(
                height: 30,
              ),
              ReusableTextField(
                'Enter Password',
                Icons.lock_outline,
                true,
                _passwordTextController,
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
                  builder: (context) => SignUpScreen(),
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
