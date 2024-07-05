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
  int _counter = 0;





  String musicPath(String musicName){
    return '/home/wakefit_cc/frpi/assets/sounds/requestedsound/${musicName}';
  }

  void _play() async{

    // var result = await Process.run('ls', ['-l']);
    var result = await Process.run('iwlist',['wlan0', 'scan']);
    print(result.stdout[0]);
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
            ElevatedButton(onPressed: _play, child: Text("hi")),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
 );
  }
}
