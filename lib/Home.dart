import 'package:flutter/material.dart';

class Home extends StatelessWidget{
  static const Key elevatedButtonKey = Key("Home_elevatedButtonKey");
  @override
  Widget build(BuildContext context){
    return MaterialApp(
      home: Scaffold(
        body: ElevatedButton(
          key: Home.elevatedButtonKey,
          onPressed: () => {

          },
          child: Text("WIFI"),
      
        ),
      ),
    );


  }


}