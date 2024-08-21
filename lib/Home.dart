import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  static const Key elevatedButtonKey = Key("Home_elevatedButtonKey");
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            Positioned(
              top: 50,
              child: Container(color: Colors.black, height: 50, width: 800,),),
            ElevatedButton(
              key: Home.elevatedButtonKey,
              onPressed: () => {

              },
              child: Text("WIFI"),

            ),
          ],
        ),
      ),
    );


  }


}