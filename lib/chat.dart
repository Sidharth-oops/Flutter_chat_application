import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

import 'chat_message.dart';
import 'new_message.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  void setUpPushNotification() async {
    final fcm = FirebaseMessaging.instance;
    await fcm.requestPermission();
    fcm.subscribeToTopic('chat');
   
  }

  @override
  void initState() {
    super.initState();

    setUpPushNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('FlutterChat'),
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: Icon(
                  Icons.exit_to_app,
                  color: Theme.of(context).colorScheme.primary,
                ))
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: ChatMessage(),
            ),
            NewMessage(),
          ],
        ));
  }
}
