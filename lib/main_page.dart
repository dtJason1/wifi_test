import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/upper_container.dart';
import 'provider.dart';
import 'animation.dart';
import 'wifi_indicator.dart';
import 'settings.dart';

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

  @override
  void initState(){
    _animationTime = startAnimationTime;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: _animationTime));

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {


      Provider.of<WifiProvider>(context).addListener(() {
        if((Provider.of<WifiProvider>(context).currentState < 2) && playedOnce){

          print("helloooooo");
          print(Provider.of<WifiProvider>(context).currentState );
          startAnimation();
          setState(() {
            playedOnce = false;

          });
        }

        if(!(Provider.of<WifiProvider>(context).currentState < 2)){

          Future.delayed(Duration(seconds: 3)).then((value){poppedAnimation(

              (){

                playedOnce = true;
              }

          );});

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
                          TextButton(child:  Text("WIFI"),
                            onPressed: () async{
                              try {
                                poppedAnimation((){

                                  provider.changeWifiList();
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => MainPage()));
                                  setState(() {
                                    playedOnce = true;
                                  });
                                  sceneProvider.changePage();


                                });

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