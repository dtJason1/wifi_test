import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/upper_container.dart';
import 'provider.dart';
import 'animation.dart';
import 'wifi_indicator.dart';
import 'settings.dart';
import 'package:intl/intl.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}


class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {


  late final AnimationController _animationController;
  bool isSelected = false;
  int startAnimationTime =START_ANIMATION_VALUE;
  int endAnimationTime = END_ANIMATION_VALUE;
  int _animationTime = 500;
  bool playedOnce = true;

  String _timeData = "";
  @override
  void initState(){
    _animationTime = startAnimationTime;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: _animationTime));

    DateTime now = DateTime.now();
    String check_time(BuildContext context){ //context는 Snackbar용, 다른 방식으로 출력할거면 필요없음.
      var now = new DateTime.now(); //반드시 다른 함수에서 해야함, Mypage같은 클래스에서는 사용 불가능
      String formatDate = DateFormat('HH:mm').format(now); //format변경
      return formatDate;
    }
    Timer.periodic(Duration(seconds: 2), (timer) {
      setState(() {
        _timeData = check_time(context);
      });

    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {


      Provider.of<WifiProvider>(context).addListener(() {
        if((Provider.of<WifiProvider>(context).currentState < 2) ){


          print(Provider.of<WifiProvider>(context).currentState );

          if(playedOnce){
            startAnimation();
          }
          setState(() {
            playedOnce = false;
          });
          if(Provider.of<WifiProvider>(context).currentState != 0){
            Future.delayed(Duration(seconds: 2)).then((value){
              poppedAnimation((){

                playedOnce = true;

                setState(() {
                  Provider.of<WifiProvider>(context).clearWifi();

                });
              });});

          }

        }

      });


    });



  }

  void startAnimation() async{
    _animationController.forward();

  }


  void poppedAnimation(Function function)async{
    setState(() {
      _animationTime = endAnimationTime;
    });
    _animationController.value = 1;
    _animationController.reverse().then((value) => function());
    setState(() {
      _animationTime = startAnimationTime;
    });
  }

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
          Consumer2<WifiProvider, SceneProvider>(
              builder: (context, provider, sceneProvider, child) {
                return Stack(
                  children: [
                    Positioned(

                      child: UpperContainer(animationController: _animationController,)
                    ),

                    Container(
                      width: 1200,
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,

                            children: [
                              Text(_timeData,textAlign: TextAlign.center,style: new TextStyle(fontWeight: FontWeight.bold,fontSize: 25.0),),
                              IconButton(onPressed: (){
                                Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));


                              }, icon: Icon(Icons.wifi)),
                            ],
                          ),
                          TextButton(child:
                          Text("WIFI"),
                            onPressed: () async{
                              try {
                                if(playedOnce){
                                  provider.changeWifiList();

                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                                  setState(() {
                                    _animationController.value = 0;
                                    playedOnce = true;
                                  });


                                }

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

// 모든 에러는 상단 바에 기록, 잠시 표시되었다가 사라짐,
// 에러가 나면, 다시 와이파이 리스트로 돌아옴.