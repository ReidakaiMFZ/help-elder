// ignore_for_file: library_private_types_in_public_api, avoid_function_literals_in_foreach_calls

import "package:flutter/material.dart";
import "package:cloud_firestore/cloud_firestore.dart";
import "package:firebase_auth/firebase_auth.dart";

final FirebaseFirestore firebase = FirebaseFirestore.instance;
final FirebaseAuth auth = FirebaseAuth.instance;
List<Widget> data = [];
int avoidLoop = 0;

class OlderList extends StatefulWidget{
  final int account;
  const OlderList({
    super.key,
    required this.account
    });

  @override
  // ignore: no_logic_in_create_state
  _OlderListState createState() => _OlderListState(account);

}

class _OlderListState extends State<OlderList>{
  final int account;
  _OlderListState(this.account);
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context){
    Widget tile(String name, String uid, {String photo='https://upload.wikimedia.org/wikipedia/commons/thumb/b/bc/Unknown_person.jpg/925px-Unknown_person.jpg'}){
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
                  print("pai??????????????????????");
                  // Navigator.pushNamed(context, "/estoque", arguments: {
                  //   "elderId": uid
                  // });
                  // Navigator.pushNamed(context, '/estoque');
                },
              ),
            ),
          ],
        )
      ),
    );   
  }
    
    Future<void> getOlder() async{
      if (account == 0){
        await firebase.collection('idoso').where("idFunc", isEqualTo: auth.currentUser!.uid).get()
        .then((value) {
          value.docs.forEach((older) {
            data.add(tile(older.data()['nome'], older.id));
          });
        });
      }
      else if(account ==1 ){
        await firebase.collection('idoso').where("idResp", isEqualTo: auth.currentUser!.uid).get()
        .then((value) {
          value.docs.forEach((older) {
            data.add(tile(older.data()['nome'], older.id));
          });
        });
      }
    }

    if(avoidLoop == 0){
      getOlder().then((_) => 
        setState((() {
          print("refreshing");
          avoidLoop = 1;
        })));
    }
    
    return Scaffold(
      body: Column(
        children: [...data],
      ),
    );
  }
}

