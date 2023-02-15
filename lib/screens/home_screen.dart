
import 'package:flutter/material.dart';

import 'package:google_fonts/google_fonts.dart';

import '../reusable_widgets/reusable_widget.dart';



class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppStyle.mainColor,
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Home'),
        centerTitle: true,
        backgroundColor: AppStyle.mainColor,
      ),
    );
  }
}
