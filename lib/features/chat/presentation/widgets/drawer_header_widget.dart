import 'package:flutter/material.dart';

class DrawerHeaderWidget extends StatelessWidget {
  const DrawerHeaderWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset('assets/ic_frog_color.png', width: 48, height: 48),
        const SizedBox(width: 8.0),
        Text('Frogames-GPT', style: Theme.of(context).textTheme.titleMedium)
      ]
    );
  }
  
}