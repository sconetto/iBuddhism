import 'package:flutter/material.dart';
import 'package:ibuddhism/l10n/app_localizations.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

import '../theme/app_materials.dart';

const double kBottomBarHeight = 96.0;

enum NavTab { home, gongyo, library }

class GlassNavBar extends StatelessWidget {
  const GlassNavBar({
    super.key,
    required this.activeTab,
    required this.onHomeTap,
    required this.onGongyoTap,
    required this.onLibraryTap,
    this.isCollapsed = false,
    this.onExpandRequested,
  });

  final NavTab activeTab;
  final bool isCollapsed;
  final VoidCallback onHomeTap;
  final VoidCallback onGongyoTap;
  final VoidCallback onLibraryTap;
  final VoidCallback? onExpandRequested;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context)!;
    final glass =
        Theme.of(context).extension<GlassMaterial>() ?? defaultGlassMaterial;
    final tabs = isCollapsed
        ? [activeTab]
        : [NavTab.home, NavTab.gongyo, NavTab.library];

    return SafeArea(
      top: false,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        height: kBottomBarHeight,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: LayoutBuilder(
            builder: (context, constraints) {
              final fullWidth = constraints.maxWidth;
              const collapsedWidth = kBottomBarHeight;
              final targetWidth = isCollapsed
                  ? (fullWidth < collapsedWidth ? fullWidth : collapsedWidth)
                  : fullWidth;

              return AnimatedAlign(
                duration: const Duration(milliseconds: 220),
                curve: Curves.easeOutCubic,
                alignment:
                    isCollapsed ? Alignment.bottomLeft : Alignment.bottomCenter,
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 220),
                  curve: Curves.easeOutCubic,
                  tween: Tween<double>(begin: fullWidth, end: targetWidth),
                  builder: (context, width, child) {
                    final rawT = fullWidth <= collapsedWidth
                        ? 1.0
                        : (width - collapsedWidth) /
                            (fullWidth - collapsedWidth);
                    final labelVisibility =
                        Curves.easeOutCubic.transform(rawT.clamp(0.0, 1.0));
                    final content = LiquidGlassLayer(
                      fake: false,
                      settings: LiquidGlassSettings(
                        thickness: 10,
                        blur: glass.blurSigma,
                        glassColor: colorScheme.surface.withValues(alpha: 0.10),
                        lightIntensity: 1.5,
                        saturation: 1.2,
                      ),
                      child: LiquidGlassBlendGroup(
                        blend: 18,
                        child: LiquidGlass.grouped(
                          shape: LiquidRoundedSuperellipse(
                            borderRadius: glass.cornerRadius,
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(glass.cornerRadius),
                              border: Border.all(
                                color: colorScheme.outline
                                    .withValues(alpha: glass.borderAlpha),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: colorScheme.shadow
                                      .withValues(alpha: glass.shadowAlpha),
                                  blurRadius: 18,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: AnimatedSwitcher(
                              duration: const Duration(milliseconds: 200),
                              switchInCurve: Curves.easeOutCubic,
                              switchOutCurve: Curves.easeOutCubic,
                              transitionBuilder: (child, animation) {
                                return FadeTransition(
                                  opacity: animation,
                                  child: ScaleTransition(
                                    scale: Tween<double>(
                                      begin: 0.98,
                                      end: 1.0,
                                    ).animate(animation),
                                    child: child,
                                  ),
                                );
                              },
                              child: isCollapsed
                                  ? Center(
                                      key: const ValueKey('collapsed'),
                                      child: _buildTab(
                                        tabs.first,
                                        textTheme,
                                        l10n,
                                        0.0,
                                      ),
                                    )
                                  : Row(
                                      key: const ValueKey('expanded'),
                                      mainAxisSize: MainAxisSize.max,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        for (int i = 0;
                                            i < tabs.length;
                                            i++) ...[
                                          Expanded(
                                            child: _buildTab(
                                              tabs[i],
                                              textTheme,
                                              l10n,
                                              labelVisibility,
                                            ),
                                          ),
                                          if (i != tabs.length - 1)
                                            const SizedBox(width: 10),
                                        ],
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      ),
                    );
                    return SizedBox(
                      width: width,
                      child: isCollapsed
                          ? GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: onExpandRequested,
                              child: content,
                            )
                          : content,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
    NavTab tab,
    TextTheme textTheme,
    AppLocalizations l10n,
    double labelVisibility,
  ) {
    VoidCallback wrapTap(VoidCallback tap) {
      return () {
        if (isCollapsed) {
          onExpandRequested?.call();
          return;
        }
        tap();
      };
    }

    switch (tab) {
      case NavTab.home:
        return _NavGlassButton(
          label: l10n.navHome,
          icon: Icons.home_outlined,
          isActive: activeTab == NavTab.home,
          labelVisibility: labelVisibility,
          onTap: wrapTap(onHomeTap),
          textTheme: textTheme,
        );
      case NavTab.gongyo:
        return _NavGlassButton(
          label: l10n.navGongyo,
          icon: Icons.self_improvement,
          isActive: activeTab == NavTab.gongyo,
          labelVisibility: labelVisibility,
          onTap: wrapTap(onGongyoTap),
          textTheme: textTheme,
        );
      case NavTab.library:
        return _NavGlassButton(
          label: l10n.navLibrary,
          icon: Icons.menu_book_outlined,
          isActive: activeTab == NavTab.library,
          labelVisibility: labelVisibility,
          onTap: wrapTap(onLibraryTap),
          textTheme: textTheme,
        );
    }
  }
}

class _NavGlassButton extends StatelessWidget {
  const _NavGlassButton({
    required this.label,
    required this.icon,
    required this.isActive,
    required this.labelVisibility,
    required this.onTap,
    required this.textTheme,
  });

  final String label;
  final IconData icon;
  final bool isActive;
  final double labelVisibility;
  final VoidCallback onTap;
  final TextTheme textTheme;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final t = labelVisibility.clamp(0.0, 1.0);
    final iconSize = 22.0 - (2.0 * t);
    final horizontalPadding = 8.0 + (2.0 * t);
    final labelStyle = textTheme.bodySmall?.copyWith(
      fontWeight: FontWeight.w600,
      height: 1.0,
    );

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        height: double.infinity,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.16)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: isActive ? colorScheme.primary : colorScheme.onSurface,
            ),
            ClipRect(
              child: Align(
                heightFactor: t,
                child: Opacity(
                  opacity: t,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 1),
                    child: Text(
                      label,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      softWrap: false,
                      style: isActive
                          ? labelStyle?.copyWith(color: colorScheme.primary)
                          : labelStyle,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
