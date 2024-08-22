import 'package:flutter/cupertino.dart';
import 'animation.dart';
import 'package:flutter/material.dart';

class UpperContainer extends StatelessWidget{
  final AnimationController animationController;
  UpperContainer({required this. animationController});
  @override
  Widget build(BuildContext context){
    return FadeInDemo(
      controller: animationController,
      child: Container(color: Colors.black, height: 50, width: 1200,  alignment: Alignment.center,child: Text("Hello", style: TextStyle(color: Colors.white , fontSize: 16),),),
    );


  }


}