
import 'dart:convert';
import 'package:flutter/material.dart';

import '../CompletedProjects.dart';
import '../dashboard.dart';
import '../my_drawer_header.dart';

import '../ongoingprojects.dart';
import '../reusable_widgets/reusable_widget.dart';
import 'package:http/http.dart' as http;

import '../upcomingprojects.dart';




class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {


var currentPage = DrawerSections.dashboard;

  @override
  Widget build(BuildContext context) {
    var container;
    if (currentPage == DrawerSections.dashboard) {
      container = Dashboard();
    } else if (currentPage == DrawerSections.Completed_projects) {
      container = completedproject();
    } else if (currentPage == DrawerSections.On_going_Projects) {
      container = onGoingProject();
    } else if (currentPage == DrawerSections.Up_coming_Projects) {
      container = upComing();
    // } else if (currentPage == DrawerSections.settings) {
    //   container = SettingsPage();
    // } else if (currentPage == DrawerSections.notifications) {
    //   container = NotificationsPage();
    // } else if (currentPage == DrawerSections.privacy_policy) {
    //   container = PrivacyPolicyPage();
    // } else if (currentPage == DrawerSections.send_feedback) {
    //   container = SendFeedbackPage();
    }
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar(
        elevation: 0.0,
        title: Text('SHADOWWS CLIENT'),
        centerTitle: true,
        backgroundColor: Colors.red,
      ),
      body: container,
      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
      ),
    );
  }

 Widget  MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(top: 15),
      child: Column(
        children: [
          menuItem(1, "Dashboard", Icons.dashboard_outlined,
              currentPage == DrawerSections.dashboard ? true : false),
          menuItem(2, "Completed Projects", Icons.cases_sharp,
              currentPage == DrawerSections.Completed_projects ? true : false),
          menuItem(3, "On Going Projects", Icons.cases_sharp,
              currentPage == DrawerSections.On_going_Projects ? true : false),
          menuItem(4, "Up Coming Projects", Icons.cases_outlined,
              currentPage == DrawerSections.Up_coming_Projects ? true : false),
          // Divider(),
          // menuItem(5, "Settings", Icons.settings_outlined,
          //     currentPage == DrawerSections.settings ? true : false),
          // menuItem(6, "Notifications", Icons.notifications_outlined,
          //     currentPage == DrawerSections.notifications ? true : false),
          // Divider(),
          // menuItem(7, "Privacy policy", Icons.privacy_tip_outlined,
          //     currentPage == DrawerSections.privacy_policy ? true : false),
          // menuItem(8, "Send feedback", Icons.feedback_outlined,
          //     currentPage == DrawerSections.send_feedback ? true : false),
        ],
      ),
    );
  }
Widget menuItem(int id, String title, IconData icon, bool selected){
    return Material(
      color: selected ? Colors.grey[300]:Colors.transparent,
      child: InkWell(
        onTap: (){
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.dashboard;
            } else if (id == 2) {
              currentPage = DrawerSections.Completed_projects;
            } else if (id == 3) {
              currentPage = DrawerSections.On_going_Projects;
            } else if (id == 4) {
              currentPage = DrawerSections.  Up_coming_Projects;
            }
          });

        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                  child: Icon(
                    icon,
                    size: 20,
                    color: Colors.black,
                  ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 16,
                  ),
                ),
              )
            ],
          ),
        ),
      ),

    );
}
}

class DashboardPage {
}


enum DrawerSections {
  dashboard,
  Completed_projects,
  On_going_Projects,
  Up_coming_Projects,
  // settings,
  // notifications,
  // privacy_policy,
  // send_feedback,
}