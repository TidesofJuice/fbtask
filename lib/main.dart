import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'pages/login_page.dart';
import 'pages/dashboard_page.dart';
import 'pages/register_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: const FirebaseOptions(
      apiKey: "AIzaSyDubG2QTCD_cZ80PucUZ02qIZGG69LePOg",
      authDomain: "fbauth-fb861.firebaseapp.com",
      databaseURL:
          "https://fbauth-fb861-default-rtdb.europe-west1.firebasedatabase.app",
      projectId: "fbauth-fb861",
      storageBucket: "fbauth-fb861.firebasestorage.app",
      messagingSenderId: "1035462750605",
      appId: "1:1035462750605:web:dcabb2f930bd3b02a60dc4",
    ),
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'fbauth',
      initialRoute: '/',
      routes: {
        '/': (context) => AuthCheck(),
        '/register': (context) => RegisterPage(),
        '/dashboard': (context) => DashboardPage(),
      },
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          if (snapshot.hasData) {
            return DashboardPage();
          } else {
            return LoginPage();
          }
        } else {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
      },
    );
  }
}
