import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  static const Color primary = Color(0xFF550000);
  static const Color primaryDark = Color(0xFF3A0000);
  static const Color primaryLight = Color(0xFF7A0000);

  static const Color secondary = Color(0xFFF5F5DC);
  static const Color secondaryLight = Color(0xFFFFFEF5);

  static const Color background = Color(0xFFFFFFFF);
  static const Color surface = Color(0xFFFFFFFF);
  static const Color surfaceVariant = Color(0xFFF5F5F5);
  static const Color inputFill = Color(0xFFF5F5F5);

  static const Color textPrimary = Color(0xFF333333);
  static const Color textSecondary = Color(0xFF6B7280);
  static const Color textTertiary = Color(0xFF9CA3AF);
  static const Color textDark = Color(0xFF212121);
  static const Color textMuted = Color(0xFF757575);

  static const Color border = Color(0xFFE5E7EB);
  static const Color divider = Color(0xFFEFF0F6);

  static const Color success = Color(0xFF4CAF50);
  static const Color warning = Color(0xFFFFA726);
  static const Color error = Color(0xFFEF4444);
  static const Color info = Color(0xFF3B82F6);

  static const Color authPrimary = Color(0xFF550000);

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF550000), Color(0xFF7A0000)],
  );

  static const LinearGradient backgroundGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFFFFFFF), Color(0xFFF5F5F5)],
  );

  static const Color darkBackground = Color(0xFF0F1419);
  static const Color darkSurface = Color(0xFF1A1F26);
  static const Color darkSurfaceVariant = Color(0xFF242A32);
  static const Color darkInputFill = Color(0xFF1E242C);

  static const Color darkTextPrimary = Color(0xFFE8EAED);
  static const Color darkTextSecondary = Color(0xFFB4B8BB);
  static const Color darkTextTertiary = Color(0xFF7C8186);

  static const Color darkBorder = Color(0xFF2D3339);
  static const Color darkDivider = Color(0xFF252B33);

  static const List<BoxShadow> cardShadow = [
    BoxShadow(color: Color(0x14550000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> buttonShadow = [
    BoxShadow(color: Color(0x40550000), blurRadius: 16, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> softShadow = [
    BoxShadow(color: Color(0x0A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];

  static const List<BoxShadow> darkCardShadow = [
    BoxShadow(color: Color(0x26000000), blurRadius: 24, offset: Offset(0, 8)),
  ];

  static const List<BoxShadow> darkSoftShadow = [
    BoxShadow(color: Color(0x1A000000), blurRadius: 12, offset: Offset(0, 4)),
  ];
}



