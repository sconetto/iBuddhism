import 'package:flutter/material.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';

import '../../../core/widgets/glass_nav_bar.dart';
import '../../../core/theme/app_materials.dart';

class GongyoControlBar extends StatelessWidget {
  const GongyoControlBar({
    super.key,
    required this.isPlaying,
    required this.isAtStart,
    required this.onPause,
    required this.onResume,
    required this.onRestart,
    required this.onStop,
  });

  final bool isPlaying;
  final bool isAtStart;
  final VoidCallback onPause;
  final VoidCallback onResume;
  final VoidCallback onRestart;
  final VoidCallback onStop;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final colorScheme = Theme.of(context).colorScheme;
    final glass =
        Theme.of(context).extension<GlassMaterial>() ?? defaultGlassMaterial;
    final stopLabel =
        (isAtStart && !isPlaying) ? l10n.gongyoExit : l10n.gongyoStop;
    return SafeArea(
      top: false,
      child: SizedBox(
        height: kBottomBarHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: GlassContainer(
            useOwnLayer: true,
            settings: LiquidGlassSettings(
              thickness: 10,
              blur: glass.blurSigma,
              glassColor: colorScheme.surface.withValues(alpha: 0.10),
              lightIntensity: 1.5,
              saturation: 1.2,
            ),
            shape: LiquidRoundedSuperellipse(
              borderRadius: glass.cornerRadius,
            ),
            clipBehavior: Clip.antiAlias,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(glass.cornerRadius),
                border: Border.all(
                  color:
                      colorScheme.outline.withValues(alpha: glass.borderAlpha),
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        colorScheme.shadow.withValues(alpha: glass.shadowAlpha),
                    blurRadius: 18,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: _ControlGlassButton(
                      label: isPlaying
                          ? l10n.gongyoPause
                          : (isAtStart ? l10n.gongyoStart : l10n.gongyoResume),
                      icon: isPlaying ? Icons.pause : Icons.play_arrow,
                      onTap: isPlaying ? onPause : onResume,
                      isActive: true,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ControlGlassButton(
                      label: l10n.gongyoRestart,
                      icon: Icons.refresh,
                      onTap: onRestart,
                      isActive: false,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _ControlGlassButton(
                      label: stopLabel,
                      icon: Icons.stop_circle_outlined,
                      onTap: onStop,
                      isActive: false,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _ControlGlassButton extends StatelessWidget {
  const _ControlGlassButton({
    required this.label,
    required this.icon,
    required this.onTap,
    required this.isActive,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 20, color: colorScheme.onSurface),
            const SizedBox(height: 2),
            Text(
              label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              softWrap: false,
              style: textTheme.bodySmall?.copyWith(fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }
}
