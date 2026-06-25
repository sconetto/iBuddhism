import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

class ProfileAvatar extends StatelessWidget {
  const ProfileAvatar({
    super.key,
    required this.name,
    required this.colorValue,
    required this.imagePath,
    required this.fallbackColor,
    required this.onRemoveImage,
  });

  final String? name;
  final int? colorValue;
  final String? imagePath;
  final Color fallbackColor;
  final VoidCallback? onRemoveImage;

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
    final l10n = AppLocalizations.of(context)!;
    final color = colorValue != null ? Color(colorValue!) : fallbackColor;
    final imageFile = imagePath != null ? File(imagePath!) : null;
    final hasImage = imageFile != null && imageFile.existsSync();
    final textColor =
        color.computeLuminance() > 0.7 ? Colors.black : Colors.white;
    final colorScheme = Theme.of(context).colorScheme;
    const avatarSize = 64.0;
    const removeSize = 20.0;
    const removeInset = 4.0;
    return LayoutBuilder(
      builder: (context, constraints) {
        final rightOffset =
            (constraints.maxWidth - avatarSize) / 2 - removeInset;
        return SizedBox(
          width: double.infinity,
          height: avatarSize,
          child: Stack(
            alignment: Alignment.center,
            children: [
              CircleAvatar(
                radius: 32,
                backgroundColor: color.withValues(alpha: 0.15),
                child: CircleAvatar(
                  radius: 28,
                  backgroundColor: color,
                  backgroundImage: hasImage ? FileImage(imageFile) : null,
                  child: !hasImage
                      ? Text(
                          _initials(name),
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: textColor),
                        )
                      : null,
                ),
              ),
              if (hasImage)
                Positioned(
                  right: rightOffset,
                  bottom: removeInset,
                  child: Tooltip(
                    message: l10n.settingsProfileAvatarRemove,
                    child: Material(
                      color: colorScheme.surface.withValues(alpha: 0.8),
                      shape: const CircleBorder(),
                      child: InkWell(
                        customBorder: const CircleBorder(),
                        onTap: onRemoveImage,
                        child: const SizedBox(
                          width: removeSize,
                          height: removeSize,
                          child: Center(
                            child: Text(
                              '❌',
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
