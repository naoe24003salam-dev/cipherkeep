import 'package:flutter/material.dart';

/// Application-wide constants
class AppConstants {
  // Animation Durations
  static const Duration fastAnimation = Duration(milliseconds: 200);
  static const Duration normalAnimation = Duration(milliseconds: 300);
  static const Duration slowAnimation = Duration(milliseconds: 500);

  // Border Radius
  static const double radiusSmall = 8.0;
  static const double radiusMedium = 12.0;
  static const double radiusLarge = 16.0;
  static const double radiusXLarge = 24.0;

  // Padding & Margins
  static const double paddingXSmall = 4.0;
  static const double paddingSmall = 8.0;
  static const double paddingMedium = 16.0;
  static const double paddingLarge = 24.0;
  static const double paddingXLarge = 32.0;

  // Icon Sizes
  static const double iconSmall = 16.0;
  static const double iconMedium = 24.0;
  static const double iconLarge = 32.0;
  static const double iconXLarge = 48.0;

  // Font Sizes
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeXLarge = 20.0;
  static const double fontSizeXXLarge = 24.0;
  static const double fontSizeDisplay = 32.0;

  // Elevation Levels
  static const double elevationNone = 0.0;
  static const double elevationLow = 2.0;
  static const double elevationMedium = 4.0;
  static const double elevationHigh = 8.0;
  static const double elevationXHigh = 16.0;

  // Opacity Levels
  static const double opacityDisabled = 0.38;
  static const double opacityMedium = 0.60;
  static const double opacityLight = 0.87;

  // Touch Targets (Accessibility)
  static const double minTouchTarget = 48.0;

  // List Item Heights
  static const double listItemHeight = 72.0;
  static const double listItemHeightCompact = 56.0;

  // PIN Pad
  static const double pinPadButtonSize = 72.0;
  static const double pinPadButtonSpacing = 16.0;
  static const double pinDotSize = 12.0;
  static const double pinDotSpacing = 8.0;

  // Card Dimensions
  static const double cardMaxWidth = 400.0;
  static const double cardMinHeight = 100.0;

  // Image Constraints
  static const double maxImageWidth = 1920.0;
  static const double maxImageHeight = 1080.0;
  static const double thumbnailSize = 100.0;

  // Transition Curves
  static const Curve defaultCurve = Curves.easeInOut;
  static const Curve bounceCurve = Curves.elasticOut;
  static const Curve snapCurve = Curves.easeOutBack;
}

/// Common edge insets for consistent spacing
class AppPadding {
  static const EdgeInsets all4 = EdgeInsets.all(AppConstants.paddingXSmall);
  static const EdgeInsets all8 = EdgeInsets.all(AppConstants.paddingSmall);
  static const EdgeInsets all16 = EdgeInsets.all(AppConstants.paddingMedium);
  static const EdgeInsets all24 = EdgeInsets.all(AppConstants.paddingLarge);
  static const EdgeInsets all32 = EdgeInsets.all(AppConstants.paddingXLarge);

  static const EdgeInsets h8 =
      EdgeInsets.symmetric(horizontal: AppConstants.paddingSmall);
  static const EdgeInsets h16 =
      EdgeInsets.symmetric(horizontal: AppConstants.paddingMedium);
  static const EdgeInsets h24 =
      EdgeInsets.symmetric(horizontal: AppConstants.paddingLarge);

  static const EdgeInsets v8 =
      EdgeInsets.symmetric(vertical: AppConstants.paddingSmall);
  static const EdgeInsets v16 =
      EdgeInsets.symmetric(vertical: AppConstants.paddingMedium);
  static const EdgeInsets v24 =
      EdgeInsets.symmetric(vertical: AppConstants.paddingLarge);
}

/// Common border radius values
class AppRadius {
  static const BorderRadius small =
      BorderRadius.all(Radius.circular(AppConstants.radiusSmall));
  static const BorderRadius medium =
      BorderRadius.all(Radius.circular(AppConstants.radiusMedium));
  static const BorderRadius large =
      BorderRadius.all(Radius.circular(AppConstants.radiusLarge));
  static const BorderRadius xLarge =
      BorderRadius.all(Radius.circular(AppConstants.radiusXLarge));

  static const BorderRadius topSmall =
      BorderRadius.vertical(top: Radius.circular(AppConstants.radiusSmall));
  static const BorderRadius topMedium =
      BorderRadius.vertical(top: Radius.circular(AppConstants.radiusMedium));
  static const BorderRadius topLarge =
      BorderRadius.vertical(top: Radius.circular(AppConstants.radiusLarge));

  static const BorderRadius bottomSmall =
      BorderRadius.vertical(bottom: Radius.circular(AppConstants.radiusSmall));
  static const BorderRadius bottomMedium =
      BorderRadius.vertical(bottom: Radius.circular(AppConstants.radiusMedium));
  static const BorderRadius bottomLarge =
      BorderRadius.vertical(bottom: Radius.circular(AppConstants.radiusLarge));
}
