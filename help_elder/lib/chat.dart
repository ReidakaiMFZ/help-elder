// ignore_for_file: prefer_const_literals_to_create_immutables, no_logic_in_create_state
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

FirebaseAuth auth = FirebaseAuth.instance;
User? user = auth.currentUser;
FirebaseFirestore firestore = FirebaseFirestore.instance;
FirebaseDatabase database = FirebaseDatabase.instance;
FirebaseMessaging messaging = FirebaseMessaging.instance;

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
    if (isMe) {
      widget.messages.add(ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color.fromARGB(255, 59, 138, 212),
        child: Text(message,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ));
    } else {
      widget.messages.add(ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color.fromARGB(255, 74, 173, 115),
        child: Text(message,
            style: const TextStyle(color: Color.fromARGB(255, 255, 255, 255))),
      ));
    }
  }

  void storeMessage(String message, String receiver) {
    if (messageController.text.isNotEmpty) {
      // final colecao = firestore.collection('messages');
      // colecao.add(
      //   {
      //     'message': message,
      //     'sender': user!.uid,
      //     'receiver': receiver,
      //     'time': DateTime.now().millisecondsSinceEpoch,
      //   }
      // );
      // createMessage(message, true);
      final ref = database.ref('chats').push();
      ref.set({
        'message': message,
        'sender': user?.uid ?? '',
        'receiver': receiver,
        'time': DateTime.now().millisecondsSinceEpoch,
      }).then((value) {
        print('Mandou');
      });

      createMessage(message, true);
    }
  }

  void getMessages() async {
    var serverMessages = [];
    var myMessages =
        database.ref('chats').orderByChild('sender').equalTo(user?.uid ?? '');

    await myMessages.once().then((querySnapshot) async {
      for (var doc in querySnapshot.snapshot.children) {
        var message = await doc.ref.get();
        serverMessages.add(message.value as dynamic);
      }
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
      }
    });
  }

  @override
  void initState() {
    super.initState();
    // getMessages();
  }

  @override
  Widget build(BuildContext context) {
    final arguments = (ModalRoute.of(context)?.settings.arguments ??
        <String, dynamic>{}) as Map?;
    return Scaffold(
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            bottom: 50,
            child: StreamBuilder(
              stream: database
                  .ref('chats')
                  .orderByChild('time')
                  .onValue
                  .asBroadcastStream(),
              builder: (context, snapshot) {
                print('snapshot: $snapshot');
                while (snapshot.connectionState == ConnectionState.active) {
                  widget.messages.clear();
                  print((snapshot.data! as dynamic).snapshot.value);
                  for (var doc
                      in (snapshot.data! as dynamic).snapshot.value.values) {
                    if (doc['sender'] == user?.uid ||
                        doc['receiver'] == user?.uid) {
                      createMessage(doc['message'], user?.uid == doc['sender']);
                    }
                    print(doc);
                    // createMessage(doc['message'], user?.uid == doc['sender']);
                  }
                  return ListView(
                    children: widget.messages,
                  );
                }
                // var data = snapshot.data as Map<String, dynamic>;
                // createMessage(data['message'], user?.uid == data['sender']);

                return const Center(
                  child: CircularProgressIndicator(),
                );
              },
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
                        storeMessage(messageController.text,
                            arguments!['receiver'] ?? auth.currentUser!.uid);
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
