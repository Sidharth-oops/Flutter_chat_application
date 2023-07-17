import 'package:chat_application/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key});

  @override
  Widget build(BuildContext context) {
    final authenticatedUser = FirebaseAuth.instance.currentUser!;
    return StreamBuilder(
      builder: (ctx, chatsnapshots) {
        if (chatsnapshots.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (!chatsnapshots.hasData || chatsnapshots.data!.docs.isEmpty) {
          return Center(
            child: Text('No message found'),
          );
        }
        if (chatsnapshots.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }
        final loadedMessages = chatsnapshots.data!.docs;
        return ListView.builder(
            padding: EdgeInsets.only(bottom: 40, left: 13, right: 13),
            reverse: true,
            itemCount: loadedMessages.length,
            itemBuilder: (ctx, index) {
              final chatMessage = loadedMessages[index].data();
              final nextChat = index + 1 < loadedMessages.length
                  ? loadedMessages[index + 1].data()
                  : null;
              final currentMessageuserid = chatMessage['userId'];
              final nextMessageUserid =
                  nextChat != null ? nextChat['userId'] : null;
              final nextUserIsSame = nextMessageUserid == currentMessageuserid;
              if (nextUserIsSame) {
                return MessageBubble.next(
                    message: chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageuserid);
              } else {
                return MessageBubble.first(
                    userImage:chatMessage['userImage'],
                    username: chatMessage['userName'],
                    message:chatMessage['text'],
                    isMe: authenticatedUser.uid == currentMessageuserid);
              }
            });
      },
      stream: FirebaseFirestore.instance
          .collection('chat')
          .orderBy('createdAt', descending: true)
          .snapshots(),
    );
  }
}
