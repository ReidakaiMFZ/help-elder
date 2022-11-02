import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final FirebaseFirestore db = FirebaseFirestore.instance;
// Cspell:ignore firestore

Future<List<Medicine>> getMedicine(String id) async {
  var value =
      await db.collection('idoso').get().then((QuerySnapshot querySnapshot) {
    for (var doc in querySnapshot.docs) {
      if (doc.id == id) {
        print(doc['medicines'][0]['name']);
        return doc.get('medicines');
      }
    }
  });
  return List<_Medicine>.from(value)
      .map((e) => Medicine(e['name'], e['qtd'], e['consume']))
      .toList();
}

const elderId = 'aGbRsMpZJVOFApgdyVPi';
typedef _Medicine = Map<String, dynamic>;

class Medicine {
  final String name;
  int qtd;
  int consume;
  Medicine(this.name, this.qtd, this.consume);
  toMap() => {'name': name, 'qtd': qtd, 'consume': consume};
}

void publishMedicine(String id, List<Medicine> medicines) {
  db.collection('idoso').doc(id).update({
    'medicines': medicines.map((e) => e.toMap()).toList(),
  });
}

void addMedicine() {}

class Inventory extends StatefulWidget {
  const Inventory({super.key});

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory> {
  List<Medicine>? medicines;
  @override
  void initState() {
    super.initState();
    getMedicine(elderId).then((value) => setState(() {
          medicines = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    if (medicines != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Estoque'),
        ),
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 1000,
              child: ListView.builder(
                itemCount: medicines?.length,
                itemBuilder: (BuildContext context, int index) {
                  return ListTile(
                    // key: Key(index.toString()),
                    title: Text(medicines?[index].name as String),
                    subtitle: Text(
                        "Quantidade: ${medicines?[index].qtd.toString() as String}"),
                    trailing:
                        Text('Consumo Diário: ${medicines?[index].consume}'),
                    leading: IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              final TextEditingController nameController =
                                  TextEditingController(
                                      text: medicines?[index].name);
                              final TextEditingController qtdController =
                                  TextEditingController(
                                      text: medicines?[index].qtd.toString());
                              final TextEditingController consumeController =
                                  TextEditingController(
                                      text:
                                          medicines?[index].consume.toString());
                              return AlertDialog(
                                title: const Text('Editar'),
                                content: SingleChildScrollView(
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      TextField(
                                        enabled: false,
                                        decoration: const InputDecoration(
                                            labelText: 'Nome'),
                                        controller: nameController,
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                            labelText: 'Quantidade'),
                                        controller: qtdController,
                                      ),
                                      TextField(
                                        decoration: const InputDecoration(
                                            labelText: 'Consumo Diário'),
                                        controller: consumeController,
                                      ),
                                    ],
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Cancelar'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        medicines?[index].qtd =
                                            int.parse(qtdController.text);
                                        medicines?[index].consume =
                                            int.parse(consumeController.text);
                                      });
                                      publishMedicine(
                                          'aGbRsMpZJVOFApgdyVPi', medicines!);
                                      Navigator.pop(context);
                                    },
                                    child: const Text('Salvar'),
                                  ),
                                ],
                              );
                            });
                      },
                    ),
                  );
                },
              ),
            ),
          ]),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => showDialog(
              context: context,
              builder: (context) {
                final TextEditingController nameController =
                    TextEditingController();
                final TextEditingController qtdController =
                    TextEditingController();
                final TextEditingController consumeController =
                    TextEditingController();
                return AlertDialog(
                  title: const Text('Adicionar medicamento'),
                  content: SizedBox(
                    height: 300,
                    child: SingleChildScrollView(
                      child: Column(children: [
                        TextField(
                            controller: nameController,
                            decoration:
                                const InputDecoration(labelText: 'Nome')),
                        TextField(
                          controller: qtdController,
                          decoration:
                              const InputDecoration(labelText: 'Quantidade'),
                          keyboardType: TextInputType.number,
                        ),
                        TextField(
                          controller: consumeController,
                          decoration: const InputDecoration(
                              labelText: 'Consumo Diário'),
                          keyboardType: TextInputType.number,
                        ),
                      ]),
                    ),
                  ),
                  actions: [
                    TextButton(
                      child: const Text('Cancelar'),
                      onPressed: () => Navigator.pop(context),
                    ),
                    TextButton(
                      child: const Text('Adicionar'),
                      onPressed: () {
                        if (nameController.text.isNotEmpty &&
                            qtdController.text.isNotEmpty &&
                            consumeController.text.isNotEmpty) {
                          setState(() {
                            medicines?.add(Medicine(
                                nameController.text,
                                int.parse(qtdController.text),
                                int.parse(consumeController.text)));
                          });
                          publishMedicine('aGbRsMpZJVOFApgdyVPi', medicines!);
                          Navigator.pop(context);
                        } else {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: const Text('Erro'),
                                  content: const Text(
                                      'Preencha todos os campos corretamente'),
                                  actions: [
                                    TextButton(
                                      child: const Text('Ok'),
                                      onPressed: () => Navigator.pop(context),
                                    ),
                                  ],
                                );
                              });
                        }
                      },
                    ),
                  ],
                );
              }),
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16.0))),
          elevation: 6,
          child: const Icon(Icons.add),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      );
    } else {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Estoque'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
    // create a list with the medicines
    // return FutureBuilder(
    //     //Cspell:ignore aGbRsMpZJVOFApgdyVPi
    //     future: getMedicine('aGbRsMpZJVOFApgdyVPi'),
    //     builder: ((context, snapshot) {
    //       if (snapshot.hasData) {
    //         ListView.builder(
    //           itemCount: (snapshot.data as List<Medicine>).length,
    //           itemBuilder: (context, index) {
    //             return ListTile(
    //               title: Text((snapshot.data as List<Medicine>)[index].name),
    //               subtitle: Text(
    //                   (snapshot.data as List<Medicine>)[index].qtd.toString()),
    //             );
    //           },
    //         );
    //       } else {
    //         return const Center(child: CircularProgressIndicator());
    //       }
    //       throw UnimplementedError();
    //     }));
  }
}
