import 'dart:math';

import 'package:firebase_auth_mocks/firebase_auth_mocks.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:uuid/uuid.dart';
import 'package:verxr/main.dart' as app;

MockFirebaseAuth mockAuth([
  String? uid,
]) {
  uid = uid ?? const Uuid().v4();
  var last = Random().nextInt(900000000);
  String phone = ('+91${1000000000 + last}');

  var email = '$uid@gmail.com';
  return MockFirebaseAuth(
    signedIn: true,
    mockUser: MockUser(
      uid: uid ?? '' '12',
      phoneNumber: phone,
      email: email,
    ),
  );
}

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('Test to Register as a new Individual ', (tester) async {
    final auth = mockAuth();
    await app.main(firebaseAuth: auth);

    await Future.doWhile(() async {
      await tester.pumpAndSettle();

      try {
        expect(find.text('Get Started'), findsOneWidget);
        return false;
      } catch (e) {
        return true;
      }
    });

    await tester.tap(find.textContaining('Next'));
    await tester.pumpAndSettle();

    await tester.enterText(
        find.byKey(const ValueKey('first-name-text-field')), auth.currentUser!.uid,);
    await tester.pumpAndSettle();
    await tester.enterText(
        find.byKey(const ValueKey('last-name-text-field')), 'test_last_name',);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Next'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('dob-selector')));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('12'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Next'));
    await tester.pumpAndSettle();

    final email = auth.currentUser!.email.toString();
    debugPrint(email);
    await tester.enterText(find.byKey(const ValueKey('email-text-field')), email);
    await tester.pumpAndSettle();
    await tester.tap(find.textContaining('Next'));
    await tester.pumpAndSettle();
  });
}
