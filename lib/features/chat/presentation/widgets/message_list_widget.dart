import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/provider/chat_provider.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/empty_chat_widget.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/message_tile_widget.dart';
import 'package:provider/provider.dart';

class MessageListWidget extends StatelessWidget {
  const MessageListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    final messages = provider.messages ?? [];

    if (messages.isEmpty) {
      return EmptyChatWidget();
    }

    return ListView.builder(
      controller: provider.scrollController,
      itemCount: provider.messages?.length ?? 0,
      itemBuilder: (context, index) {
        final message = provider.messages![index];
        return MessageTileWidget(chatMessage: message);
      },
    );
  }
}
