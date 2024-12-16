import 'package:edywasacliente/checagem_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Staircase Cliente',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
       colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 5, 21, 126)),
        useMaterial3: true,
      ),
      home: const ChecagemPage()
    );
  }
}