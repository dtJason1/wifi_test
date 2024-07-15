import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:wifi_test/main.dart';
class KeyBoardKey extends ChangeNotifier{
  String _key = '';
  String get key => _key;

  List _keyList = ['1','2','3','4','5','6','7','8','9','0',
    'q','w','e','r','t','y','u','i','o','p','Back',
    'a','s','d','f','g','h','j','k','l',"'",'Enter',
    'shift','z','x','c','v','b','n', 'm',',','.','?','shift',
    '&123', 'space', 'clear'];
  List get keyList => _keyList;


  List capsLockKeyList = ['1','2','3','4','5','6','7','8','9','0',
    'Q','W','E','R','T','Y','U','I','O','P','Back',
    'A','S','D','F','G','H','J','K','L',"'",'Enter',
    'shift','Z','X','C','V','B','N','M',',','.','?','shift',
    '&123', 'space', 'clear'];
  List normalKeyList = ['1','2','3','4','5','6','7','8','9','0',
    'q','w','e','r','t','y','u','i','o','p','Back',
    'a','s','d','f','g','h','j','k','l',"'",'Enter',
    'shift','z','x','c','v','b','n', 'm',',','.','?','shift',
    '&123', 'space', 'clear'];
  List specialKeyLists = ['1','2','3','4','5','6','7','8','9','0',
    '+','×','÷','=','/','_','<','>','[',']','Back',
    '!','@','#',r'$','%','^','&','*','(',")",'Enter',
    'shift','-',"'",'"',':',';',',', '`',r'\','|','?','shift',
    '&123', 'space', 'clear'];

  void capsLock(){
    _keyList = capsLockKeyList;
    notifyListeners();

  }
  void deCapsLock(){
    _keyList = normalKeyList;
    notifyListeners();

  }
  void specialKeyboard(){
    _keyList = specialKeyLists;
    notifyListeners();

  }


  void addKey (String insertedKey){
    _key += insertedKey;

    controller.text = _key;


    notifyListeners();

  }
  void clearKey(){
    _key =  '';
    controller.text = _key;

    notifyListeners();

  }
  void deleteKey(){

    if (_key != null && _key.length > 0) {
      List<String> splitedKeys = _key.split("");
      splitedKeys.removeLast();
      _key = splitedKeys.join();
    }
    controller.text = _key;

    notifyListeners();

  }

}

class WifiProvider extends ChangeNotifier{
  List<String> _wifiList =  [];
  List<String> get wifiList => _wifiList;

  bool _isLoading = true;
  bool get isLoading => _isLoading;
  Future<List<String>> scanWifi() async {
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

      ssids.removeAt(0);


      return ssids;

      // Print or return the SSIDs
    } catch (e) {
      print('Error: $e');
      return [];
    }
  }

  void changeWifiList() async{
    _wifiList = await scanWifi();
    _isLoading = false;

    notifyListeners();
  }


}



class MyButton extends StatefulWidget{
  MyButton({required this.text, required this.iscurrentuse, required this.wifiProvider});
  final WifiProvider wifiProvider;
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
          child:  Dialog2(text:widget.text, wifiProvider: widget.wifiProvider,),
        ),

    );

  }


  @override
  Widget build(BuildContext context){
    return  TextButton(onPressed: (){
      dialog2();

    },
      child: Text(widget.text, style: TextStyle(color: this.widget.iscurrentuse ? Colors.blue : Colors.black),),);


  }

}


TextEditingController controller = TextEditingController();


