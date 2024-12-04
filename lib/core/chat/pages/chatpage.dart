import 'package:flutter/material.dart';
import 'package:swapifymobile/common/app_colors.dart';

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ConversationListPage(),
    );
  }
}

class ConversationListPage extends StatelessWidget {
  final List<Map<String, dynamic>> conversations = [
    {
      "name": "Alice",
      "messages": [
        {"text": "Hi, how are you?", "reply": ""},
        {"text": "Are you coming to the party?", "reply": "Yes, I will!"},
      ],
    },
    {
      "name": "Bob",
      "messages": [
        {"text": "Did you finish the project?", "reply": "Working on it."},
        {"text": "Let me know if you need help.", "reply": ""},
      ],
    },
    {
      "name": "Charlie",
      "messages": [
        {"text": "Good morning!", "reply": "Good morning, Charlie!"},
        {"text": "Any plans for the weekend?", "reply": ""},
      ],
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Conversations",
          style: TextStyle(color: AppColors.primary),
        ),
        backgroundColor: AppColors.background,
      ),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final conversation = conversations[index];
          return ListTile(
            leading: CircleAvatar(
              child: Text(conversation["name"][0]),
              backgroundColor: AppColors.primary,
            ),
            title: Text(
              conversation["name"],
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(
              conversation["messages"].isNotEmpty
                  ? conversation["messages"].last["text"]
                  : "No messages yet",
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ChatPage(
                    name: conversation["name"],
                    messages: conversation["messages"],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class ChatPage extends StatefulWidget {
  final String name;
  final List<Map<String, String>> messages;

  ChatPage({required this.name, required this.messages});

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late List<Map<String, String>> _messages;
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _messages = List.from(widget.messages);
  }

  void _sendMessage(String text) {
    if (text.isEmpty) return;
    setState(() {
      _messages.add({"text": text, "reply": ""});
    });
    _controller.clear();
  }

  void _replyMessage(int index, String reply) {
    setState(() {
      _messages[index]["reply"] = reply;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.name),
        backgroundColor: AppColors.background,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            // colors: [Colors.deepPurple.shade700, Colors.purple.shade200],
            colors: [AppColors.background, AppColors.background],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return Padding(
                    padding:
                        const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            CircleAvatar(
                              child: Text(
                                widget.name[0],
                                style: TextStyle(color: AppColors.background),
                              ),
                              backgroundColor: AppColors.primary,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Text(message["text"]!),
                              ),
                            ),
                          ],
                        ),
                        if (message["reply"]!.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.only(left: 50, top: 5),
                            child: Row(
                              children: [
                                Icon(Icons.reply,
                                    color: AppColors.primary, size: 16),
                                SizedBox(width: 5),
                                Text(
                                  message["reply"]!,
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text("Reply to message"),
                                    content: TextField(
                                      onSubmitted: (value) {
                                        Navigator.pop(context);
                                        _replyMessage(index, value);
                                      },
                                      decoration: InputDecoration(
                                        hintText: "Enter your reply",
                                      ),
                                    ),
                                  ),
                                );
                              },
                              child: Text("Reply"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type your message...",
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(20),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  CircleAvatar(
                    backgroundColor: AppColors.primary,
                    child: IconButton(
                      onPressed: () => _sendMessage(_controller.text),
                      icon: Icon(Icons.send, color: Colors.white),
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
}
