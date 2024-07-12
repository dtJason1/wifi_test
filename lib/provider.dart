import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
// import 'package:provider/provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
class KeyBoardKey extends ChangeNotifier{
  String _key = '';
  String get key => _key;

  void addKey (String insertedKey){
    if(_key.length >= 8){

    }
    else {
      _key += insertedKey;
    }
    print(_key);
    controller.text = _key;


    notifyListeners();

  }
  void clearKey(){
    _key =  '';
    controller.text = _key;

    notifyListeners();

  }

}

class WifiProvider extends ChangeNotifier{
  List<Widget> _wifiList =  [];
  List<Widget> get wifiList => _wifiList;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  Future<List<MyButton>> scanWifi() async {
    List<MyButton> finalList = [];

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
      List< MyButton> currentWIFIList = [];
      for (var ssid in ssids) {
        if(ssid[0] == '*'){
          currentWIFIList = [
            MyButton(text: ssid.substring(26,56).replaceAll(" ", ""), iscurrentuse: true)
            ];
        }
        else{
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
  String text;
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
    showDialog(
        context: context,
        builder:(_) => MultiProvider(
          providers: [
            ChangeNotifierProvider<WifiProvider>(create: (BuildContext context) => WifiProvider()),
            ChangeNotifierProvider<KeyBoardKey>(create: (BuildContext context) => KeyBoardKey()),
          ],
          child:  Dialog2(text:widget.text),
        ),

    );

  }


  @override
  Widget build(BuildContext context){
    return  MultiProvider(
      providers: [

        ChangeNotifierProvider<WifiProvider>(create: (BuildContext context) => WifiProvider()),
        ChangeNotifierProvider<KeyBoardKey>(create: (BuildContext context) => KeyBoardKey()),

      ],
      child: TextButton(onPressed: (){
        dialog2();

      },
        child: Text(widget.text, style: TextStyle(color: this.widget.iscurrentuse ? Colors.blue : Colors.black),),));


  }

}
TextEditingController controller = TextEditingController();


class Dialog2 extends StatefulWidget{
  Dialog2({required this.text});
  final String text;

  @override
  State<Dialog2> createState() => _Dialog2State();
}

class _Dialog2State extends State<Dialog2> {
  @override
  void initState(){
    super.initState();
  }
  @override
  Widget build(BuildContext context){
    //Notice the use of ChangeNotifierProvider<ReportState>.value
    void keyBoardDialog(){

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
        barrierColor: Color(0x01000000),
        context: context,
        builder:(_) => MultiProvider(
          providers: [
            ChangeNotifierProvider<WifiProvider>(create: (BuildContext context) => WifiProvider()),
            ChangeNotifierProvider<KeyBoardKey>(create: (BuildContext context) => KeyBoardKey()),
          ],
          child:  KeyBoardDialogue(),
        ),

      );

    }

    return Dialog(

          child: Container(
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
                    Consumer<KeyBoardKey>(
                      builder: (context , provider, child) {

                        return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: SizedBox(

                                width: 100, height: 20,

                                child: TextField(onTap:(){keyBoardDialog();},
                                  controller: controller,

                                ))

                        //      (){keyBoardDialog();}
                        );
                      }
                    )
                  ],
                ),
                Consumer2<KeyBoardKey,WifiProvider >(
                  builder: (context, keyboardkey, wifiProvider,  child) {
                    return TextButton(onPressed: () async{
                      try {
                        List<MyButton> currentuse = await wifiProvider.scanWifi();
                        String currentUseText = currentuse.first.text;

                        await Process.run('nmcli', ['con', 'delete', '${currentUseText}']);
                        await Process.run('nmcli',['device', 'wifi', 'connect', '${widget.text}', 'password', '${keyboardkey.key}']).then((value){

                          print(value.stdout);
                          print(" err: ${value.stderr}");
                          keyboardkey.clearKey();
                          Future.delayed(const Duration(seconds: 1)).then((value) {
                              wifiProvider.changeWifiList();
                              Navigator.of(context).pop();
                          });
                         });
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

List keyList =['1','2','3','4','5','6','7','8','9','0',
  'q','w','e','r','t','y','u','i','o','p',
'a','s','d','f','g','h','j','k','l',
'z','x','c','v','b'];
class KeyBoardDialogue extends StatelessWidget{
  @override
  Widget build(BuildContext context){

    return Dialog(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: 600,
          height: 300,

          child: GridView.count(crossAxisCount: 10,
                  children: List.generate(keyList.length, (index) => Key(keyboardkey: keyList[index])),
                  // children: [
                  //   // Key(keyboardkey: '1',),
                  //   // Key(keyboardkey: '2',),
                  //   // Key(keyboardkey: '3',),
                  //   // Key(keyboardkey: '4',),
                  //   // Key(keyboardkey: '5',),
                  //   // Key(keyboardkey: '6',),
                  //   // Key(keyboardkey: '7',),
                  //   // Key(keyboardkey: '8',),
                  //   // Key(keyboardkey: '9',),
                  //   // Key(keyboardkey: '0',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'w',),
                  //   // Key(keyboardkey: 'e',),
                  //   // Key(keyboardkey: 'r',),
                  //   // Key(keyboardkey: 't',),
                  //   // Key(keyboardkey: 'y',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   // Key(keyboardkey: 'q',),
                  //   //
                  //   // Key(keyboardkey: 'q',)
                  //
                  // ],
          ),

      )

    );
  }


}

class Key extends StatefulWidget{
  const Key({super.key, required this.keyboardkey});
  final String keyboardkey;

  @override
  State<Key> createState() => _KeyState();
}

class _KeyState extends State<Key> {
  @override
  Widget build(BuildContext context){

    return Consumer<KeyBoardKey>(
      builder: (context, provider, child) {
          return Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(border: Border.all(color: Colors.black)),
                alignment: Alignment.center,
                child: TextButton(onPressed: (){provider.addKey(widget.keyboardkey);}, child: Text(widget.keyboardkey),),


            );
      }
    );

  }
}


class KeyBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
      child:

      GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 10),
        children:
        [
          Key(keyboardkey: '1',),
          Key(keyboardkey: '2',),
          Key(keyboardkey: '3',),
          Key(keyboardkey: '4',),
          Key(keyboardkey: '5',),
          Key(keyboardkey: '6',),
          Key(keyboardkey: '7',),
          Key(keyboardkey: '8',),
          Key(keyboardkey: '9',),
          Key(keyboardkey: '0',),
          Key(keyboardkey: 'q',),
          Key(keyboardkey: 'w',),
          Key(keyboardkey: 'e',),
          Key(keyboardkey: 'r',),
          Key(keyboardkey: 't',),
          Key(keyboardkey: 'y',),
          Key(keyboardkey: 'u',),
          Key(keyboardkey: 'i',),
          Key(keyboardkey: 'o',),
          Key(keyboardkey: 'p',),
          Key(keyboardkey: 'a',),
          Key(keyboardkey: 's',),
          Key(keyboardkey: 'd',),
          Key(keyboardkey: 'f',),
          Key(keyboardkey: 'g',),
          Key(keyboardkey: 'h',),
          Key(keyboardkey: 'j',),
          Key(keyboardkey: 'k',),
          Key(keyboardkey: 'l',),
          Key(keyboardkey: 'z',),
          Key(keyboardkey: 'x',),
          Key(keyboardkey: 'c',),
          Key(keyboardkey: 'v',),
          Key(keyboardkey: 'b',),
          Key(keyboardkey: 'n',),
          Key(keyboardkey: 'm',),
          Key(keyboardkey: 'back',)
        ],
      ),
    );
  }
}
