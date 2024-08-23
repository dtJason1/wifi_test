import 'package:flutter/animation.dart';
import 'package:flutter/material.dart';
import 'package:wifi_test/upper_container.dart';
import 'provider.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'settings.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with TickerProviderStateMixin {
  int startAnimationTime =START_ANIMATION_VALUE;
  int endAnimationTime = END_ANIMATION_VALUE;
  int _animationTime = 500;
  bool playedOnce = true;

  late AnimationController _animationController;
  void startAnimation() async{
    _animationController.forward();

  }


  void poppedAnimation(Function function)async{
    setState(() {
      _animationTime = startAnimationTime;
    });
    _animationController.reverse().then((value) => function());
    setState(() {
      _animationTime = endAnimationTime;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

//
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if(Provider.of<WifiProvider>(context).currentState < 2 ){
        Navigator.of(context).popUntil((route) => route.isFirst);
      }


    });
  }

  @override
  void initState(){
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds:_animationTime ) );
    var wifiProvider = Provider.of<WifiProvider>(context);
    Timer.periodic(Duration(seconds: 3), (timer) {
      wifiProvider.scanWifi();
    });
    super.initState();
  }
  void dispose(){
    super.dispose();

  }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
      body: Stack(
        children: <Widget>[

          Consumer<SceneProvider>(
            builder: (context, sceneProvider, child) {
              return GestureDetector(
                onTap: (){
                  setState(() {
                    poppedAnimation((){
                      sceneProvider.changePage();
                      Navigator.of(context).popUntil((route) => route.isFirst);


                    });

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
                                    onPressed: provider.scanWifi, icon: Icon(Icons.refresh))
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
                            child: provider.wifiList == [] ? CircularProgressIndicator() : ListView(shrinkWrap: true, children: provider.currentWIFIList,),
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

