import 'package:flutter/material.dart';
// ignore_for_file: prefer_const_constructors
// ignore_for_file: prefer_const_literals_to_create_immutables

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Help Elder'),
          backgroundColor: Colors.black,
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // const SizedBox(
            //   height: 70,
            //   width: 70,
            // ),
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
                    value: true,
                    onChanged: (bool? value) {},
                    checkColor: Color.fromARGB(255, 81, 241, 228),
                    activeColor: Color.fromARGB(255, 81, 105, 241),
                  ),
                  Text('Eu li e concordo com os Termos')
                ],

              ),
            ),
            ElevatedButton(
              child: const Text('Cadastrar'),
              onPressed: () {
                // Navigator.pushNamed(context, '/home');
              },
            ),
          ],

        ),
      ),
    );
  }
}
