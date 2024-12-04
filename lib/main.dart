import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:floein_social_app/NavigationRoutes.dart';
import 'firebase_options.dart'; 
import 'package:floein_social_app/Screens/LoginRegister/LoginRegisterScreen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, 
    // Usa las opciones generadas automáticamente
  );

    // Habilitar persistencia offline
  FirebaseFirestore.instance.settings = const Settings(
    persistenceEnabled: true,
  );
  
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'JasiTok',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: LoginRegisterScreen.routeName,
      routes: routes,
    );
  }
}



Map<int, Color> color = {
  50: Color.fromRGBO(102, 28, 229, .1),
  100: Color.fromRGBO(102, 28, 229, .2),
  200: Color.fromRGBO(102, 28, 229, .3),
  300: Color.fromRGBO(102, 28, 229, .4),
  400: Color.fromRGBO(102, 28, 229, .5),
  500: Color.fromRGBO(102, 28, 229, .6),
  600: Color.fromRGBO(102, 28, 229, .7),
  700: Color.fromRGBO(102, 28, 229, .8),
  800: Color.fromRGBO(102, 28, 229, .9),
  900: Color.fromRGBO(102, 28, 229, 1),
};
