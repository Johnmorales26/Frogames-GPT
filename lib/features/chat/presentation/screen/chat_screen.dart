import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/provider/chat_provider.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/app_bar_widget.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/chat_input_widget.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/chat_list_widget.dart';
import 'package:frogames_gpt_app/features/chat/presentation/widgets/drawer_header_widget.dart';
import 'package:provider/provider.dart';

class ChatScreen extends StatelessWidget {
  const ChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    provider.fetchChats();

    return Scaffold(
      appBar: AppBarWidget(),
      body: SafeArea(child: ChatInputWidget()),
      drawer: NavigationDrawer(
        selectedIndex: provider.selectedIndex,
        onDestinationSelected: (index) {
          provider.setSelectedIndex(index);
          Navigator.pop(context);
        },
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 16.0,
              top: 4.0,
              left: 16.0,
              right: 16.0,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const DrawerHeaderWidget(),
                  const SizedBox(height: 16.0),
                  ChatListWidget(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
