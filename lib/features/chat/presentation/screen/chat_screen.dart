import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/app_bar_widget.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/chat_input_widget.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(child: ChatInputWidget()),
    );
  }
}
