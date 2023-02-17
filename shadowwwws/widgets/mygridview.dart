import "package:flutter/material.dart";

Widget myGridView() {
  return SingleChildScrollView(
    child: Container(
      height: 250,
        child:GridView.count(
          crossAxisSpacing: 10,
          crossAxisCount: 2,
          children: [
            Container(
              color: Colors.purple,
                child: Center(
                  child: Text('1'),
                )),

            Container(
              color: Colors.purple,
              child: Center(
                child: Text('2'),
              ),
            )
          ],

        ),

    ),
  );

}
