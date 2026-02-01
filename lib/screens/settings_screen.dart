import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/profile.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.locale,
    required this.onLocaleChanged,
    required this.profile,
    required this.onProfileChanged,
  });

  static const routeName = '/settings';

  final Locale? locale;
  final ValueChanged<Locale?> onLocaleChanged;
  final UserProfile profile;
  final ValueChanged<UserProfile> onProfileChanged;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;
  int? _selectedAvatarColor;
  String? _avatarPath;
  String? _dateOfBirth;
  int _weeklyGoal = 5;

  static const _avatarBaseColors = [
    Color(0xFFEA638C), // Rose
    Color(0xFFFE2F20), // Red
    Color(0xFF0F77BD), // Blue
    Color(0xFFFFCC33), // Yellow
    Color(0xFF95D6A4), // Green
    Color(0xFF805B86), // Purple
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.profile.name ?? '');
    _bioController = TextEditingController(text: widget.profile.bio ?? '');
    _selectedAvatarColor = widget.profile.avatarColorValue;
    _avatarPath = widget.profile.avatarPath;
    _dateOfBirth = widget.profile.dateOfBirth;
    _weeklyGoal = widget.profile.gongyoWeeklyGoal;
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.profile.name != widget.profile.name) {
      _nameController.text = widget.profile.name ?? '';
    }
    if (oldWidget.profile.bio != widget.profile.bio) {
      _bioController.text = widget.profile.bio ?? '';
    }
    if (oldWidget.profile.avatarColorValue != widget.profile.avatarColorValue) {
      _selectedAvatarColor = widget.profile.avatarColorValue;
    }
    if (oldWidget.profile.avatarPath != widget.profile.avatarPath) {
      _avatarPath = widget.profile.avatarPath;
    }
    if (oldWidget.profile.dateOfBirth != widget.profile.dateOfBirth) {
      _dateOfBirth = widget.profile.dateOfBirth;
    }
    if (oldWidget.profile.gongyoWeeklyGoal != widget.profile.gongyoWeeklyGoal) {
      _weeklyGoal = widget.profile.gongyoWeeklyGoal;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _notifyProfileChanged() {
    widget.onProfileChanged(
      widget.profile.copyWith(
        name: _nameController.text.trim().isEmpty
            ? null
            : _nameController.text.trim(),
        bio: _bioController.text.trim().isEmpty
            ? null
            : _bioController.text.trim(),
        avatarColorValue: _selectedAvatarColor,
        avatarPath: _avatarPath,
        dateOfBirth: _dateOfBirth,
        gongyoWeeklyGoal: _weeklyGoal,
      ),
    );
  }

  int? _calculateAge(String? value) {
    if (value == null || value.isEmpty) {
      return null;
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return null;
    }
    final now = DateTime.now();
    var age = now.year - parsed.year;
    final hadBirthday = (now.month > parsed.month) ||
        (now.month == parsed.month && now.day >= parsed.day);
    if (!hadBirthday) {
      age -= 1;
    }
    return age < 0 ? null : age;
  }

  String _formatDob(String? value, Locale? locale) {
    if (value == null || value.isEmpty) {
      return '';
    }
    final parsed = DateTime.tryParse(value);
    if (parsed == null) {
      return '';
    }
    final isEnglish = (locale?.languageCode ?? 'en') == 'en';
    if (isEnglish) {
      return '${parsed.month.toString().padLeft(2, '0')}/'
          '${parsed.day.toString().padLeft(2, '0')}/'
          '${parsed.year}';
    }
    return '${parsed.day.toString().padLeft(2, '0')}/'
        '${parsed.month.toString().padLeft(2, '0')}/'
        '${parsed.year}';
  }

  Future<void> _pickDateOfBirth() async {
    final initial = DateTime.tryParse(_dateOfBirth ?? '') ??
        DateTime(DateTime.now().year - 25, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) {
      return;
    }
    setState(() {
      _dateOfBirth = '${picked.year.toString().padLeft(4, '0')}-'
          '${picked.month.toString().padLeft(2, '0')}-'
          '${picked.day.toString().padLeft(2, '0')}';
    });
    _notifyProfileChanged();
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );
    if (image == null) {
      return;
    }
    final directory = await getApplicationDocumentsDirectory();
    final targetPath =
        '${directory.path}/profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(image.path).copy(targetPath);
    if (!mounted) {
      return;
    }
    setState(() {
      _avatarPath = saved.path;
    });
    _notifyProfileChanged();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final avatarColors = [
      ..._avatarBaseColors,
      isDark ? const Color(0xFFFDF6EC) : const Color(0xFF0F1A18),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsTitle),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.settingsProfileTitle, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l10n.settingsProfileNameDescription,
              style: textTheme.bodyMedium),
          const SizedBox(height: 12),
          _ProfileAvatar(
            name: _nameController.text,
            colorValue: _selectedAvatarColor,
            imagePath: _avatarPath,
            fallbackColor: Theme.of(context).colorScheme.primary,
            onRemoveImage: _avatarPath == null
                ? null
                : () {
                    setState(() {
                      _avatarPath = null;
                    });
                    _notifyProfileChanged();
                  },
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickAvatar(ImageSource.camera),
                  icon: const Icon(Icons.photo_camera_outlined),
                  label: Text(l10n.settingsProfileAvatarCamera),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () => _pickAvatar(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library_outlined),
                  label: Text(l10n.settingsProfileAvatarGallery),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _nameController,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.settingsProfileNameLabel,
              hintText: l10n.settingsProfileNameHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => _notifyProfileChanged(),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _bioController,
            maxLines: 2,
            textInputAction: TextInputAction.done,
            decoration: InputDecoration(
              labelText: l10n.settingsProfileBioLabel,
              hintText: l10n.settingsProfileBioHint,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: (_) => _notifyProfileChanged(),
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 12),
          Text(l10n.settingsProfileDobLabel, style: textTheme.bodyMedium),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: _pickDateOfBirth,
                  child: Text(
                    _dateOfBirth == null
                        ? l10n.settingsProfileDobPick
                        : _formatDob(_dateOfBirth, widget.locale),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (_calculateAge(_dateOfBirth) != null)
                Text(
                  l10n.settingsProfileAge(
                    _calculateAge(_dateOfBirth)!,
                  ),
                  style: textTheme.bodyMedium,
                ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            l10n.settingsProfileAvatarTitle,
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            runAlignment: WrapAlignment.spaceBetween,
            runSpacing: 10,
            children: [
              for (final color in avatarColors)
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedAvatarColor = color.toARGB32();
                    });
                    _notifyProfileChanged();
                  },
                  child: _AvatarColorSwatch(
                    color: color,
                    isSelected: _selectedAvatarColor == color.toARGB32(),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          Text(l10n.settingsGongyoGoalTitle, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(l10n.settingsProfileWeeklyGoalLabel,
              style: textTheme.bodyMedium),
          const SizedBox(height: 6),
          LayoutBuilder(
            builder: (context, constraints) {
              final maxWidth = constraints.maxWidth;
              final targetSliderWidth = 220.0;
              final targetLabelWidth = 120.0;
              const gap = 12.0;
              final availableForSlider =
                  (maxWidth - gap - targetLabelWidth).clamp(140.0, 220.0);
              final sliderWidth = availableForSlider < targetSliderWidth
                  ? availableForSlider
                  : targetSliderWidth;
              final labelWidth =
                  (maxWidth - sliderWidth - gap).clamp(64.0, targetLabelWidth);

              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: sliderWidth,
                    child: Slider(
                      value: _weeklyGoal.toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      onChanged: (value) {
                        setState(() {
                          _weeklyGoal = value.round();
                        });
                        _notifyProfileChanged();
                      },
                    ),
                  ),
                  const SizedBox(width: gap),
                  SizedBox(
                    width: labelWidth,
                    child: Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        child: Text(
                          l10n.settingsProfileWeeklyGoalValue(_weeklyGoal),
                          style: textTheme.bodyMedium,
                        ),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: 24),
          const Divider(height: 1),
          const SizedBox(height: 24),
          Text(l10n.settingsLanguageTitle, style: textTheme.titleMedium),
          const SizedBox(height: 4),
          Text(l10n.settingsLanguageDescription, style: textTheme.bodyMedium),
          const SizedBox(height: 12),
          DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Theme.of(context)
                    .colorScheme
                    .outline
                    .withValues(alpha: 0.2),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: DropdownButton<Locale?>(
                isExpanded: true,
                value: widget.locale ?? const Locale('en'),
                underline: const SizedBox.shrink(),
                onChanged: widget.onLocaleChanged,
                items: [
                  DropdownMenuItem<Locale?>(
                    value: const Locale('en'),
                    child: Text(l10n.settingsLanguageEnglish),
                  ),
                  DropdownMenuItem<Locale?>(
                    value: const Locale('pt', 'BR'),
                    child: Text(l10n.settingsLanguagePortuguese),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ProfileAvatar extends StatelessWidget {
  const _ProfileAvatar({
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
    if (text.isEmpty) {
      return '?';
    }
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

class _AvatarColorSwatch extends StatelessWidget {
  const _AvatarColorSwatch({
    required this.color,
    required this.isSelected,
  });

  final Color color;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      width: 34,
      height: 34,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(
          color: isSelected
              ? Theme.of(context).colorScheme.primary
              : Colors.transparent,
          width: 2,
        ),
      ),
    );
  }
}
