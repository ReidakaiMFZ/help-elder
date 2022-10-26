// ignore_for_file: prefer_const_literals_to_create_immutables, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';


FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
FirebaseFirestore firestore = FirebaseFirestore.instance;

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);
  final List<Widget> messages = <Widget>[];

  @override
  ChatState createState() { 

    return ChatState();
  }
}

class ChatState extends State<Chat>{
  final TextEditingController messageController = TextEditingController();
  void createMessage(String message, bool isMe) {
    if (isMe){
      widget.messages.add(ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color(0xff007EF4),
        child: Text(message),
      ));
    }
    else{
      widget.messages.add(ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color(0xffE7E7ED),
        child: Text(message),
      ));
    }
  }
  void storeMessage(String message) {
    if (messageController.text.isNotEmpty) {
      final colecao = firestore.collection('messages');
      colecao.add(
        {
          'message': message,
          'sender': user!.uid,
          'receiver': '',
          'time': DateTime.now().millisecondsSinceEpoch,
        }
      );
      createMessage(message, true);
    }
  }
  void getMessages() {
    final myMessages = firestore.collection('messages').where("sender", isEqualTo: user!.uid).orderBy('time');
    myMessages.get().then(
      (QuerySnapshot querySnapshot){
        querySnapshot.docs.forEach(
          (doc){
            setState(() {
              createMessage(doc['message'], true);
            });
          }
        );
      } 
    );
  }

  @override
  void initState() {
    super.initState();
    getMessages();
  }

  @override
  Widget build (BuildContext context){
    final docRef = firestore.collection("messages");
    
    docRef.snapshots().listen(
      (event) { 
        var element = event.docs.last;
        if (element.data()['sender'] != user!.uid){
          createMessage(element.data()['message'], false);
        }
      },
    );

    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 50,
            child: ListView(
              children: [...widget.messages],
            ),
          ),
          Positioned(
            bottom: 5,
            left: 10,
            right: 10,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    decoration: const InputDecoration(
                      hintText: 'Type a message...',
                      border: UnderlineInputBorder(),
                    ),
                    controller: messageController,
                  ),
                ),
                IconButton(
                  onPressed: () {
                    setState(
                      () {
                        if(messageController.text.isNotEmpty){
                          storeMessage(messageController.text);
                          messageController.clear();
                        }
                      }
                    );
                  },
                  icon: const Icon(Icons.send),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
