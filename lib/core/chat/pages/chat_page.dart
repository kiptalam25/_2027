import 'package:flutter/material.dart';

class ChatPage extends StatefulWidget {
  final String userName;

  const ChatPage(this.userName, {Key? key}) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final List<Map<String, dynamic>> messages = [
    {"text": "Hello!", "isSentByMe": false},
    {"text": "Hi! How are you?", "isSentByMe": true},
    {"text": "I'm good, thanks. And you?", "isSentByMe": false},
  ];

  final TextEditingController _messageController = TextEditingController();

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;

    setState(() {
      messages
          .add({"text": _messageController.text.trim(), "isSentByMe": true});
      _messageController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.userName)),
      body: Column(
        children: [
          // Messages List
          Expanded(
            child: ListView.builder(
              reverse: true, // Show the latest message at the bottom
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[messages.length - 1 - index];
                return Align(
                  alignment: message['isSentByMe']
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    margin:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    decoration: BoxDecoration(
                      color: message['isSentByMe']
                          ? Colors.blue[100]
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      message['text'],
                      style: TextStyle(
                        color: message['isSentByMe']
                            ? Colors.black
                            : Colors.black87,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Message Input
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              border: Border(top: BorderSide(color: Colors.grey.shade300)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: const InputDecoration(
                      hintText: "Type a message",
                      border: InputBorder.none,
                    ),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send, color: Colors.blue),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
