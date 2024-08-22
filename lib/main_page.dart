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
  int startAnimationTime =1000;
  int endAnimationTime = 1000;
  int _animationTime = 500;
  bool playedOnce = true;

  @override
  void initState(){
    _animationTime = startAnimationTime;
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: _animationTime));
    startAnimation();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<SceneProvider>(context).addListener(() {
        if(Provider.of<SceneProvider>(context).isFirstPage && playedOnce){
          startAnimation();
          setState(() {
            playedOnce = false;

          });
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

