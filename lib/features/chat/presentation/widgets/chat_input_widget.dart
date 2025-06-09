import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/provider/chat_provider.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/buttons_chat.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/message_list_widget.dart';
import 'package:provider/provider.dart';

class ChatInputWidget extends StatelessWidget {
  const ChatInputWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Expanded(child: MessageListWidget()),

          Row(
            children: [
              Expanded(
                child: TextField(
                  readOnly: provider.isLoadResponse,
                  controller: provider.messageController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    hintText: 'Ask what you want',
                  ),
                ),
              ),
              const SizedBox(width: 8.0),
              ButtonsChat(),
            ],
          ),
        ],
      ),
    );
  }
}
