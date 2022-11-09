// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:help_elder/estoque.dart';

FirebaseAuth auth = FirebaseAuth.instance;
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

  Widget conversations(){
    return Flex(
      direction: Axis.vertical,
      verticalDirection: VerticalDirection.down,
      children: [
        Flexible(
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
                        image: Image.network('https://upload.wikimedia.org/wikipedia/en/c/cc/Somewhere_Far_Beyond.jpg').image,
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
                    child: const Text('User name'),
                    onTap: (){
                      Navigator.pushNamed(context, '/chat');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget medicines(){
    return const Inventory();
  }

  int page = 0;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Help Elder"),
        ),
        bottomNavigationBar: NavigationBar(
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home),
                label: "Conversas",
              ),
              NavigationDestination(
                icon: Icon(Icons.home),
                label: "Remedios",
              ),
            ],
            onDestinationSelected: (int index) {
              setState(() {
                page = index;
              });
            },
          ),
        body: Center(
          child: page == 0 ? conversations() : medicines(),
        ),
      ),
    );
  }
}