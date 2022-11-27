// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:help_elder/estoque.dart';

FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;
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
                  Navigator.pushNamed(context, '/chat');
                },
              ),
            ),
          ],
        )
      ),
    );   
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    final data =[];
    print(auth.currentUser);
    messaging.getToken().then(print);
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Help Elder"),
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
              children: [
                for (var i = 0; i < data.length; i++)
                  topic("name"),
              ],
          ) : const Inventory(),
        ),
      ),
    );
  }
}