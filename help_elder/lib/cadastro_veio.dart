import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cpf_cnpj_validator/cpf_validator.dart';

final FirebaseAuth auth = FirebaseAuth.instance;
final FirebaseFirestore db = FirebaseFirestore.instance;

class CadastroVeio extends StatelessWidget {
  const CadastroVeio({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController nomeController = TextEditingController();
    final TextEditingController cpfController = TextEditingController();
    final TextEditingController respController = TextEditingController();
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
                      'Cadastro',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Faça cadastro de um idoso'),
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
                    labelText: 'CPF do responsável',
                  ),
                  controller: respController,
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
                        respController.text.isNotEmpty) {
                      if (CPFValidator.isValid(cpfController.text) &&
                          CPFValidator.isValid(respController.text)) {
                            db.collection("idoso").add({"cpf":nomeController.text, "cpfResp" : respController.text, "nome": cpfController.text});
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
          ),)
        ),
        backgroundColor: const Color.fromARGB(225, 235, 249, 255),
      ),
    );
  }
}