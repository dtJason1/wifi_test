import 'package:flutter/cupertino.dart';
import 'animation.dart';
import 'package:flutter/material.dart';
import 'provider.dart';
import 'package:provider/provider.dart';
class UpperContainer extends StatefulWidget{
  final AnimationController animationController;
  UpperContainer({required this. animationController});

  @override
  State<UpperContainer> createState() => _UpperContainerState();
}

class _UpperContainerState extends State<UpperContainer> {

  @override
  Widget build(BuildContext context){
    return FadeInDemo(
      controller: widget.animationController,
      child: Consumer<WifiProvider>(
        builder: (context,provider,child) {
          return Container(color: Colors.black, height: 50, width: 1200,  alignment: Alignment.centerRight,


            child:
            Builder(
              builder: (context) {

                if(provider.currentState == -1){
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(CupertinoIcons.xmark_circle, color: Colors.red,),
                      Container(width: 50,),
                      Text("Error! ${provider.status}", style: TextStyle(color: Colors.white , fontSize: 16),),

                    ],
                  );
                }

                else if(provider.currentState == 1){
                  return Icon(CupertinoIcons.checkmark_alt_circle, color: Colors.green,);

                }
                else{
                  return CircularProgressIndicator(color: Colors.white,);
                }

              }
            ),);
        }
      ),
    );


  }
}