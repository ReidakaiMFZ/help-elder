import 'package:flutter/material.dart';
import 'package:help_elder/login.dart';
import 'package:help_elder/cadastro_resp.dart';
import 'package:help_elder/cadastro_func.dart';
import 'package:help_elder/home.dart';
import 'package:help_elder/cadastro_veio.dart';
import 'package:help_elder/chat.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MaterialApp(
    home: const Test(),
    routes: <String, WidgetBuilder>{
      '/home':(context) => const Home(),
      '/login': (context) => const Login(),
      '/cadResp': (context) => const CadastroResp(),
      '/cadFunc': (context) => const CadastroFunc(),
      '/cadVeio': (context) => const CadastroVeio(),
      '/chat':(context) => Chat(),
    },
    

  ));
}

class Test extends StatelessWidget{
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
            ],
          ),
        ),
      )
    );
  }
}