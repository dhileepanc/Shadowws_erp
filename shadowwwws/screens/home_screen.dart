import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'TopCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var curdate = DateFormat('d MMMM y').format(DateTime.now());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.black),
        elevation: 0.0,
        title: Text(
          'Dashboard',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.red,
        actions: [
          Container(
            height: 50,
            width: 120,
            child: TextField(
              decoration: InputDecoration(
                labelText: 'Search',
                prefixIcon: Icon(Icons.search),
              ),
            ),
          )
        ],
      ),
      drawer: Drawer(),
      // body: ListView(children: [
      //   myGridView(),
      //   SizedBox(height: 0,),
      //   myGridView2(),
      // ],)
      body: ListView(
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  'Dashboard',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  curdate,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Icon(Icons.today),
              )
            ],
          ),
          TopCard(),
        ],
      ),

    );
  }
}
