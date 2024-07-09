import 'package:flutter/cupertino.dart';

class KeyBoard extends StatelessWidget{
  @override
  Widget build(BuildContext context){
    return Container(
        child: GridView(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 12),
          children: [
              Container(
                width: 50,
                height: 50,

              )

          ],


        ),





    );
  }
}