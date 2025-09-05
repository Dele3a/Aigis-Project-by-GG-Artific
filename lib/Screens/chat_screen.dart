import 'package:flutter/material.dart';
import '../utils/chat_service.dart';

class ChatScreen extends StatefulWidget {
  final String result;

  const ChatScreen({super.key, required this.result});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatService _chatService = ChatService();
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];

  @override
  void initState() {
    super.initState();
    _sendBotMessage("Detected pathology: ${widget.result}");
  }

  void _sendMessage(String message) async {
    if (message.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message cannot be empty.')),
      );
      return;
    }

    setState(() {
      _messages.add({"text": message, "isBot": false});
    });
    _controller.clear();

    try {
      String botResponse =
      await _chatService.sendMessage(message, widget.result);
      setState(() {
        _messages.add({"text": botResponse, "isBot": true});
      });
    } catch (e) {
      setState(() {
        _messages.add({"text": "Error: $e", "isBot": true});
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.shield_outlined, color: Colors.amber),
            SizedBox(width: 8),
            Text(
              'Aigis AI',
              style: TextStyle(
                fontFamily: 'Orbitron',
                color: Colors.amber,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [Colors.black, Color(0xFF1B1B1B)],
            center: Alignment(0, -0.3),
            radius: 1.2,
          ),
        ),
        child: Column(
          children: [
            // Pathology info banner
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.amber, width: 1.5),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black.withOpacity(0.4),
                ),
                child: Text(
                  'Detected Pathology: ${widget.result}',
                  style: const TextStyle(
                    fontFamily: 'Orbitron',
                    fontSize: 14,
                    color: Colors.amber,
                    letterSpacing: 1,
                  ),
                ),
              ),
            ),

            // Chat messages
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final message = _messages[index];
                  return ChatBubble(
                    message: message['text'],
                    isBot: message['isBot'],
                  );
                },
              ),
            ),

            // Input field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.8),
                border: const Border(
                  top: BorderSide(color: Colors.amber, width: 1),
                ),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      style: const TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        hintText: 'Ask Aigis...',
                        hintStyle: TextStyle(
                          fontFamily: 'Orbitron',
                          color: Colors.amber.withOpacity(0.6),
                        ),
                        filled: true,
                        fillColor: Colors.black,
                        contentPadding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.amber, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: Colors.amberAccent, width: 2),
                        ),
                      ),
                      onSubmitted: (value) => _sendMessage(value),
                    ),
                  ),
                  const SizedBox(width: 6),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.amber, size: 26),
                    onPressed: () => _sendMessage(_controller.text),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sendBotMessage(String message) {
    setState(() {
      _messages.add({"text": message, "isBot": true});
    });
  }
}

class ChatBubble extends StatelessWidget {
  final String message;
  final bool isBot;

  const ChatBubble({super.key, required this.message, this.isBot = false});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isBot ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        padding: const EdgeInsets.all(14),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isBot ? Colors.black.withOpacity(0.7) : Colors.amber[700],
          border: Border.all(
            color: isBot ? Colors.amber.withOpacity(0.6) : Colors.amber,
            width: 1.2,
          ),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isBot ? const Radius.circular(0) : const Radius.circular(16),
            bottomRight: isBot ? const Radius.circular(16) : const Radius.circular(0),
          ),
          boxShadow: [
            BoxShadow(
              color: isBot
                  ? Colors.amber.withOpacity(0.3)
                  : Colors.amberAccent.withOpacity(0.5),
              blurRadius: 12,
              spreadRadius: 1,
            ),
          ],
        ),
        child: Text(
          message,
          style: TextStyle(
            fontFamily: 'Orbitron',
            color: isBot ? Colors.amber[200] : Colors.black,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
