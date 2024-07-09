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
        child: FileViewer(),
      ),

    );

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
                    width: 1200, // dialog에서 wifi list를 얻어온 다음,
                                  // wifi 로그인 dialog 에서 로그인 하면,  이전 dialog 는 업데이트,
                                  // dialog 에서 provider 를 못쓴는 것 같은데,
                    height: 800,
                    child: Column(

                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                          TextButton(child:  Text("hi"), onPressed: () async{

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


class FileViewer extends StatelessWidget {

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
                  IconButton(onPressed: wifiProvider.changeWifiList, icon: Icon(Icons.refresh))
                ],
              ),
            ),
            SizedBox(
              height: 300,
              width: 300,
              child: wifiProvider.wifiList == [] ? CircularProgressIndicator() : ListView(
                shrinkWrap: true,
                children: wifiProvider.wifiList,

              ),
            ),
          ],
        ),
      ),
    ),
  );
  }
}