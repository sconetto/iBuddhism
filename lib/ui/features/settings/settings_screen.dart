import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../app/app_view_model.dart';
import 'settings_view_model.dart';
import 'widgets/profile_avatar.dart';
import 'widgets/avatar_color_swatch.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({
    super.key,
    required this.viewModel,
    required this.appViewModel,
  });

  static const routeName = '/settings';

  final SettingsViewModel viewModel;
  final AppViewModel appViewModel;

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  late TextEditingController _bioController;

  @override
  void initState() {
    super.initState();
    widget.viewModel.addListener(_onViewModelChanged);
    _nameController = TextEditingController(text: widget.viewModel.name);
    _bioController = TextEditingController(text: widget.viewModel.bio);
  }

  @override
  void didUpdateWidget(covariant SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.viewModel != widget.viewModel) {
      oldWidget.viewModel.removeListener(_onViewModelChanged);
      widget.viewModel.addListener(_onViewModelChanged);
    }
  }

  @override
  void dispose() {
    widget.viewModel.removeListener(_onViewModelChanged);
    _nameController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  void _onViewModelChanged() {
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final textTheme = Theme.of(context).textTheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final vm = widget.viewModel;
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
          ProfileAvatar(
            name: vm.name,
            colorValue: vm.selectedAvatarColor,
            imagePath: vm.avatarPath,
            fallbackColor: Theme.of(context).colorScheme.primary,
            onRemoveImage:
                vm.avatarPath == null ? null : () => vm.removeAvatar(),
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
            onChanged: vm.updateName,
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
            onChanged: vm.updateBio,
            onSubmitted: (_) => FocusScope.of(context).unfocus(),
          ),
          const SizedBox(height: 12),
          Text(l10n.settingsProfileDobLabel, style: textTheme.bodyMedium),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () => _pickDateOfBirth(context),
                  child: Text(
                    vm.dateOfBirth == null
                        ? l10n.settingsProfileDobPick
                        : vm.formatDob(vm.dateOfBirth, vm.locale),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              if (vm.calculateAge(vm.dateOfBirth) != null)
                Text(
                  l10n.settingsProfileAge(
                    vm.calculateAge(vm.dateOfBirth)!,
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
                  onTap: () => vm.selectAvatarColor(color.toARGB32()),
                  child: AvatarColorSwatch(
                    color: color,
                    isSelected: vm.selectedAvatarColor == color.toARGB32(),
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
                      value: vm.weeklyGoal.toDouble(),
                      min: 1,
                      max: 7,
                      divisions: 6,
                      onChanged: (value) => vm.updateWeeklyGoal(value.round()),
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
                          l10n.settingsProfileWeeklyGoalValue(vm.weeklyGoal),
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
                value: widget.appViewModel.locale,
                underline: const SizedBox.shrink(),
                onChanged: widget.appViewModel.updateLocale,
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

  Future<void> _pickDateOfBirth(BuildContext context) async {
    final initial = DateTime.tryParse(widget.viewModel.dateOfBirth ?? '') ??
        DateTime(DateTime.now().year - 25, 1, 1);
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    final value = '${picked.year.toString().padLeft(4, '0')}-'
        '${picked.month.toString().padLeft(2, '0')}-'
        '${picked.day.toString().padLeft(2, '0')}';
    widget.viewModel.setDateOfBirth(value);
  }

  Future<void> _pickAvatar(ImageSource source) async {
    final picker = ImagePicker();
    final image = await picker.pickImage(
      source: source,
      maxWidth: 600,
      maxHeight: 600,
      imageQuality: 85,
    );
    if (image == null) return;
    final directory = await getApplicationDocumentsDirectory();
    final targetPath =
        '${directory.path}/profile_avatar_${DateTime.now().millisecondsSinceEpoch}.jpg';
    final saved = await File(image.path).copy(targetPath);
    if (!mounted) return;
    widget.viewModel.setAvatarPath(saved.path);
  }
}

const _avatarBaseColors = [
  Color(0xFFEA638C),
  Color(0xFFFE2F20),
  Color(0xFF0F77BD),
  Color(0xFFFFCC33),
  Color(0xFF95D6A4),
  Color(0xFF805B86),
];
