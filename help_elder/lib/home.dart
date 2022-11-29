// ignore_for_file: library_private_types_in_public_api, avoid_function_literals_in_foreach_calls

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:help_elder/estoque.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;
List<Widget> data = [];
int avoidLoop = 0;

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  _HomeState createState() => _HomeState();

}
class _HomeState extends State<Home>{
  @override
  void initState() {
    super.initState();
  }
  int page = 0;
  Widget topic(String name, {String photo='https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/925px-Unknown_person.jpg'}){
    return Flexible(
      child: Container(
        decoration: const BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Color(0xFFD9D9D9),
              width: 2.0,
            )
          )
        ),
        child: Row(
          children: [
            Padding (
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
                onTap: (){
                  Navigator.pushNamed(context, '/chat', arguments: {
                    "receiver": "maconha"
                  });
                },
              ),
            ),
          ],
        )
      ),
    );   
  }
  
  Future<void> getContacts(int typeAccount) async {
    // List<Widget> list = [];
    if (typeAccount == 0){
      await db.collection('idoso').where("idFunc", isEqualTo: auth.currentUser!.uid).get().then((value) =>{
        value.docs.forEach((older) {
          db.doc('responsavel/${older.data()['idResp']}').get().then((value) => {
            data.add(topic(value.data()!['name'])),
          });
        })
      });
    } else {
      await db.collection('idoso').where("idResp", isEqualTo: auth.currentUser!.uid).get()
      .then((value) =>{
        value.docs.forEach((older) {
          db.doc('funcionario/${older.data()['idFunc']}').get()
          .then((value) => {
            data.add(topic(value.data()!['email'])),
          });
        })
      });
    }
    // return list;
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as Map?;
    final List<Widget> veio;

    print(auth.currentUser);
    print(data);

      getContacts(args!['typeAccount']).then((_) {
        if(avoidLoop == 0){
          setState((){
            print("refreshing");
            avoidLoop = 1;
          });
        }
      });
    

    if (args['typeAccount'] == 0){
      veio = [
            IconButton(
              onPressed: (){
                Navigator.pop(context);
                Navigator.pushNamed(context, "/cadVeio");
              },
              icon: const Icon(Icons.add),
            ),
          ];
    } else {
      veio = [];
    }
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Help Elder"),
          actions: veio,
        ),
        bottomNavigationBar: NavigationBar(
            backgroundColor: Colors.blue,
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.comment),
                label: "Chat",
              ),
              NavigationDestination(
                icon: Icon(Icons.medical_information),
                label: "Remédios",
              ),
            ],
            onDestinationSelected: (int index) {
              setState(() {
                page = index;
              });
            },
          ),
        body: Center(
          child: page == 0 ? 
            Flex(
              direction: Axis.vertical,
              verticalDirection: VerticalDirection.down,
              children: [...data],
          ) : const Inventory(),
        ),
      ),
    );
  }
}