import 'package:flutter/material.dart';

@immutable
class GlassMaterial extends ThemeExtension<GlassMaterial> {
  const GlassMaterial({
    required this.blurSigma,
    required this.surfaceAlpha,
    required this.borderAlpha,
    required this.shadowAlpha,
    required this.cornerRadius,
  });

  final double blurSigma;
  final double surfaceAlpha;
  final double borderAlpha;
  final double shadowAlpha;
  final double cornerRadius;

  @override
  GlassMaterial copyWith({
    double? blurSigma,
    double? surfaceAlpha,
    double? borderAlpha,
    double? shadowAlpha,
    double? cornerRadius,
  }) {
    return GlassMaterial(
      blurSigma: blurSigma ?? this.blurSigma,
      surfaceAlpha: surfaceAlpha ?? this.surfaceAlpha,
      borderAlpha: borderAlpha ?? this.borderAlpha,
      shadowAlpha: shadowAlpha ?? this.shadowAlpha,
      cornerRadius: cornerRadius ?? this.cornerRadius,
    );
  }

  @override
  GlassMaterial lerp(ThemeExtension<GlassMaterial>? other, double t) {
    if (other is! GlassMaterial) {
      return this;
    }
    return GlassMaterial(
      blurSigma: lerpDouble(blurSigma, other.blurSigma, t),
      surfaceAlpha: lerpDouble(surfaceAlpha, other.surfaceAlpha, t),
      borderAlpha: lerpDouble(borderAlpha, other.borderAlpha, t),
      shadowAlpha: lerpDouble(shadowAlpha, other.shadowAlpha, t),
      cornerRadius: lerpDouble(cornerRadius, other.cornerRadius, t),
    );
  }

  double lerpDouble(double a, double b, double t) => a + (b - a) * t;
}

const GlassMaterial defaultGlassMaterial = GlassMaterial(
  blurSigma: 24,
  surfaceAlpha: 0.55,
  borderAlpha: 0.18,
  shadowAlpha: 0.08,
  cornerRadius: 28,
);
