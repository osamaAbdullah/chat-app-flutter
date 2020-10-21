import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/message_bubble.dart';
import 'package:flash_chat/constants.dart';
import 'package:flutter/material.dart';

class ChatScreen extends StatefulWidget {
  static const id = 'ChatScreen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _fireStore = FirebaseFirestore.instance;
  final TextEditingController _textEditingController = TextEditingController();
  User _loggedInUser;
  String _message;

  @override
  void initState() {
    _getCurrentUser();
    super.initState();
  }

  void _getCurrentUser() {
    try {
      final _user = _auth.currentUser;
      if (_user != null) {
        _loggedInUser = _user;
        print(_loggedInUser);
      }
    } catch (e) {
      print(e);
    }
  }

/*  void _getMessages() async {
    final _messages = await _fireStore.collection('messages').get();
    for (var _message in _messages.docs) {
      print(_message.data());
    }
  }*/

/*  void _messagesStream() async {
    await for (var _snapshot in _fireStore.collection('messages').snapshots()) {
      for (var _message in _snapshot.docs) {
        print(_message.data());
      }
    }
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        title: Text('Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _streamBuilder(context),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: _textEditingController,
                      onChanged: (value) {
                        _message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      print(DateTime.now());
                      _fireStore.collection('messages').add({
                        'datetime': DateTime.now(),
                        'text': _message,
                        'sender': _loggedInUser.email
                      });
                      _textEditingController.clear();
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _streamBuilder(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasData) {
          final List<QueryDocumentSnapshot> _messages =
              snapshot.data.docs.reversed.toList();
          List<MessageBubble> _messagesWidget = [];
          for (QueryDocumentSnapshot _message in _messages) {
            final String _messageText = _message.data()['text'];
            final String _messageSender = _message.data()['sender'];
            final Timestamp _messageDateTime = _message.data()['datetime'];
            _messagesWidget.add(MessageBubble(
              text: _messageText,
              sender: _messageSender,
              isMe: _loggedInUser.email == _messageSender,
              datetime: _messageDateTime,
            ));
          }
          _messagesWidget.sort((a, b) {
            return b.datetime.seconds.compareTo(a.datetime.seconds);
          });
          return Expanded(
            child: ListView(
              reverse: true,
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
              children: _messagesWidget,
            ),
          );
        } else {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
      },
      stream: _fireStore.collection('messages').snapshots(),
    );
  }
}
