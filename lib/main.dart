import 'package:flutter/material.dart';
import 'dart:io';
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
    List<StatelessWidget> finalList = [];

    try {
      // Run the command
      await Process.run('nmcli',['device', 'wifi', 'rescan']);
      var result = await Process.run('nmcli',['device', 'wifi', 'list']);

      // Check for errors
      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
        return [];
      }
      print(result.stdout);
      // Filter SSIDs
      var ssids = result.stdout.toString().split('\n' );
      ssids.removeAt(0);
      for (var ssid in ssids) {
        if(ssid[0] == '*'){
          finalList.add(MyButton(text: ssid.substring(15,45), iscurrentuse: true));
        }
        else{
          finalList.add(MyButton(text: ssid.substring(15,45), iscurrentuse: false));

        }
        
      }

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
                  return SizedBox(
                    width: 200,
                      height: 200,
                      child: CircularProgressIndicator());
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


class MyButton extends StatelessWidget{
  MyButton({required this.text, required this.iscurrentuse});
  final String text;
  final bool iscurrentuse;
  @override
  Widget build(BuildContext context){
    return TextButton(onPressed: (){},
      child: Text(text, style: TextStyle(color: this.iscurrentuse ? Colors.blue : Colors.black),),
    );
  }
}