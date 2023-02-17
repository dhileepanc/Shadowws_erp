import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class TopCard extends StatefulWidget {
  const TopCard({Key? key}) : super(key: key);

  @override
  State<TopCard> createState() => _TopCardState();
}

class _TopCardState extends State<TopCard> {

  int projectCount= 0;



  /*  Future<int> counts() async {
     var url = Uri.parse("http://192.168.0.14/d_shadowws_client/getCount.php");
     var response = await http.get(url, headers: {"ACCEPT":"application/json"});
     print(response.statusCode);
     print(response.body); // <-- print the response body
     if(response.statusCode == 200) {
      var jsonData = json.decode(response.body);
       print(jsonData);
       return jsonData;
     }
     return 0;
   }*/
/*  Future<int> counts() async {
    var url = Uri.parse("http://192.168.0.14/d_shadowws_client/getCount.php");
    var response = await http.get(url, headers: {"ACCEPT":"application/json"});
    print(response.statusCode);
    print(response.body);
    if(response.statusCode == 200) {
      try {
        var jsonData = json.decode(response.body);
        print(jsonData);
        return jsonData;
      } catch (e) {
        print("Error parsing JSON: $e");
      }
    }
    return 0;
  }

  @override
  void initState() {
    super.initState();
    counts().then((value) {
      setState(() {
        Counts = value;
      });
    });
  }*/
  /*Future<int> counts() async {
     var url = Uri.parse("http://192.168.0.14/d_shadowws_client/getCount.php");
     var response = await http.get(url, headers: {"ACCEPT":"application/json"});
     if(response.statusCode == 200) {
       var jsonData = json.decode(response.body);
       return jsonData['total'];
     }
     return 0;
   }*/


  @override
  Widget build(BuildContext context) {
    return
      //   Scaffold(
      //
      // );
      Container(
        height: 200,
        color: Colors.amber,
        child: Center(
          child: Text(" Count: $projectCount",
            style: TextStyle(fontSize: 24),),
        ),
      );
  }
}