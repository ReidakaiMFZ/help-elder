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
        body: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Text(
                      'Login',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SizedBox(
                height: 80,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text('Faça login como cuidador/responsável de alguém',
                        style: TextStyle(
                          fontSize: 15,
                        )),
                  ],
                ),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Email',
                  ),
                  controller: emailController,
                ),
              ),
              SizedBox(
                width: 350,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                  controller: passController,
                ),
              ),
              SizedBox(
                height: 100,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: 250,
                      child: ElevatedButton(
                        style: (ElevatedButton.styleFrom(
                          padding: EdgeInsets.symmetric(
                              horizontal: 50, vertical: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        )),
                        child: const Text('Login',
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold)),
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
                                        builder: (BuildContext context) =>
                                            alert)
                                  });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextButton(
                      child: const Text('Esqueceu a Senha?',
                          style: TextStyle(fontSize: 15)),
                      onPressed: () {
                        Navigator.pushNamed(context, '/esqueci_senha');
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Não tem uma conta?'),
                  TextButton(
                    child: const Text('Cadastre-se'),
                    onPressed: () {
                      Navigator.pushNamed(context, '/cadResp');
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
