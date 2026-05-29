import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'app.dart';
import 'firebase_options.dart';
import 'data/migration.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Uncomment below line once to migrate dummy data to Firestore,
  // then comment it back out.
  await migrateProductsToFirestore();

  runApp(const StyleApp());
}
