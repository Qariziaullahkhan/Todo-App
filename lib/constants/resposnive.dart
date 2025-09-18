
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

// This functions are responsible to make UI responsive across all the mobile devices.

// Get the MediaQueryData from the platform dispatcher's first view
MediaQueryData mediaQueryData = MediaQueryData.fromView(
  ui.PlatformDispatcher.instance.views.first,
);

// These are the Viewport values of your Figma Design.
// These are used in the code as a reference to create your UI Responsively.
const num figmaDesignWidth = 430;
const num figmaDesignHeight = 932;
const num figmaDesignStatusBar = 0;

/// This extension is used to set padding/margin (for the top and bottom side) & height
/// of the screen or widget according to the Viewport height.
extension ResponsiveExtension on num {
  /// This method is used to get device viewport width.
  get _width {
    return mediaQueryData.size.width;
  }

  /// This method is used to get device viewport height.
  get _height {
    num statusBar = mediaQueryData.viewPadding.top;
    num bottomBar = mediaQueryData.viewPadding.bottom;
    num screenHeight = mediaQueryData.size.height - statusBar - bottomBar;
    return screenHeight;
  }

  get statusBar => mediaQueryData.viewPadding.top * this;

  get statusBarToSizedBox =>
      SizedBox(height: mediaQueryData.viewPadding.top * this);

  get bottomBarToSizedBox =>
      SizedBox(height: mediaQueryData.viewPadding.bottom * this);

  get bottomBarToSizedBoxWithAddition =>
      SizedBox(height: mediaQueryData.viewPadding.bottom + this);

  get bottomBar => mediaQueryData.viewPadding.bottom * this;

  get statusBarToSizedBoxWithAddition =>
      SizedBox(height: mediaQueryData.viewPadding.top + this);

  get sh => this * _height;

  get sw => this * _width;

  /// symmetric horizontal
  /// This method is used to set padding/margin (for the left and Right side) & width
  /// of the screen or widget according to the Viewport width.
  double get w => ((this * _width) / figmaDesignWidth);

  /// symmetric vertical
  /// This method is used to set padding/margin (for the top and bottom side) & height
  /// of the screen or widget according to the Viewport height.
  double get h => (this * _height) / (figmaDesignHeight - figmaDesignStatusBar);

  /// This method is used to set smallest px in image height and width
  /// [[rsa]] responsive size adjust
  double get rSA {
    var height = h;
    var width = w;
    return height > width ? height.toDoubleValue() : width.toDoubleValue();
  }

  /// This method is used to set text font size according to Viewport
  double get fS => rSA;

  double get r {
    return rSA / 2;
  }
}

extension FormatExtension on double {
  /// Return a [double] value with formatted according to provided fractionDigits
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }
}
