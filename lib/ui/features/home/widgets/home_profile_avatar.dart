import 'dart:io';

import 'package:flutter/material.dart';

import '../../../../models/profile.dart';

class HomeProfileAvatar extends StatelessWidget {
  const HomeProfileAvatar({super.key, required this.profile});

  final UserProfile profile;

  String _initials(String? value) {
    final text = (value ?? '').trim();
    if (text.isEmpty) return '?';
    final parts = text.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts.first.characters.take(2).toString().toUpperCase();
    }
    return (parts.first.characters.take(1).toString() +
            parts.last.characters.take(1).toString())
        .toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    final fallbackColor = Theme.of(context).colorScheme.primary;
    final color = profile.avatarColorValue != null
        ? Color(profile.avatarColorValue!)
        : fallbackColor;
    final imagePath = profile.avatarPath;
    final file = imagePath != null ? File(imagePath) : null;
    final hasImage = file != null && file.existsSync();
    final textColor =
        color.computeLuminance() > 0.7 ? Colors.black : Colors.white;

    return CircleAvatar(
      radius: 16,
      backgroundColor: color.withValues(alpha: 0.15),
      child: CircleAvatar(
        radius: 14,
        backgroundColor: color,
        backgroundImage: hasImage ? FileImage(file) : null,
        child: hasImage
            ? null
            : Text(
                _initials(profile.name),
                style: Theme.of(context)
                    .textTheme
                    .labelSmall
                    ?.copyWith(color: textColor),
              ),
      ),
    );
  }
}
