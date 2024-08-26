import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
// import 'package:provider/provider.dart';
import 'dart:io';
import 'package:provider/provider.dart';
import 'package:wifi_test/main.dart';
import 'dart:async';

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

  int _currentState = 2;
  int get currentState => _currentState;

  String _status = "";
  String get status => _status;

  bool _isLoading = true;
  bool get isLoading => _isLoading;

  bool _isConnecting = false;
  bool get isConnecting => _isConnecting;

  bool _isNoWIFI = false;
  bool get isNoWIFI => _isNoWIFI;
  List<MyButton> _currentWIFIList =[];
  List<MyButton> get currentWIFIList => _currentWIFIList;

  void noWIFI(){
    _isNoWIFI = true;
    notifyListeners();
  }

  void hasWIFI(){
    _isNoWIFI = false;
    notifyListeners();
  }

  void clearWifi(){
    print("clear wifi started ====");
    _currentState = 2;
    _status = "";

    notifyListeners();
  }

  void setConnectStatus(){
    _currentState = 1;
    _isConnecting = false;
    hasWIFI();
    notifyListeners();
  }

  void whileConnectingStatus(){
    _isConnecting = true;
    _status ="";
    _currentState =0;
    notifyListeners();
  }

  void setStatus(String errorStatus){
    _currentState = -1;
    _status = errorStatus;
    _isConnecting = false;
    notifyListeners();


  }




  void scanWifi() async {
    List<MyButton> _selectedWIFI =[];
    List<MyButton> _anotherWIFI =[];

    bool _noWIFI = true;
    try {
      print("scanning wifi....");
      // Run the command
      await Process.run('nmcli',['device', 'wifi', 'rescan']);
      var result = await Process.run('nmcli',['device', 'wifi', 'list']);

      // Check for errors
      if (result.exitCode != 0) {
        print('Error: ${result.stderr}');
      }
      // Filter SSIDs
      var ssids = result.stdout.toString().trim().split('\n');

      ssids.removeAt(0);


      for (var ssid in ssids) {

        if(ssid[0] == '*'){
          _selectedWIFI = [
            MyButton(text: ssid.substring(26,56).replaceAll(" ", ""), iscurrentuse: true)
          ];
          _noWIFI = false;
        }
        else{
          _anotherWIFI.add(MyButton(text: ssid.substring(25,55).replaceAll(" ", ""), iscurrentuse: false));

        }
      }

      _selectedWIFI.addAll(_anotherWIFI);
      _currentWIFIList = _selectedWIFI;

      if(_noWIFI){
        noWIFI();
      }
      else{
        hasWIFI();
      }

      notifyListeners();
      // Print or return the SSIDs
    } catch (e) {
      print('Error: $e');

    }
  }



}


class SceneProvider extends ChangeNotifier{

  bool _isFirstPage = true;
  bool get isFirstPage => _isFirstPage;


  void changePage() async{
    _isFirstPage = !_isFirstPage;
    notifyListeners();
  }



}


class HeaderProvider extends ChangeNotifier{
  String _currentWIFI = "";
  String get currentWIFI => _currentWIFI;

  String _status = "";
  String get status => _status;

  void setCurrentWIFI(String string){
    _currentWIFI = string;
    notifyListeners();

  }

  void setStatus (String string){
    _status = string;
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
            ChangeNotifierProvider<KeyBoardKey>(create: (BuildContext context) => KeyBoardKey()),


          ],
          child:  Dialog2(text:widget.text),
        ),

    );

  }


  @override
  Widget build(BuildContext context){
    return  TextButton(onPressed: (){
      if(!widget.iscurrentuse) {
        dialog2();
      }

    },
      child: Text(widget.text, style: TextStyle(color: this.widget.iscurrentuse ? Colors.blue : Colors.black),),);


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

      showDialog(
        barrierColor: Color(0x01000000),
        context: context,
        builder:(_) => MultiProvider(
          providers: [
            ChangeNotifierProvider<KeyBoardKey>(create: (BuildContext context) => KeyBoardKey()),
          ],
          child:  KeyBoardDialogue(),
        ),
      );
    }

    // 화면위에 토스트 메세지( wifi 연결...., 핸드폰처럼
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
                                controller: controller,
                              ),
                            )
                        //      (){keyBoardDialog();}

                        );
                      }
                    )
                  ],
                ),
                Consumer3<KeyBoardKey,WifiProvider,SceneProvider>(
                  builder: (context, keyboardkey, wifiProvider,sceneProvider , child) {
                    return TextButton(onPressed: () async{

                      try {
                        int myPid = 0;
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        Navigator.of(context).popUntil((route) => route.isFirst);
                        wifiProvider.whileConnectingStatus();

                        print("popped!!!!");




                        Process.run('nmcli',['dev', 'wifi', 'connect', '${widget.text}', 'password', '${controller.text}'])
                          ..timeout(Duration(seconds: 15), onTimeout: (){

                            Process.run('nmcli',['radio', 'wifi', 'off']).whenComplete(() => Process.run('nmcli',['radio', 'wifi', 'on']).then((value) => wifiProvider.setStatus("Connection Time Out")));throw TimeoutException('Connection Time Out // 3');
                          })

                          ..then((value) {

                            print('pid: $pid');

                            print(widget.text);
                            print("controller text : ${controller.text}");
                            print("stdout ${value.stdout}");
                            print("err: ${value.stderr}");



                          if(value.stderr.toString().contains("property is invalid") || value.stderr.toString().contains("Secrets were required") || value.stderr.toString().contains("New connection activation was enqueued") ){
                            print("catch");
                            wifiProvider.setStatus("Invalid password");

                          }
                          else if(value.stdout.toString().contains("property is invalid") || value.stdout.toString().contains("Secrets were required")  ){
                            print("catch");
                            wifiProvider.setStatus("Invalid password");

                          }
                          else if (value.stdout.toString().contains("New connection activation was enqueued")){
                            wifiProvider.setStatus("New connection activation was enqueued. Please try again.");
                          }

                          else if(value.stderr.toString().contains("No network with SSID") || value.stdout.toString().contains("No network with SSID")  ){
                            wifiProvider.setStatus("No network with current SSID.");
                          }
                          else if (value.stdout.toString().contains("successfully activated")){
                              wifiProvider.setConnectStatus();
                          }

                          else{
                            wifiProvider.setStatus("Invalid password");

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
                  Padding(
                    padding: const EdgeInsets.only(right: 30.0),
                    child: Container(width:570, height: 60, child: Row(children: [
                      Key(keyboardkey: provider.keyList[44]),
                      Key(keyboardkey: provider.keyList[45]),
                      Key(keyboardkey: provider.keyList[46])
                    ],),),
                  )
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
                width: (widget.keyboardkey == "Back" ||  widget.keyboardkey == "Enter")  ? 120: (widget.keyboardkey == "space") ? 470 : null,



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
                  else if(widget.keyboardkey == "Space"){
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
