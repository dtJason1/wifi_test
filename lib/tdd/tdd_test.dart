import 'package:flutter/material.dart';

class MyHomepage extends StatefulWidget{

  static const Key usernameInputKey = Key('MyHomepage_usernameInputKey');
  static const Key passwordInputKey = Key('MyHomepage_passwordInputKey');
  static const Key loginButtonKey = Key('MyHomepage_loginButtonKey');

  @override
  State<MyHomepage> createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
  bool isLoginButtonEnabled = false;

  TextEditingController usernameController = TextEditingController();

  TextEditingController passwordController = TextEditingController();

  void _checkValue(){
    if(usernameController.text.isEmpty || passwordController.text.isEmpty) {
      setState(() {
        isLoginButtonEnabled = false;
      });
    } else{
      setState((){

        isLoginButtonEnabled = true;

      });

    }

  }

  @override
  Widget build(BuildContext context){
   return MaterialApp(
    title: "tdd",
    theme: ThemeData(

      primarySwatch: Colors.cyan
    ),
     home: Scaffold(

       appBar: AppBar(
         title: Text("tdd"),
       ),
       body: Column(
         children: [
           TextField(
             key: MyHomepage.usernameInputKey,
             controller: usernameController,
             decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: 'Username'

             ),
             onChanged:  (value) => _checkValue(),

           ),
           TextField(
             key: MyHomepage.passwordInputKey,
             controller: passwordController,
             obscureText: true,
             decoration: InputDecoration(
                 border: OutlineInputBorder(),
                 labelText: 'password'

             ),
             onChanged:  (value) => _checkValue(),
           ),
           ElevatedButton(
               key: MyHomepage.loginButtonKey,

               onPressed: isLoginButtonEnabled ? (){
                 print("hello world");

               } : null, child: Text('Login'))

         ],



       ),

     ),
   );
  }
}