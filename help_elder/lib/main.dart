// import 'package:firebase_messaging/firebase_messaging.dart';
// ignore_for_file: constant_identifier_names

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:help_elder/login.dart';
import 'package:help_elder/cadastro_resp.dart';
import 'package:help_elder/cadastro_func.dart';
import 'package:help_elder/home.dart';
import 'package:help_elder/cadastro_veio.dart';
import 'package:help_elder/chat.dart';
import 'package:help_elder/estoque.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
const bool DEBUG = true;


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Received a background message: ${message.messageId}"); 
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  getBackVar();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  
  runApp(MaterialApp(
    home: DEBUG ? const Test() : const Home(),
    debugShowCheckedModeBanner: DEBUG,
    routes: <String, WidgetBuilder>{
      '/home': (context) =>  const Home(),
      '/login': (context) => const Login(),
      '/cadResp': (context) => const CadastroResp(),
      '/cadFunc': (context) => const CadastroFunc(),
      '/cadVeio': (context) => const CadastroVeio(),
      '/chat': (context) => Chat(),
      '/estoque': (context) => const Inventory(),
    },
  ));
}
void getBackVar() async {
  final prefs = await SharedPreferences.getInstance();
  print("Login type: ${prefs.getInt("typeAccount")}");
  print("Can reload? ${prefs.getBool("reload")}");
}
class Test extends StatelessWidget {
  const Test({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('Tela de debug'),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text("Login"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadResp');
                },
                child: const Text("Cadastro de Responsável"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadFunc');
                },
                child: const Text("Cadastro de Funcionário"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/home');
                },
                child: const Text("Home"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/cadVeio');
                },
                child: const Text("Cadastro de veio"),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/chat');
                },
                child: const Text("chat"),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(context, '/estoque'),
                child: const Text("Estoque")
              ),
               ElevatedButton(
                onPressed: () {
                  getBackVar();
                },
                child: const Text("Ver tipo de login")
              ),
              ElevatedButton(
                onPressed: () {
                  auth.signOut();
                  print("saiu");
                },
                child: const Text("Sair")
              ),
            ],
          ),
        ),
      )
    );
  }
}

