import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/core/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return AppBar(
      title: Text('Frogames-GPT'),
      actions: [
        IconButton(
          onPressed: () => themeProvider.toggleTheme(),
          icon: themeProvider.themeMode == ThemeMode.dark
              ? const Icon(Icons.light_mode)
              : const Icon(Icons.dark_mode),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
