import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

import 'package:help_elder/cadastro_resp.dart';
import 'package:help_elder/cadastro_func.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;

class CadastroVeio extends StatelessWidget {
  const CadastroVeio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController respController = TextEditingController();
    final TextEditingController respNomeController = TextEditingController();

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

    return MaterialApp(
      routes: <String, WidgetBuilder>{
      '/cadResp': (context) => const CadastroResp(),
      '/cadFunc': (context) => const CadastroFunc(),
      '/cadVeio': (context) => const CadastroVeio(),
    },

      home: Scaffold(
        body: SizedBox(
          width: 500,
          height: 1000,
          child: SingleChildScrollView(child: Column(
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
                      'Cadastro de idoso',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Cadastre um idoso em nossa plataforma'),
                    SizedBox(
                      height: 30,
                    ),
                  ])),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nome',
                  ),
                  controller: nomeController,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                  ),
                  controller: cpfController,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Nome do Resonsável',
                  ),
                  controller: respNomeController,
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'CPF do responsável',
                  ),
                  controller: respController,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                  style: (ElevatedButton.styleFrom(
                        padding:
                            const EdgeInsets.symmetric(horizontal: 50, vertical: 20),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(32.0),
                        ),
                      )),
                  child: const Text('Cadastrar'),
                  onPressed: () {
                    if (nomeController.text.isNotEmpty &&
                        cpfController.text.isNotEmpty &&
                        respController.text.isNotEmpty &&
                        respNomeController.text.isNotEmpty) {
                      if (CPFValidator.isValid(cpfController.text) &&
                          CPFValidator.isValid(respController.text)) {
                            db.collection("idoso").add({"nome": cpfController.text, "cpf":nomeController.text, "nomeResp":respNomeController, "cpfResp" : respController.text,});
                            Navigator.pop(context);
                            Navigator.pushNamed(context, '/home');
                          }
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
            ],
          ),)
        ),
        backgroundColor: const Color.fromARGB(225, 235, 249, 255),
      ),
    );
  }
}