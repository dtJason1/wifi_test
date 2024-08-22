import 'package:flutter/cupertino.dart';
import 'animation.dart';
import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:provider/provider.dart';
class UpperContainer extends StatelessWidget{
  final AnimationController animationController;
  UpperContainer({required this. animationController});
  @override
  Widget build(BuildContext context){
    return FadeInDemo(
      controller: animationController,
      child: Consumer<HeaderProvider>(
        builder: (context,provider,child) {
          return Container(color: Colors.black, height: 50, width: 1200,  alignment: Alignment.center,


            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [


                Text("current status :  ${provider.status}", style: TextStyle(color: Colors.white , fontSize: 16),),
                CircularProgressIndicator(color: Colors.white,)
              ],
            ),);
        }
      ),
    );


  }


}