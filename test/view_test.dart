import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wifi_test/Home.dart';


void main() {
  group(
          'GIVEN the Home Page is open '
          'THEN I see a button ', () {
    testWidgets(
        'test',
            (WidgetTester tester) async {
          await tester.pumpWidget(Home());
          await tester.pump();


          expect(find.byKey(Home.elevatedButtonKey), findsOneWidget);

        });
  });

  group(
      'GIVEN the Button is Pressed '
      'THEN Dialog function starts', () {

    testWidgets(
        'test',
            (WidgetTester tester) async {
              await tester.pumpWidget(Home());
              await tester.pump();
              final WIFIbutton = tester.widget(find.byKey(Home.elevatedButtonKey)) as ElevatedButton;


              expect(WIFIbutton.onPressed, isNotNull);

        });
  });

  group(
      'GIVEN Dialog function finished'
      'THEN I see List of WIFI',
          () {

    testWidgets(
        'test',
            (WidgetTester tester) async {
          await tester.pumpWidget(Home());
          await tester.pump();
          final WIFIbutton = tester.widget(find.byKey(Home.elevatedButtonKey)) as ElevatedButton;


          expect(WIFIbutton.onPressed, isNotNull);

        });
  });
  group(
      'GIVEN the Button is Pressed '
          'THEN function starts',
          () {

        testWidgets(
            'test',
                (WidgetTester tester) async {
              await tester.pumpWidget(Home());
              await tester.pump();
              final WIFIbutton = tester.widget(find.byKey(Home.elevatedButtonKey)) as ElevatedButton;


              expect(WIFIbutton.onPressed, isNotNull);

            });
      });


}