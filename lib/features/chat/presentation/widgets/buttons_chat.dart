import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frogames_gpt_app/core/provider/chat_provider.dart';
import 'package:provider/provider.dart';

class ButtonsChat extends StatelessWidget {
  const ButtonsChat({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ChatProvider>(context);

    return InkWell(
      onTap: () {
        provider.sendNewMessage();
      },
      child: Container(
        width: 48.0,
        height: 48.0,
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.primary,
          borderRadius: BorderRadius.circular(46),
        ),
        child: Center(
          child: SizedBox(
            width: 24.0,
            height: 24.0,
            child: SvgPicture.asset(
              'assets/ic_send.svg',
              color: Theme.of(context).colorScheme.onPrimary,
            ),
          ),
        ),
      ),
    );
  }
}
