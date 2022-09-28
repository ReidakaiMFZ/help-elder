import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseAuth auth = FirebaseAuth.instance;
class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print(auth.currentUser);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Help Elder'),
          backgroundColor: Colors.black,
        ),
        body: const SizedBox(
            width: 500, height: 500, child: Text('Tela principal')),
        backgroundColor: const Color.fromARGB(225, 235, 249, 255),
      ),
    );
  }
}
