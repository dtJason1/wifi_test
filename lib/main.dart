import 'package:flutter/material.dart';
import 'dart:io';

import 'package:flutter/rendering.dart';
void main() {
  runApp(const MyApp());
}

// raspberry nmcli 설치됨
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});


  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List<Widget>> scanWifi() async {
    List<StatefulWidget> finalList = [];

    try {
      // Run the command
      await Process.run('nmcli',['device', 'wifi', 'rescan']);
      var result = await Process.run('nmcli',['device', 'wifi', 'list']);

      // Check for errors
      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
        return [];
      }
      // Filter SSIDs
      var ssids = result.stdout.toString().trim().split('\n');
      print(ssids);
      ssids.removeAt(0);
      List<Widget> currentWIFIList = [];
      for (var ssid in ssids) {
        if(ssid[0] == '*'){
          currentWIFIList = [MyButton(text: ssid.substring(26,56).replaceAll(" ", ""), iscurrentuse: true)];
        }
        else{
          print(ssid.length);

          finalList.add(MyButton(text: ssid.substring(25,55).replaceAll(" ", ""), iscurrentuse: false));

        }
      }
      currentWIFIList.addAll(finalList);

      return currentWIFIList;
      // Print or return the SSIDs
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }
// sdf
  void popup(){
    showDialog(context: context,
        builder: (context){
          return Dialog(

            child:
              FutureBuilder(future: scanWifi(), builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasData == false) {
                  return SizedBox(
                    width: 300,
                      height: 300,
                      child: CircularProgressIndicator());
                }
                else{
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: SizedBox(
                      height: 400,
                      child: Column(

                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: Text("WIFI Lists",style: TextStyle(fontWeight: FontWeight.bold),),
                          ),
                          SizedBox(
                            height: 300,
                            width: 300,
                            child: ListView(
                              shrinkWrap: true,
                              children: snapshot.data,

                            ),
                          ),
                        ],
                      ),
                    ),
                  );

                }
              }),
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Container(
        width: 1200,
        height: 800,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: popup, child: Text("hi")),

          ],
        ),
      ),
 );
  }
}


class MyButton extends StatefulWidget{
  MyButton({required this.text, required this.iscurrentuse});
  final String text;
  final bool iscurrentuse;

  @override
  State<MyButton> createState() => _MyButtonState();
}

class _MyButtonState extends State<MyButton> {
  String myText = "";

  @override
  Widget build(BuildContext context){
    return TextButton(onPressed: (){
      showDialog(context: context, builder:(context) {
        return Dialog(
          child: SizedBox(
            width: 300,
            height: 300,
            child: Column(
              children: [
              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("SSID"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(widget.text),
                  ),


                ],
              ),

              Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Password"),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(myText)
                    )
                  ],
                ),
                TextButton(onPressed: (){setState(() {
                   myText = "12345678";
                });}, child: Text("12345678"),),
                TextButton(onPressed: ()async{
                  var result = await Process.run('nmcli',['device', 'dev ', 'wifi', 'connect', '${widget.text}', 'password', '$myText']).then((value) => Navigator.of(context).pop());

                  

                }, child: Text("confirm"))
              ],),
          ),
        );

      }
      );

    },
      child: Text(widget.text, style: TextStyle(color: this.widget.iscurrentuse ? Colors.blue : Colors.black),),
    );
  }
}