class Dialog2 extends StatefulWidget{
  Dialog2({required this.text, required this.wifiProvider});
  final String text;
  final WifiProvider wifiProvider;
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
                            child: Container(
                              height: 20,
                              width: 100,
                              child: TextFormField(
                                maxLines: 1,
                                decoration: InputDecoration(
                                  isDense: true,
                                  contentPadding: EdgeInsets.fromLTRB(5.0, 1.0, 5.0, 1.0),
                                ),
                                onTap:(){keyBoardDialog();},
                                controller: controller,                              ),
                            )
                        //      (){keyBoardDialog();}

                        );
                      }
                    )
                  ],
                ),
                Consumer2<KeyBoardKey,WifiProvider>(
                  builder: (context, keyboardkey, wifiProvider,  child) {
                    return TextButton(onPressed: () async{
                      try {


                        await Process.run('nmcli',['device', 'wifi', 'rescan']);
                        var result = await Process.run('nmcli',['device', 'wifi', 'list']);

                        Process.run('nmcli',['dev', 'wifi', 'connect', '${widget.text}', 'password', '${controller.text}']).then((value) {
                          print("controller text : ${controller.text}");
                          print("stdout ${value.stdout}");
                          print("err: ${value.stderr}");

                          if (value.stderr != null) {
                            if(value.stderr.toString().contains("property is invalid") || value.stderr.toString().contains("Secrets were required") ){
                              showDialog(context: context, builder: (context){
                                return Dialog(
                                  child: Container( width:300, height:300, child: Center(child: Text("password not matched", style: TextStyle(color: Colors.red),),)),
                                );
                              });
                            }
                            if(value.stderr.toString().contains("No network with SSID")){
                              showDialog(context: context, builder: (context){
                                return Dialog(
                                  child: Container( width:300, height:300, child: Center(child: Text("cannot get SSID", style: TextStyle(color: Colors.red),),)),

                                );


                              });

                            }
                          }
                          else{
                            widget.wifiProvider.changeWifiList();
                            Navigator.of(context).pop();
                          }

                          keyboardkey.clearKey();




                          }
                        );

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


class KeyBoardDialogue extends StatefulWidget{



  @override
  State<KeyBoardDialogue> createState() => _KeyBoardDialogueState();
}

class _KeyBoardDialogueState extends State<KeyBoardDialogue> {


  @override
  Widget build(BuildContext context){
    var key = Provider.of<KeyBoardKey>(context);

    return Dialog(
      alignment: Alignment.bottomCenter,
      child: Container(
          width: 700,
          height: 300,
          //
          // child: GridView.count(crossAxisCount: 11,
          //         children: List.generate(keyList.length, (index) => Key(keyboardkey: keyList[index])),
          child: Consumer<KeyBoardKey>(
            builder: (context ,provider, child) {
              return Column(
                children: [
                  Container(width:600, height: 60, child: Row(children: List.generate(10, (index) => Expanded(child: Key(keyboardkey: provider.keyList[index],)),),)),

                  Container(width:600, height: 60, child: Row(
                    children: [
                      Expanded(child: Row(children: List.generate(10, (index) => Expanded(child: Key(keyboardkey: provider.keyList[index+10],))))),
                      Key(keyboardkey: provider.keyList[20])
                    ],
                  )),

                  Padding(
                    padding: const EdgeInsets.only(left: 30.0),
                    child: Container(width:570, height: 60, child: Row(
                      children: [
                        Expanded(child: Row(children: List.generate(10, (index) => Expanded(child: Key(keyboardkey:provider. keyList[index+21],))))),
                        Key(keyboardkey: provider.keyList[31])
                      ],
                    )),
                  ),
                  Container(width:600, height: 60, child: Row(children: List.generate(12, (index) => Expanded(child: Key(keyboardkey:provider. keyList[index+32],)),),),),
                  Container(width:600, height: 60, child: Row(children: [
                    Key(keyboardkey: provider.keyList[44]),
                    Key(keyboardkey: provider.keyList[45]),
                    Key(keyboardkey: provider.keyList[46])
                  ],),)
                ],
              );
            }
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
  bool _isCapsLocked = false;
  bool _specialKeyboardState = false;
  @override
  Widget build(BuildContext context){

    return Consumer<KeyBoardKey>(
      builder: (context, provider, child) {
          return Container(
                width: (widget.keyboardkey == "Back" ||  widget.keyboardkey == "Enter")  ? 120: (widget.keyboardkey == "space") ? 500 : null,



                decoration: BoxDecoration(border: Border.all(color: Colors.black),
                    color: (widget.keyboardkey == "shift" || widget.keyboardkey == "&123" ) ? Colors.black : null

                ),
                alignment: Alignment.center,
                child: TextButton(onPressed: (){  
                  if(widget.keyboardkey == "Back") {
                    provider.deleteKey();
                  }
                  else if(widget.keyboardkey == "Enter"){
                    Navigator.pop(context);
                  }
                  else if(widget.keyboardkey == "space"){
                    provider.addKey(" ");
                  }
                  else if(widget.keyboardkey == "clear"){
                    provider.clearKey();
                  }
                  else if(widget.keyboardkey == "&123"){
                    setState(() {
                      if (!_specialKeyboardState) {
                        provider.specialKeyboard();
                        _specialKeyboardState  = !_specialKeyboardState;
                      }
                      else{
                        _specialKeyboardState  = !_specialKeyboardState;
                        provider.deCapsLock();
                      }
                    });                  }
                  else if(widget.keyboardkey == "shift"){
                    setState(() {
                      if (!_specialKeyboardState) {
                        _isCapsLocked  = !_isCapsLocked;
                        if(_isCapsLocked){
                          provider.capsLock();
                        }
                        else{
                          provider.deCapsLock();
                        }
                      }
                    });
                  }
                  else{

                    provider.addKey(widget.keyboardkey);
                  }
                 }, child: Text(widget.keyboardkey, style: TextStyle(fontSize: 12, color: (widget.keyboardkey == "shift" || widget.keyboardkey == "&123" ) ? Colors.white : null ),),),


            );
      }
    );

  }
}
