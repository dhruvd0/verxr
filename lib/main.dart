import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:verxr/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
//  runApp(const MyApp());
}



/// TODO: registration bloc setup
/// TODO: firebase phone auth
/// TODO: Theme setup
///TODO: Firebase Config/ Mock
/// TODO: Integration Test Setup
/// 