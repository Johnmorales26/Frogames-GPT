import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/provider/chat_provider.dart';
import 'package:frogames_gpt_app/features/chat/data/chat.dart';
import 'package:provider/provider.dart';

class ChatListWidget extends StatelessWidget {
  const ChatListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return Column(
      children: provider.chats.map((chat) {
        return InkWell(
          onTap: () {
            provider.setActiveChat(chat);
          },
          child: ListTile(
            title: Text(chat.name, maxLines: 2),
            leading: Icon(Icons.chat),
            trailing: IconButton(
              onPressed: () {
                _showDeleteChatDialog(context, chat, provider);
              },
              icon: Icon(Icons.delete),
            ),
          ),
        );
      }).toList(),
    );
  }

  void _showDeleteChatDialog(
    BuildContext context,
    Chat chat,
    ChatProvider provider,
  ) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Delete chat'),
          content: const Text('Are you sure you want to delete this chat?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                provider.deleteChat(chat);
                Navigator.pop(context);
              },
              child: const Text('Delete', style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }
}
