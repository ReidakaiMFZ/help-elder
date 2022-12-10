// typeAccount 1
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;
final FirebaseMessaging messaging = FirebaseMessaging.instance;

const List<String> telas = <String>[
  'Cadastro de responsável',
  'Cadastro de funcionário'
];

class CadastroResp extends StatelessWidget {
  const CadastroResp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController passController = TextEditingController();
    final TextEditingController confirmPassController = TextEditingController();
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController nomeController = TextEditingController();
    AlertDialog alert = AlertDialog(
      title: const Text("Erro"),
      content: const Text("Algum erro ocorreu"),
      actions: [
        TextButton(
          child: const Text("OK"),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    );
    late final String token;
    messaging.getToken().then((String? value) {
      token = value!;
    });
    return MaterialApp(
      home: Scaffold(
        body: SizedBox(
            width: 500,
            height: 1000,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.max,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(
                      width: 300,
                      child: Column(children: const [
                        SizedBox(
                          height: 80,
                        ),
                        Text(
                          'Cadastro',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        Text('Faça cadastro como responsável de alguém'),
                        SizedBox(
                          height: 30,
                        ),
                      ])),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      controller: nomeController,
                      decoration: const InputDecoration(
                        labelText: 'Nome',
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'E-mail',
                      ),
                      controller: emailController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'cpf',
                      ),
                      controller: cpfController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Senha',
                      ),
                      controller: passController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: TextField(
                      decoration: const InputDecoration(
                        labelText: 'Confirmar Senha',
                      ),
                      controller: confirmPassController,
                    ),
                  ),
                  SizedBox(
                    width: 300,
                    child: Row(
                      children: [
                        Checkbox(
                          value: false,
                          onChanged: (bool? value) {},
                          checkColor: const Color.fromARGB(255, 81, 241, 228),
                          activeColor: const Color.fromARGB(255, 81, 105, 241),
                        ),
                        const Text('Eu li e concordo com os Termos')
                      ],
                    ),
                  ),
                  SizedBox(
                      width: 300,
                      child: DropdownButton(
                        value: 'Cadastro de responsável',
                        items: telas.map((String value) {
                          return DropdownMenuItem(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (String? value) {
                          if (value == 'Cadastro de funcionário') {
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/cadFunc');
                          }
                        },
                      )),
                  SizedBox(
                    width: 250,
                    child: ElevatedButton(
                      style: (ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      )),
                      child: const Text('Cadastrar'),
                      onPressed: () async {
                        final prefs = await SharedPreferences.getInstance();
                        prefs.setInt('typeAccount', 1);
                        if (nomeController.text.isNotEmpty && 
                            emailController.text.isNotEmpty &&
                            passController.text.isNotEmpty &&
                            passController.text == confirmPassController.text) {
                          auth
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: passController.text)
                              .then((UserCredential user) => {
                                    db
                                        .collection("responsavel")
                                        .doc(user.user!.uid)
                                        .set({
                                      "nome": nomeController.text,
                                      "email": emailController.text,
                                      "FCMToken": token,
                                      "cpf": cpfController.text,
                                    })
                                  });
                          Navigator.popAndPushNamed(context, '/home');
                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }
                      },
                    ),
                  ),
                  const SizedBox(
                    height: 50,
                  ),
                  RichText(
                    text: TextSpan(
                      children: [
                        const TextSpan(
                          text: 'Já tem cadastro? ',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        TextSpan(
                          text: "Faça login",
                          style: const TextStyle(
                            color: Colors.blue,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = () {
                              Navigator.pop(context);
                              Navigator.pushNamed(context, '/login');
                            },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )),
        backgroundColor: const Color.fromARGB(225, 235, 249, 255),
      ),
    );
  }
}
