// ignore_for_file: library_private_types_in_public_api, avoid_function_literals_in_foreach_calls, prefer_typing_uninitialized_variables, void_checks

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_elder/list_medicines.dart';
import 'package:shared_preferences/shared_preferences.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;
// int avoidLoop = 0;
List<Widget> data = [];
List<Widget> veio = [];

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
  print(data);
    return FutureBuilder(
      future: getContacts(context).then((_) => setOlderAdd(context)),
      builder: screen, 
      initialData: const Center(child: CircularProgressIndicator()),
    );
  }
}

Widget topic(String name, String uid, BuildContext context,
    {String photo =
        'https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/925px-Unknown_person.jpg',
    List<dynamic> responsaveis = const [],
    String funcionario = ''}) {
  return Flexible(
    child: Container(
        decoration: const BoxDecoration(
            border: Border(
                bottom: BorderSide(
          color: Color(0xFFD9D9D9),
          width: 2.0,
        ))),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10.0,
                left: 10.0,
                right: 10.0,
              ),
              child: Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: Image.network(photo).image,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                left: 10,
                top: 10,
                right: 10,
              ),
              child: InkWell(
                child: Text(name),
                onTap: () async {
                  if (responsaveis.isNotEmpty) {
                    print(responsaveis);
                    var responsaveisData = [];
                    for (var i = 0; i < responsaveis.length; i++) {
                      await db
                          .collection('responsavel')
                          .doc(responsaveis[i])
                          .get()
                          .then((value) => {
                                responsaveisData.add({
                                  'uid': responsaveis[i],
                                  'name': value.data()!['email'],
                                })
                              });
                    }
                    print(responsaveisData);
                    showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text('Responsáveis'),
                            content: Column(
                              children: [
                                for (var i = 0;
                                    i < responsaveisData.length;
                                    i++)
                                  ListTile(
                                    title: Text(responsaveisData[i]['name']),
                                    onTap: () {
                                      // Navigator.pop(context);
                                      Navigator.pushNamed(context, '/chat',
                                          arguments: {
                                            // 'name': responsaveisData[i]['nome'],
                                            'receiver': responsaveisData[i]
                                                ['uid'],
                                            // 'photo': responsaveisData[i]['photo'],
                                          });
                                    },
                                  )
                              ],
                            ),
                          );
                        });
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                          return AlertDialog(
                            title: const Text('Funcionário'),
                            content: Column(
                              children: [
                                ListTile(
                                  title: Text(funcionario),
                                  onTap: () {
                                    // Navigator.pop(context);
                                    Navigator.pushNamed(context, '/chat',
                                    arguments: {
                                      // 'name': responsaveisData[i]['nome'],
                                      'receiver': uid,
                                      // 'photo': responsaveisData[i]['photo'],
                                    });
                                  },
                                )
                              ],
                          ),
                        );
                      }
                    );
                  }
                  // Navigator.pushNamed(context, '/chat',
                  //     arguments: {"receiver": uid});
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 10),
              child: IconButton(
                icon: const Icon(Icons.medical_services_rounded),
                onPressed: () {
                  Navigator.pushNamed(context, '/estoque',
                      arguments: {"elderId": uid});
                },
              ),
            ),
          ],
        )),
  );
}

Widget screen(BuildContext context, AsyncSnapshot<void> snapshot) {
  int page = 0;
  return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Help Elder"),
          actions: veio,
        ),
        body: Center(
          child: page == 0
              ? Flex(
                  direction: Axis.vertical,
                  verticalDirection: VerticalDirection.down,
                  children: [...data],
                )
              : const OlderList(),
        ),
      ),
    );
}

Future<void> getContacts(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();
  if (prefs.getInt("typeAccount") == 0) {
    await db
    .collection('idoso')
    .where("idFunc", isEqualTo: auth.currentUser!.uid)
    .get()
    .then((value) => {
      print(value.docs),
      print(auth.currentUser!.uid),
      value.docs.forEach((older) {
        data.add(topic(
          older.data()['nome'],
          older.id,
          context,
          responsaveis: older.data()['responsaveis'],
        ));
      })
    });
  } else {
    await db
    .collection('idoso')
    .where("responsaveis", arrayContains: auth.currentUser!.uid)
    .get()
    .then((value) => {
      print(value.docs),
      print(auth.currentUser!.uid),
      value.docs.forEach((older) {
        db.doc('funcionario/${older.data()['idFunc']}').get().then((value) => {
          data.add(topic(
            older.data()['nome'],
            older.id,
            context,
            funcionario: value.data()!['nome'] ?? value.data()!['email'],
          ))
        });
      })
    });
  }
}

Future<void> setOlderAdd(BuildContext context) async {
  final prefs = await SharedPreferences.getInstance();

  if (prefs.getInt('typeAccount') == 0) {
    veio = [
      IconButton(
        onPressed: () {
          Navigator.pushNamed(context, "/cadVeio");
        },
        icon: const Icon(Icons.add),
      ),
    ];
  } else {
    veio = [
      IconButton(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController cpfController =
                      TextEditingController();
                  return AlertDialog(
                    title: const Text("Adicionar Idoso"),
                    content: TextField(
                      decoration: const InputDecoration(
                        hintText: "Digite o CPF do idoso",
                      ),
                      controller: cpfController,
                    ),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Cancelar')),
                      TextButton(
                          onPressed: (() {
                            db
                                .collection('idoso')
                                .where("cpf", isEqualTo: cpfController.text)
                                .get()
                                .then((value) => {
                                      value.docs.forEach((element) {
                                        db.doc('idoso/${element.id}').update({
                                          'responsaveis':
                                              FieldValue.arrayUnion(
                                                  [auth.currentUser!.uid])
                                        });
                                      })
                                    });
                            avoidLoop = 0;
                            Navigator.pop(context);
                          }),
                          child: const Text('Adicionar'))
                    ],
                  );
                });
          },
          icon: const Icon(Icons.add)),
    ];
  }
}