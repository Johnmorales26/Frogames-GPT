import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/config/routes.dart';
import 'package:frogames_gpt_app/features/chat/presentation/screen/chat_screen.dart';
import 'package:go_router/go_router.dart';

class Navigation {
  static GoRouter getRouter() {
    return GoRouter(
      routes: [
        GoRoute(
          path: Routes.chatRoute,
          builder: (BuildContext context, GoRouterState state) {
            return const ChatScreen();
          },
        ),
      ],
    );
  }
}
