import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/upper_container.dart';
import 'provider.dart';
import 'animation.dart';
import 'wifi_indicator.dart';
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {


  late final AnimationController _animationController;
  bool isSelected = false;


  @override
  void initState(){

    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 1500));
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
                      child: UpperContainer(animationController: _animationController,)
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

