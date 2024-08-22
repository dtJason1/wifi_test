import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wifi_test/tdd/tdd_test.dart';

void main() {
  group(
      'GIVEN the Home Page is open '
      'THEN I see a username input field '
      'AND I see a password input field '
      'AND I see a login button', () {
    testWidgets(
      'test',
     (WidgetTester tester) async {
        await tester.pumpWidget(MyHomepage());
        await tester.pump();
        
        expect(find.byKey(MyHomepage.usernameInputKey), findsOneWidget);
        expect(find.byKey(MyHomepage.passwordInputKey), findsOneWidget);
        expect(find.byKey(MyHomepage.loginButtonKey), findsOneWidget);
     });



  });
  group(
      'GIVEN the Home Page is open '
      'WHEN I type a value into the password field '
      'THEN I see the password is obscured ', () {
    testWidgets( 'test',

         (WidgetTester tester) async {
          await tester.pumpWidget(MyHomepage());
          await tester.pump();

          final passwordInput = tester.widget(find.byKey(MyHomepage.passwordInputKey)) as TextField;
          expect(passwordInput.obscureText, true);
     });
  });


  group(
      'GIVEN the Home Page is open '
      'WHEN I type a value into the password field '
      'AND I type a value into the password field '
      'THEN I see the login button is not disabled ',
          () {
        testWidgets( 'test', (WidgetTester tester) async {
          await tester.pumpWidget(MyHomepage());
          await tester.pump();

          await tester.enterText(find.byKey(MyHomepage.usernameInputKey), 'username');
          await tester.enterText(find.byKey(MyHomepage.passwordInputKey), 'password');
          await tester.pumpAndSettle();

          final loginButton = tester.widget(find.byKey(MyHomepage.loginButtonKey)) as ElevatedButton;
          expect(loginButton.onPressed, isNotNull);



        });



  });

}
