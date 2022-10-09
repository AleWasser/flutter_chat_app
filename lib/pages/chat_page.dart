import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:chat_app/widgets/chat_message.dart';

class ChatPage extends StatefulWidget {
  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> with TickerProviderStateMixin {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  final List<ChatMessage> _messages = [];

  bool _isWriting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Column(
          children: [
            CircleAvatar(
              maxRadius: 14,
              backgroundColor: Colors.blue[100],
              child: const Text(
                'Te',
                style: TextStyle(
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(
              height: 3,
            ),
            const Text(
              'Test',
              style: TextStyle(
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
      uid: '123',
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
  }

  @override
  void dispose() {
    // TODO: implement dispose
    for (var message in _messages) {
      message.animationController.dispose();
    }

    super.dispose();
  }
}
