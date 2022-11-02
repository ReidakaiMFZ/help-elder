// ignore_for_file: prefer_const_literals_to_create_immutables, no_logic_in_create_state
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
String receiver = "MTV48ahFfTeUq7rr0FFWJXvz2HA3";
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseDatabase database = FirebaseDatabase.instance;

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);
  final List<Widget> messages = <Widget>[];

  @override
  ChatState createState() {
    return ChatState();
  }
}

class ChatState extends State<Chat> {
  final TextEditingController messageController = TextEditingController();
  void createMessage(String message, bool isMe) {
    print(message + " " + isMe.toString());
    if (isMe) {
      widget.messages.add(ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color(0xff007EF4),
        child: Text(message),
      ));
    } else {
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
      // final colecao = firestore.collection('messages');
      // colecao.add(
      //   {
      //     'message': message,
      //     'sender': user!.uid,
      //     'receiver': '',
      //     'time': DateTime.now().millisecondsSinceEpoch,
      //   }
      // );
      // createMessage(message, true);
      final ref = database.ref('chats').push();
      ref.set({
        'message': message,
        'sender': user?.uid ?? '',
        'receiver': '',
        'time': DateTime.now().millisecondsSinceEpoch,
      }).then((value) {
        print('Mandou');
      });

      createMessage(message, true);
    }
  }

  void getMessages() async {
    // final myMessages = firestore
    //     .collection('messages')
    //     .where("sender", isEqualTo: user!.uid)
    //     .orderBy('time');
    var serverMessages = [];

    var myMessages =
        database.ref('chats').orderByChild('sender').equalTo(user?.uid ?? '');

    await myMessages.once().then((querySnapshot) async {
      for (var doc in querySnapshot.snapshot.children) {
        var message = await doc.ref.get();
        print(message.value as dynamic);
        serverMessages.add(message.value as dynamic);
      }
      print(serverMessages);
    });

    myMessages =
        database.ref('chats').orderByChild('receiver').equalTo(user?.uid ?? '');

    await myMessages.once().then((querySnapshot) async {
      for (var doc in querySnapshot.snapshot.children) {
        var message = await doc.ref.get();
        print(message.value as dynamic);
        serverMessages.add(message.value as dynamic);
      }
      print(serverMessages);
    });
    serverMessages.sort((a, b) => a['time'].compareTo(b['time']));
    setState(() {
      for (var message in serverMessages) {
        createMessage((message)['message'], user?.uid == (message)['sender']);
        print(message.toString());
      }
    });
  }

  @override
  void initState() {
    super.initState();
    print("object");
    getMessages();
  }

  @override
  Widget build(BuildContext context) {
    // final docRef = firestore.collection("messages");

    // docRef.snapshots().listen(
    //   (event) {
    //     var element = event.docs.last;
    //     if (element.data()['sender'] != user!.uid) {
    //       createMessage(element.data()['message'], false);
    //     }
    //   },
    // );

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
                    setState(() {
                      if (messageController.text.isNotEmpty) {
                        storeMessage(messageController.text);
                        messageController.clear();
                      }
                    });
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
