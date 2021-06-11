import 'package:chatApp/widgets/chat/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Messages extends StatelessWidget {
  const Messages({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final chatId = 'h8pSa1FcWQ9ibrZJqslc';

    return FutureBuilder(
      future: FirebaseAuth.instance.currentUser(),
      builder: (context, userSnapShot) => userSnapShot.connectionState ==
              ConnectionState.waiting
          ? Center(
              child: CircularProgressIndicator(),
            )
          : StreamBuilder(
              stream: Firestore.instance
                  .collection('chats/$chatId/messages')
                  .orderBy('createdAt', descending: true)
                  .snapshots(),
              builder: (contex, chatSnapshot) {
                if (chatSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                final chatDocs = chatSnapshot.data.documents;
                return ListView.builder(
                  reverse: true,
                  itemCount: chatDocs.length,
                  itemBuilder: (contex, index) => MessageBubble(
                    message: chatDocs[index]['text'],
                    isMe: chatDocs[index]['userId'] == userSnapShot.data.uid,
                    userName: chatDocs[index]['username'],
                    key: ValueKey(chatDocs[index].documentID),
                  ),
                );
              },
            ),
    );
  }
}
