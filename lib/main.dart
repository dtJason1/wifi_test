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
  void popup(){
    showDialog(context: context,
        builder: (context){
          return Dialog(

            child:
              Padding(
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
                        children: [],

                      ),
                    ),
                  ],
                ),
              ),
            )
          );
        }
    );

  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [
          Consumer<WifiProvider>(
            builder: (context, provider,child) {
              return Container(
                width: 1200,
                height: 800,
                child: Column(

                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    ElevatedButton(onPressed: (){setState(() {
                      isSelected = true;
                      provider.changeWifiList();
                    });}, child: Text("hi")),

                  ],
                ),
              );
            }
          ),
          isSelected ? Consumer<WifiProvider>(
            builder: (context, provider, child) {
              return Center(
                child: GestureDetector(
                  onTap: (){setState(() {
                    isSelected = false;
                  });},
                  child: Container(child:Padding(
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
                              children: provider.wifiList,

                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                    ,),
                ),
              );
            }
          ) : Container()
        ],
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
  String myPW = "";
  late TextEditingController _controllerText;
  bool shiftEnabled = false;
  bool isNumericMode = false;
  bool _show = false;
  @override
  void initState() {
    _controllerText = TextEditingController();
    super.initState();
  }
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
                      child: GestureDetector(
                        onTap: (){setState(() {
                          _show = true;
                        });},
                        child: Container(
                          width: 200,
                          height: 40,
                        ),
                      )
                    )
                  ],
                ),


                TextButton(onPressed: () async{
                  try {
                    print("${widget.text }, , ${myPW}");
                    await Process.run('nmcli',['device', 'wifi', 'connect', '${widget.text}', 'password', '$myPW']).then((value) => Navigator.of(context).pop());


                  } on Exception catch (e) {
                    print(e);
                    // TODO
                  }
                }, child: Text("confirm")),
                AnimatedContainer(duration: Duration(seconds: 1),
                  color: Colors.deepPurple,
                  child: VirtualKeyboard(
                      height: _show ? 300 : 0,
                      //width: 500,
                      textColor: Colors.white,
                      textController: _controllerText,
                      //customLayoutKeys: _customLayoutKeys,
                      defaultLayouts: [
                        VirtualKeyboardDefaultLayouts.English
                      ],
                      //reverseLayout :true,
                      type: isNumericMode
                          ? VirtualKeyboardType.Numeric
                          : VirtualKeyboardType.Alphanumeric,
                      onKeyPress: _onKeyPress),
                )

              ],),
          ),
        );

      }
      );

    },
      child: Text(widget.text, style: TextStyle(color: this.widget.iscurrentuse ? Colors.blue : Colors.black),),
    );
  }
  _onKeyPress(VirtualKeyboardKey key) {
    if (key.keyType == VirtualKeyboardKeyType.String) {
      myPW = myPW + ((shiftEnabled ? key.capsText : key.text) ?? '');
    } else if (key.keyType == VirtualKeyboardKeyType.Action) {
      switch (key.action) {
        case VirtualKeyboardKeyAction.Backspace:
          if (myPW.length == 0) return;
          myPW = myPW.substring(0, myPW.length - 1);
          break;
        case VirtualKeyboardKeyAction.Return:
          myPW = myPW + '\n';
          break;
        case VirtualKeyboardKeyAction.Space:
          myPW = myPW + (key.text ?? '');
          break;
        case VirtualKeyboardKeyAction.Shift:
          shiftEnabled = !shiftEnabled;
          break;
        default:
      }
    }
    // Update the screen
    setState(() {
      myPW = myPW;

    });
  }
}