import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'dart:io';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';

import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'provider.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MyApp());
}

// raspberry nmcli 설치됨
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MultiProvider(
        providers: [

          ChangeNotifierProvider<WifiProvider>(create: (BuildContext context) => WifiProvider()),
          ChangeNotifierProvider<KeyBoardKey>(create: (BuildContext context) => KeyBoardKey()),

        ],
        child: MyHomePage(),
      ),


    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});



  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  bool isSelected = false;

  void dialog(){
    var wifiProvider = Provider.of<WifiProvider>(context, listen: false);

    showDialog(
      context: context,
      //Notice the use of ChangeNotifierProvider<ReportState>.value
      builder: (_) => ChangeNotifierProvider<WifiProvider>.value(
        value: wifiProvider,
        child: WifiListIndicator(),
      ),
    );
  }
  String myPW = "";
  late TextEditingController _controllerText;
  bool shiftEnabled = false;
  bool isNumericMode = false;
  bool _show = false;
  @override
  void initState(){
    _controllerText = TextEditingController();

    super.initState();

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [
          Consumer<WifiProvider>(
            builder: (context, provider,child) {
              return Stack(
                children: [
                    Container(
                    width: 1200,
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          TextButton(child:  Text("WIFI"), onPressed: () async{

                            provider.changeWifiList();
                            dialog();
                            },),

                      ],
                    ),
                  ),
                ],
              );
            }
          ),


        ],
      ),
 );
  }

}

final firstWifiListKey = GlobalKey();

class WifiListIndicator extends StatelessWidget {

  Widget build(BuildContext context) {

  //you can enable or disable listen if you logic require so
  var wifiProvider = Provider.of<WifiProvider>(context);
  return Dialog(

    child: Padding(
      padding: const EdgeInsets.all(10.0),
      child: SizedBox(
        height: 400,
        width: 400,
        child: Column(

          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 25.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("WIFI Lists",style: TextStyle(fontWeight: FontWeight.bold),),
                  IconButton(
                      onPressed: wifiProvider.changeWifiList, icon: Icon(Icons.refresh))
                ],
              ),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: wifiProvider.wifiList == [] ? CircularProgressIndicator() : ListView(shrinkWrap: true, children: wifiProvider.wifiList,),
            ),
          ],
        ),
      ),
    ),
  );
  }
}