// import 'package:firebase_auth/firebase_auth.dart';
// ignore_for_file: prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';

class Chat extends StatefulWidget {
  Chat({Key? key}) : super(key: key);
  final List<Widget> messages = <Widget>[];
  
  @override
  ChatState createState() => ChatState();
}

class ChatState extends State<Chat>{
  final TextEditingController messageController = TextEditingController();

  Widget createMessage(String message, bool isMe) {
    if (isMe){
      return ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.sendBubble),
        alignment: Alignment.topRight,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color(0xff007EF4),
        child: Text(message),
      );
    }
    else{
      return ChatBubble(
        clipper: ChatBubbleClipper1(type: BubbleType.receiverBubble),
        alignment: Alignment.topLeft,
        margin: const EdgeInsets.only(top: 20),
        backGroundColor: const Color(0xffE7E7ED),
        child: Text(message),
      );
    }
  }
  
  @override
  Widget build (BuildContext context){
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
                          widget.messages.add(createMessage(messageController.text, true));
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