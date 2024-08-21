import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  static const Key elevatedButtonKey = Key("Home_elevatedButtonKey");
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [

            ElevatedButton(
              key: Home.elevatedButtonKey,
              onPressed: () => {

              },
              child: Text("WIFI"),

            ),  Positioned(
              top: 150,
              child: Container(color: Colors.black, height: 50, width: 800,),),

          ],
        ),
      ),
    );


  }


}