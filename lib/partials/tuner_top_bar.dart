import 'package:flutter/material.dart';

class TunerTopBar extends StatelessWidget implements PreferredSizeWidget {
  final String tuningName;
  final VoidCallback onSettingsPressed;

  const TunerTopBar({
    Key? key,
    required this.tuningName,
    required this.onSettingsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      color: Theme.of(context).appBarTheme.backgroundColor,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            tuningName,
            style: Theme.of(context).appBarTheme.titleTextStyle,
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: onSettingsPressed,
          )
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}