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
        appBar: AppBar(
          title: const Text('Help Elder'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          children: [
            TextField(
              decoration: const InputDecoration(
                labelText: 'CPF',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Senha',
              ),
            ),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Confirmar Senha',
              ),
            ),
            Row(
              children:[
                Text('Eu concordo com os Termos e Condições '),
                Checkbox(
                  value: true,
                  onChanged: (bool? value) {},
                  checkColor: Color.fromARGB(255, 81, 241, 228),
                  activeColor: Color.fromARGB(255, 81, 105, 241),
                )
              ],
              
            ),
            ElevatedButton(
              child: const Text('Cadastrar'),
              onPressed: () {
                Navigator.pushNamed(context, '/home');
              },
            ),
          ],
        ),
      ),
    );
  }
}