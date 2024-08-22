import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
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

          Consumer<SceneProvider>(
            builder: (context, sceneProvider, child) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    sceneProvider.changePage();
                    Navigator.pop(context);
                  });

                },
                child: Container(
                  width: 1200,
                  height: 1200,
                  color: Color.fromRGBO(0, 0, 0, 0.6),



                ),

              );
            }
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

