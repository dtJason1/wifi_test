import 'package:flutter/material.dart';
import 'dart:io';
void main() {
  runApp(const MyApp());
}

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
  List<StatelessWidget> finalList = [];
  Future<List<dynamic>> scanWifi() async {
    try {
      // Run the command
      var result = await Process.run('iwlist',['wlan0', 'scan']);

      // Check for errors
      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
        return [];
      }
      // Filter SSIDs
      var ssids = result.stdout.toString().replaceAll("  ", "").split('\n' ).where((line) => line.toString().contains('SSID')).toList();
      ssids.forEach((element) {
        element = element.replaceAll("ESSID:", "").replaceAll(r'"', '');
        finalList.add(MyButton(text: element));

        print(element);
      });
      return finalList;
      // Print or return the SSIDs
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void popup(){
    showDialog(context: context,
        builder: (context){
          return Dialog(
            child:
              FutureBuilder(future: scanWifi(), builder: (BuildContext context, AsyncSnapshot snapshot){
                if (snapshot.hasData == false) {
                  return CircularProgressIndicator();
                }
                else{
                  return SingleChildScrollView(
                    child: Column(
                      children: snapshot.data,

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
        height: 8000,
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(onPressed: scanWifi, child: Text("hi")),

          ],
        ),
      ),
 );
  }
}


class MyButton extends StatelessWidget{
  MyButton({required this.text});
  final String text;
  @override
  Widget build(BuildContext context){
    return TextButton(onPressed: (){},
      child: Text(text),
    );


  }


}