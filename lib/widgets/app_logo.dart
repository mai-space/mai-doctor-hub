import 'package:flutter/material.dart';

/// App-Logo (gleiche Vorlage wie das Launcher-Icon, tool/generate_icons.py).
class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 40});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      'assets/branding/logo.png',
      width: size,
      height: size,
      semanticLabel: 'Mai Doctor Hub',
    );
  }
}

/// Logo + Schriftzug „Mai Doctor Hub“.
class AppWordmark extends StatelessWidget {
  const AppWordmark({super.key, this.subtitle});

  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        const AppLogo(size: 44),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: 'Mai ',
                      style: TextStyle(
                        color: theme.colorScheme.primary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const TextSpan(text: 'Doctor Hub'),
                  ],
                ),
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.3,
                ),
              ),
              if (subtitle != null)
                Text(
                  subtitle!,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
