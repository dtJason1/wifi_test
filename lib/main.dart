import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'dart:io';
import 'package:virtual_keyboard_multi_language/virtual_keyboard_multi_language.dart';
import 'dart:async';

import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:wifi_test/tdd/tdd_test.dart';
import 'provider.dart';
import 'animation.dart';
import 'wifi_indicator.dart';
import 'main_page.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
void main() {
  initializeDateFormatting('ja_JP', null);

  runApp(

    MultiProvider(
      providers: [

        ChangeNotifierProvider<WifiProvider>(create: (BuildContext context) => WifiProvider()),
        ChangeNotifierProvider<SceneProvider>(create: (BuildContext context) => SceneProvider()),
        ChangeNotifierProvider<HeaderProvider>(create: (BuildContext context) => HeaderProvider()),


      ],
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData.light(),
          home: MyApp()
      ),
    ),

  );
}

// raspberry nmcli 설치됨
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),


    );
  }
}

