import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/MyHomepage.dart';
import 'provider.dart';
void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => WifiProvider(),
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: MyApp()
      ),
    ),
  );
}

// raspberry nmcli 설치됨
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),


    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

GlobalKey firstWIFIkey = GlobalKey();

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {


  late final AnimationController _animationController;
  bool isSelected = false;


  @override
  void initState(){

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 2500));
    _animationController.forward();

  }


  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0.0, 1.5),
    end: Offset(0.0,0.0),
  ).animate(CurvedAnimation(
    parent: _animationController,
    curve: Curves.easeInOut,
  ));


  //
  // void dialog(){
  //   var wifiProvider = Provider.of<WifiProvider>(context, listen: false);
  //
  //   showDialog(
  //     context: context,
  //     builder: (_) => ChangeNotifierProvider<WifiProvider>.value(
  //       value: wifiProvider,
  //       child: WifiListIndicator(),
  //     ),
  //   );
  // }




  @override
  Widget build(BuildContext context) {

    return Scaffold(

      body: Stack(
        children: [
          Consumer<WifiProvider>(
              builder: (context, provider,child) {
                return Stack(
                  children: [
                  Positioned(
                    top: 0,
                    child: FadeInDemo(
                      controller: _animationController,
                      child: Container(color: Colors.black, height: 50, width: 1200,),
                    ),
                  ),

                  Container(
                      width: 1200,
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          TextButton(child:  Text("WIFI"),
                            onPressed: () async{
                              try {
                                provider.changeWifiList();
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                              } on Exception catch (e) {
                                print(e);
                                // TODO
                              }
                              // dialog();
                            },
                          ),

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


class WifiListIndicator extends StatefulWidget {


  @override
  State<WifiListIndicator> createState() => _WifiListIndicatorState();
}

class _WifiListIndicatorState extends State<WifiListIndicator> {

  @override
  Widget build(BuildContext context) {
    List< MyButton> finalList = [];
    List< MyButton> currentWIFIList = [];
    var wifiProvider = Provider.of<WifiProvider>(context);

    for (var ssid in wifiProvider.wifiList) {
      if(ssid[0] == '*'){
        currentWIFIList = [
          MyButton(text: ssid.substring(26,56).replaceAll(" ", ""), iscurrentuse: true,wifiProvider: wifiProvider,)
        ];
      }
      else{
        finalList.add(MyButton(text: ssid.substring(25,55).replaceAll(" ", ""), iscurrentuse: false,wifiProvider: wifiProvider,));
      }
    }
    currentWIFIList.addAll(finalList);

    //   return Dialog(
    //
    //   child: Padding(
    //     padding: const EdgeInsets.all(10.0),
    //     child: SizedBox(
    //       height: 400,
    //       width: 400,
    //       child: Column(
    //
    //         children: [
    //           Padding(
    //             padding: const EdgeInsets.symmetric(vertical: 25.0),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.center,
    //               children: [
    //                 Text("WIFI Lists",style: TextStyle(fontWeight: FontWeight.bold),),
    //                 IconButton(
    //                     onPressed: wifiProvider.changeWifiList, icon: Icon(Icons.refresh))
    //               ],
    //             ),
    //           ),
    //           SizedBox(
    //             height: 300,
    //             width: 300,
    //             child: wifiProvider.wifiList == [] ? CircularProgressIndicator() : ListView(shrinkWrap: true, children: currentWIFIList,),
    //           ),
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return MainPage();
  }

}


class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late Timer _timer;
  @override
  void initState(){
    var wifiProvider = Provider.of<WifiProvider>(context);
    wifiProvider.changeWifiList();


    _timer = Timer.periodic(Duration(seconds: 3), (timer) {
      wifiProvider.changeWifiList();

    });
    super.initState();
  }
  void dispose(){
    _timer.cancel();
    super.dispose();



  }
  @override
  Widget build(BuildContext context) {
    List< MyButton> finalList = [];
    List< MyButton> currentWIFIList = [];
    var wifiProvider = Provider.of<WifiProvider>(context);

    for (var ssid in wifiProvider.wifiList) {
      if(ssid[0] == '*'){
        currentWIFIList = [
          MyButton(text: ssid.substring(26,56).replaceAll(" ", ""), iscurrentuse: true,wifiProvider: wifiProvider,)
        ];
      }
      else{
        finalList.add(MyButton(text: ssid.substring(25,55).replaceAll(" ", ""), iscurrentuse: false,wifiProvider: wifiProvider,));
      }
    }
    currentWIFIList.addAll(finalList);


    return Scaffold(
      body: Stack(
        children: <Widget>[

          GestureDetector(
            onTap: (){
              setState(() {

                Navigator.pop(context);
              });

            },
            child: Container(
              width: 1200,
              height: 1200,
              color: Color.fromRGBO(0, 0, 0, 0.6),



            ),

          ),
          Center(

              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Container(
                  color: Colors.white,
                  height: 400,
                  width: 400,
                  child: Column(

                    children: [
                      Consumer<WifiProvider>(
                        builder: (context, provider, child) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 25.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text("WIFI Lists",style: TextStyle(fontWeight: FontWeight.bold),),
                                IconButton(
                                    onPressed: provider.changeWifiList, icon: Icon(Icons.refresh))
                              ],
                            ),
                          );
                        }
                      ),
                      Consumer<WifiProvider>(
                        builder: (context,provider,child) {
                          return SizedBox(
                            height: 300,
                            width: 300,
                            child: provider.wifiList == [] ? CircularProgressIndicator() : ListView(shrinkWrap: true, children: currentWIFIList,),
                          );
                        }
                      ),
                    ],
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }
}



class FadeInDemo extends StatefulWidget {
  final Widget child;
  final AnimationController controller;
  FadeInDemo({required this.child, required this.controller});
  _FadeInDemoState createState() => _FadeInDemoState();
}

class _FadeInDemoState extends State<FadeInDemo> with TickerProviderStateMixin {
  late AnimationController _controller;
  late CurvedAnimation _curve;

  @override
  void initState() {
    _controller = AnimationController(vsync: this, duration: Duration(seconds: 1));
    _curve = CurvedAnimation(parent: widget.controller, curve: Curves.easeIn);
    widget.controller.forward();
  }

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset(0.0, -1.5),
    end: Offset(0.0,0.0),
  ).animate(CurvedAnimation(
    parent: widget.controller,
    curve: Curves.easeInOut,
  ));

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: FadeTransition(
          opacity: _curve,
          child: widget.child
      ),
    );
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }
}
