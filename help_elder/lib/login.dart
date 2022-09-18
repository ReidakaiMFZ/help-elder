import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

final FirebaseAuth auth = FirebaseAuth.instance;

class Login extends StatelessWidget {
  const Login({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: Text("Error"),
      content: Text("Invalid Email or Password"),
      actions: [
        TextButton(
          child: Text("OK"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );

    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromARGB(225, 235, 249, 255),
        appBar: AppBar(
          title: const Text('Help Elder'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'Email',
              ),
              controller: emailController,
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
              controller: passController,
            ),
            ElevatedButton(
              child: const Text('Login'),
              onPressed: () {
                auth
                    .signInWithEmailAndPassword(
                        email: emailController.text,
                        password: passController.text)
                    .then((x) => {
                          Navigator.pop(context),
                          Navigator.pushNamed(context, '/home')
                        })
                    .catchError((e) => {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) => alert)
                        });
              },
            ),
          ],
        ),
      ),
    );
  }
}
