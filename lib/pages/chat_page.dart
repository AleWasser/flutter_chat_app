import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:chat_app/models/messages_response.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/chat_service.dart';
import 'package:chat_app/services/socket_service.dart';
import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late ChatService chatService;
  late SocketService socketService;
  late AuthService authService;
  final List<ChatMessage> _messages = [];
  bool _isWriting = false;

  @override
  void initState() {
    authService = Provider.of<AuthService>(context, listen: false);
    chatService = Provider.of<ChatService>(context, listen: false);
    socketService = Provider.of<SocketService>(context, listen: false);

    socketService.socket!.on('private-message', _listenMessage);

    _loadHistory(chatService.targetUser.uid);
    super.initState();
  }

  void _listenMessage(dynamic payload) {
    ChatMessage message = ChatMessage(
      uid: payload['from'],
      text: payload['message'],
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 300),
      ),
    );

    setState(() {
      _messages.insert(0, message);
    });

    message.animationController.forward();
  }

  Future<void> _loadHistory(String userId) async {
    List<Message> messages = await chatService.loadMessages(userId);

    final history = messages.map(
      (message) => ChatMessage(
        uid: message.from,
        text: message.message,
        animationController: AnimationController(
          vsync: this,
          duration: const Duration(milliseconds: 0),
        )..forward(),
      ),
    );

    setState(() {
      _messages.insertAll(0, history);
    });
  }

  @override
  Widget build(BuildContext context) {
    final targetUser = chatService.targetUser;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: Text(
                targetUser.name.substring(0, 2),
                style: const TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            Text(
              targetUser.name,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 10,
              ),
            )
          ],
        ),
        centerTitle: true,
        elevation: 1,
      ),
      body: Column(
        children: [
          Flexible(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) => _messages[index],
            ),
          ),
          const Divider(
            height: 1,
          ),
          Container(
            color: Colors.white,
            child: _inputChat(),
          )
        ],
      ),
    );
  }

  Widget _inputChat() {
    return SafeArea(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmit,
                onChanged: (String text) {
                  setState(() {
                    if (text.trim().isNotEmpty) {
                      _isWriting = true;
                    } else {
                      _isWriting = false;
                    }
                  });
                },
                decoration: const InputDecoration.collapsed(
                  hintText: 'Send a message',
                ),
                focusNode: _focusNode,
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              child: Platform.isIOS
                  ? CupertinoButton(
                      onPressed: _isWriting
                          ? () => _handleSubmit(_textController.text.trim())
                          : null,
                      child: const Text('Send'),
                    )
                  : Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      child: IconTheme(
                        data: IconThemeData(color: Colors.blue[400]),
                        child: IconButton(
                          highlightColor: Colors.transparent,
                          splashColor: Colors.transparent,
                          icon: const Icon(Icons.send),
                          onPressed: _isWriting
                              ? () => _handleSubmit(_textController.text.trim())
                              : null,
                        ),
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  _handleSubmit(String text) {
    if (text.isEmpty) return;

    _focusNode.requestFocus();
    _textController.clear();

    final newMessage = ChatMessage(
      uid: authService.user.uid,
      text: text,
      animationController: AnimationController(
        vsync: this,
        duration: const Duration(
          milliseconds: 250,
        ),
      ),
    );
    _messages.insert(0, newMessage);
    newMessage.animationController.forward();

    setState(() {
      _isWriting = false;
    });

    socketService.emit('private-message', {
      'from': authService.user.uid,
      'to': chatService.targetUser.uid,
      'message': text
    });
  }

  @override
  void dispose() {
    for (var message in _messages) {
      message.animationController.dispose();
    }
    socketService.socket!.off('private-message');
    super.dispose();
  }
}
