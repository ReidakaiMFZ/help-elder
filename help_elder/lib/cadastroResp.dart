import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

void main() {
  runApp(const CadastroResp());
}

class CadastroResp extends StatelessWidget {
  const CadastroResp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body:
          SizedBox(
            width: 500,
            height: 1000,
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 300,
                child: Column(
                  children: [
                    Text('Cadastro',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Text('Faça cadastro como responsável'),
                    SizedBox(
                      height: 30,
                    ),
                  ]
                  )
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'CPF',
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Senha',
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: const InputDecoration(
                    labelText: 'Confirmar Senha',
                  ),
                ),
              ),
              SizedBox(
                width: 300,
                child: Row(
                  children:[
                    Checkbox(
                      value: false,
                      onChanged: (bool? value) {},
                      checkColor: Color.fromARGB(255, 81, 241, 228),
                      activeColor: Color.fromARGB(255, 81, 105, 241),
                    ),
                    Text('Eu li e concordo com os Termos')
                  ],

                ),
              ),
              SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 250,
                child: ElevatedButton(
                child: const Text('Cadastrar'),
                onPressed: () {
                  // Navigator.pushNamed(context, '/home');
                },
              ),
              ),
              SizedBox(
                height: 50,
              ),
              Text('Já tem cadastro? Faça login')
            ],

          ),

          ),
          backgroundColor: Color.fromARGB(255, 175, 223, 255),
      ),
    );
  }
}