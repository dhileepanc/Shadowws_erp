import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_firebase/CompletedProjects.dart';
import 'package:flutter_firebase/ongoingprojects.dart';
import 'package:flutter_firebase/screens/AboutUs.dart';
import 'package:flutter_firebase/screens/Settings.dart';
import 'package:flutter_firebase/screens/Topscard.dart';
import 'package:flutter_firebase/screens/signin_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'my_drawer_header.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Colors.red,
      ),
      body: ListView(
        children: [
          TopCard(),
        ]
        /* Center(
          child: Text('Number of projects: $_projectCount'),
        )*/
        ,
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            MyHeaderDrawer(),
            ListTile(onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=>Dashboard()));
            },
              leading: Icon(
                Icons.home,
                color: Colors.grey,
              ),
              title: (Text(
                'Home',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>completedproject()));
              },
              leading: Icon(
                Icons.mail,
                color: Colors.grey,
              ),
              title: (Text(
                'Completed Project',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>onGoingProject()));
            },
              leading: Icon(
                Icons.outgoing_mail,
                color: Colors.grey,
              ),
              title: (Text(
                'Ongoing Project',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>Setting()));
            },
              leading: Icon(
                Icons.settings,
                color: Colors.grey,
              ),
              title: (Text(
                'Setting',
                style: TextStyle(color: Colors.white),
              )),
            ),
            ListTile(onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>AboutUs()));
            },
              leading: Icon(
                Icons.contact_page,
                color: Colors.grey,
              ),
              title: (Text(
                'About Us',
                style: TextStyle(color: Colors.white),
              )),
            ),ListTile(onTap: () async{
              final prefs = await SharedPreferences.getInstance();
              await prefs.setString('user_id', null);
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => SigninScreen()),
              );
            },
              leading: Icon(
                Icons.logout,
                color: Colors.grey,
              ),
              title: (Text(
                'Log Out',
                style: TextStyle(color: Colors.white),
              )),
            )

            // add more ListTiles for additional options
          ],
           ),
        backgroundColor: Colors.transparent.withOpacity(0.3),),
    );
  }
}
