import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:medicine_app/constant/app_color.dart';

/// Reusable avatar widget that handles:
/// 1. Preset avatar keys (e.g. 'avatar_male_1' -> 👨)
/// 2. Local file paths (e.g. from camera / gallery)
/// 3. Network image URLs (e.g. from Firebase auth photo URL)
/// 4. Asset image fallback ('assets/images/avatar.png')
class UserAvatarWidget extends StatelessWidget {
  final String? avatarPath;
  final double radius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderWidth;
  final VoidCallback? onTap;

  static const Map<String, String> presetEmojis = {
    'avatar_male_1': '👨',
    'avatar_female_1': '👩',
    'avatar_doctor_m': '👨‍⚕️',
    'avatar_doctor_f': '👩‍⚕️',
    'avatar_senior_m': '👴',
    'avatar_senior_f': '👵',
  };

  const UserAvatarWidget({
    super.key,
    this.avatarPath,
    this.radius = 24.0,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth = 0.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content;
    final path = avatarPath?.trim();

    if (path != null && path.isNotEmpty) {
      if (presetEmojis.containsKey(path)) {
        // Preset emoji avatar
        final emoji = presetEmojis[path]!;
        content = Container(
          width: radius * 2,
          height: radius * 2,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: backgroundColor ?? AppColors.primaryColor.withValues(alpha: 0.15),
          ),
          child: Text(
            emoji,
            style: TextStyle(fontSize: radius * 1.05),
          ),
        );
      } else if (path.startsWith('http://') || path.startsWith('https://')) {
        // Network image
        content = ClipOval(
          child: CachedNetworkImage(
            imageUrl: path,
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              width: radius * 2,
              height: radius * 2,
              color: Colors.grey.shade200,
              child: const Center(
                child: SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(strokeWidth: 2),
                ),
              ),
            ),
            errorWidget: (context, url, error) => _fallbackWidget(),
          ),
        );
      } else if (File(path).existsSync()) {
        // Local file
        content = ClipOval(
          child: Image.file(
            File(path),
            width: radius * 2,
            height: radius * 2,
            fit: BoxFit.cover,
            errorBuilder: (_, __, ___) => _fallbackWidget(),
          ),
        );
      } else {
        // Unknown or missing file
        content = _fallbackWidget();
      }
    } else {
      // Null or empty
      content = _fallbackWidget();
    }

    Widget avatarWidget = Container(
      width: radius * 2,
      height: radius * 2,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: borderColor != null && borderWidth > 0
            ? Border.all(color: borderColor!, width: borderWidth)
            : null,
      ),
      child: content,
    );

    if (onTap != null) {
      return GestureDetector(
        onTap: onTap,
        child: avatarWidget,
      );
    }

    return avatarWidget;
  }

  Widget _fallbackWidget() {
    return ClipOval(
      child: Image.asset(
        'assets/images/avatar.png',
        width: radius * 2,
        height: radius * 2,
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => Container(
          width: radius * 2,
          height: radius * 2,
          color: AppColors.primaryColor.withValues(alpha: 0.15),
          child: Icon(
            Icons.person,
            size: radius * 1.2,
            color: AppColors.primaryColor,
          ),
        ),
      ),
    );
  }
}
