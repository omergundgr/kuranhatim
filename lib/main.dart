import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kuranhatim/screens/anasayfa_screen.dart';
import 'package:kuranhatim/screens/karsilama_screen.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseAuth.instance.signInAnonymously();
  await Hive.initFlutter();
  runApp(MyApp());
}

Future<bool> _isimKayitSorgula() async {
  var box = await Hive.openBox("hatimflutter");
  return box.keys.contains("isim");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
        debugShowCheckedModeBanner: false,
        home: FutureBuilder<bool>(
          future: _isimKayitSorgula(),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return snapshot.data == true ? AnaSayfa() : KarsilamaEkrani();
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          },
        ));
  }
}
