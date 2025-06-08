import 'package:flutter/material.dart';
import 'package:frogames_gpt_app/config/navigation.dart';
import 'package:frogames_gpt_app/config/theme.dart';
import 'package:frogames_gpt_app/core/provider/theme_provider.dart';
import 'package:provider/provider.dart';

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ThemeProvider>(context);
    final materialTheme = MaterialTheme(TextTheme());

    return MaterialApp.router(
      title: 'Frogames-GPT',
      theme: materialTheme.light(),
      darkTheme: materialTheme.dark(),
      themeMode: provider.themeMode,
      debugShowCheckedModeBanner: false,
      routerConfig: Navigation.getRouter(),
    );
  }
}
