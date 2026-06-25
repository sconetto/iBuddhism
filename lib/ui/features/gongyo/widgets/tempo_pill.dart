import 'package:flutter/material.dart';

class TempoPill extends StatelessWidget {
  const TempoPill({
    super.key,
    required this.value,
    required this.color,
    this.textStyle,
  });

  final String value;
  final Color color;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final textColor =
        color.computeLuminance() > 0.6 ? Colors.black : Colors.white;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        value,
        style: textStyle?.copyWith(
          color: textColor,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
