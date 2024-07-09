import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
import 'dart:io';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'package:provider/provider.dart';
class KeyBoardKey extends ChangeNotifier{
  String _key = '';
  String get key => _key;

  void addKey (String insertedKey){
    _key = insertedKey;
    notifyListeners();

  }
  void clearKey(){
    _key =  '';
    notifyListeners();

  }

}

class WifiProvider extends ChangeNotifier{
  List<Widget> _wifiList =  [];
  List<Widget> get wifiList => _wifiList;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
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
      print("====get sssids");
      print(ssids);
      print("===========");


      ssids.removeAt(0);
      List<Widget> currentWIFIList = [];
      for (var ssid in ssids) {
        if(ssid[0] == '*'){
          currentWIFIList = [MyButton(text: ssid.substring(26,56).replaceAll(" ", ""), iscurrentuse: true)];
        }
        else{
          finalList.add(MyButton(text: ssid.substring(25,55).replaceAll(" ", ""), iscurrentuse: false));
        }
      }
      currentWIFIList.addAll(finalList);
      print(currentWIFIList);

      return currentWIFIList;

      // Print or return the SSIDs
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void changeWifiList() async{
    print("-======scanning wifi");
    _wifiList = await scanWifi();
    _isLoading = false;
    print("-======notifying=====");

    notifyListeners();
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

  void dialog2(){

      //Notice the use of ChangeNotifierProvider<ReportState>.value
      //   child: Dialog(
      //     child: SizedBox(
      //       width: 300,
      //       height: 300,
      //       child: Column(
      //         children: [
      //           Row(
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text("SSID"),
      //               ),
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text(widget.text),
      //               ),
      //             ],
      //           ),
      //
      //           Row(
      //             children: [
      //               Padding(
      //                 padding: const EdgeInsets.all(8.0),
      //                 child: Text("Password"),
      //               ),
      //               Padding(
      //                   padding: const EdgeInsets.all(8.0),
      //                   child: GestureDetector(
      //                     onTap: (){setState(() {
      //                       _show = true;
      //                     });},
      //                     child: Container(
      //                       width: 200,
      //                       height: 40,
      //                       color: Colors.blueAccent,
      //                       child: Consumer<KeyBoardKey>(
      //                         builder: (context, key, child) {
      //                           return Text(key.key);
      //                         }
      //                       ),
      //                     ),
      //                   )
      //               )
      //             ],
      //           ),
      //           TextButton(onPressed: () async{
      //             try {
      //               print("${widget.text }, , ${myPW}");
      //               await Process.run('nmcli',['device', 'wifi', 'connect', '${widget.text}', 'password', '$myPW']).then((value){
      //                 print(value);
      //                 Navigator.of(context).pop();});
      //             } on Exception catch (e) {
      //               print(e);
      //               // TODO
      //             }
      //           }, child: Text("confirm")),
      //         ],),
      //     ),
      //   ),
      //

    showDialog(
        context: context,
        builder:(_) => Dialog2(text:widget.text) );

  }

  @override
  Widget build(BuildContext context){
    return TextButton(onPressed: (){
      dialog2();

    },
      child: Text(widget.text, style: TextStyle(color: this.widget.iscurrentuse ? Colors.blue : Colors.black),),
    );
  }

}

class Dialog2 extends StatelessWidget{
  Dialog2({required this.text});
  final String text;

  @override
  Widget build(BuildContext context){
    //Notice the use of ChangeNotifierProvider<ReportState>.value
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
                    child: Text(text),
                  ),
                ],
              ),

              Row(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Password"),
                  ),
                  Consumer<KeyBoardKey>(
                    builder: (context , keyboardkey, child) {
                      return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            width: 200,
                            height: 40,
                            color: Colors.blueAccent,
                            child: Text(keyboardkey.key),
                          )
                      );
                    }
                  )
                ],
              ),
              Consumer<KeyBoardKey>(
                builder: (context, keyboardkey, child) {
                  return TextButton(onPressed: () async{
                    try {
                      await Process.run('nmcli',['device', 'wifi', 'connect', '${text}', 'password', '${keyboardkey.key}']).then((value){
                        print(value);
                        Navigator.of(context).pop();});
                    } on Exception catch (e) {
                      print(e);
                      // TODO
                    }
                  }, child: Text("confirm"));
                }
              ),
            ],),
        ),
      );



  }


}