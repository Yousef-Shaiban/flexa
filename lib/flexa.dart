import 'package:flutter/material.dart';

/// Flexa class provides responsive design utilities for Flutter applications,
/// handling scaling based on screen size, PPI, and orientation
class Flexa {
  /// Singleton factory constructor ensuring only one instance exists
  factory Flexa() => instance;

  /// Private constructor for singleton pattern
  Flexa._();

  /// Singleton instance holder
  static Flexa? _instance;

  /// Design PPI (pixels per inch) used as reference for physical scaling
  static const double _designPpi = 160.0;

  /// Default base sizes for phone and tablet in logical pixels
  static const Size _defaultPhoneSize = Size(360, 640); // Small phone
  static const Size _defaultTabletSize = Size(600, 960); // Small tablet
  static const Size _defaultLargeSize = Size(1024, 768); // Large tablet or small desktop
  static const Size _defaultXLargeSize = Size(1280, 800); // Medium desktop
  static const Size _defaultXXLargeSize = Size(
    1920,
    1080,
  ); // Large desktop or high-resolution display

  /// Base design size used for scaling calculations
  late Size _baseSize;

  /// Actual screen size of the device
  late Size _screenSize;

  /// Flag to determine if system font scaling should be applied
  late bool _systemFontScale;

  /// Text scale factor from the system settings
  late double _textScaleFactor;

  /// Device PPI calculated from device pixel ratio
  late double _ppi;

  /// Factor for balanced scaling between base and adaptive size
  final double _adaptiveFactor = 0.5;

  /// Public accessor for the singleton instance
  static Flexa get instance {
    if (_instance == null) {
      throw Exception('Flexa error ensure to wrap your app widget with FlexaScope() widget');
    }
    return _instance!;
  }

  /// Convenience getter for system font scale
  static bool get systemFontScale => instance._systemFontScale;

  /// Convenience getter for screen height
  static double get screenHeight => instance._screenSize.height;

  /// Convenience getter for screen width
  static double get screenWidth => instance._screenSize.width;

  /// Determines if the device width >= 360 & width < 600
  static bool get isPhone => screenWidth >= 360 && screenWidth < 600;

  /// Determines if the device width >= 360
  static bool get isPhoneOrLarger => screenWidth >= 360;

  /// Determines if the device width >= 600 & width < 1024
  static bool get isTablet => screenWidth >= 600 && screenWidth < 1024;

  /// Determines if the device width >= 600
  static bool get isTabletOrLarger => screenWidth >= 600;

  /// Determines if the device width >= 1024 & width < 1280
  static bool get isLarge => screenWidth >= 1024 && screenWidth < 1280;

  /// Determines if the device width >= 1024
  static bool get isLargeOrLarger => screenWidth >= 1024;

  /// Determines if the device width >= 1280 & width < 1920
  static bool get isxLarge => screenWidth >= 1280 && screenWidth < 1920;

  /// Determines if the device width >= 1280
  static bool get isxLargeOrLarger => screenWidth >= 1280;

  /// Determines if the device width >= 1920
  static bool get isxxLargeOrLarger => screenWidth >= 1920;

  /// Determines if the device height >= width
  static bool get isScreenDimensionsPortrait => screenWidth <= screenHeight;

  /// Determines if the device width > height
  static bool get isScreenDimensionsLandscape => screenWidth > screenHeight;

  /// Initializes Flexa with context, optional system font scaling, and base size
  static void init(BuildContext context, {bool? systemFontScale, Size? baseSize}) {
    _instance ??= Flexa._();

    final mediaQuery = MediaQuery.of(context);
    final constraints = mediaQuery.size;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    /// Set the actual screen size
    _instance!._screenSize = Size(constraints.width, constraints.height);

    /// Set base size, defaulting to phone or tablet based on screen width
    _instance!._baseSize =
        baseSize ??
        Flexa.when(
          phone: () => _defaultPhoneSize,
          tablet: () => _defaultTabletSize,
          large: () => _defaultLargeSize,
          xLarge: () => _defaultXLargeSize,
          xxLarge: () => _defaultXXLargeSize,
        );

    /// Adjust base size for orientation
    if (screenWidth > screenHeight) {
      _instance!._baseSize = Size(_instance!._baseSize.height, _instance!._baseSize.width);
    } else {
      _instance!._baseSize = Size(_instance!._baseSize.width, _instance!._baseSize.height);
    }

    /// Set font scaling preferences
    _instance!._systemFontScale = systemFontScale ?? (mediaQuery.textScaler.scale(1) != 1);
    _instance!._textScaleFactor = mediaQuery.textScaler.scale(1);
    _instance!._ppi = devicePixelRatio * _designPpi;
  }

  /// A function for responsive layouts based on screen width breakpoints.
  ///
  /// Usage:
  /// ```dart
  /// Flexa.when(
  ///   phone: () => Text('Phone Layout'),
  ///   tablet: () => Text('Tablet Layout'),
  ///   large: () => Text('Large Layout'),
  ///   xLarge: () => Text('xLarge Layout'),
  ///   xxLarge: () => Text('xxLarge Layout'),
  /// );
  /// ```
  ///
  /// - The function returns the value corresponding to the smallest matching breakpoint.
  /// - If no breakpoint matches, it falls back to the smallest provided breakpoint.
  /// - At least one size-specific value must be provided.
  static T when<T>({
    T Function()? phone,
    T Function()? tablet,
    T Function()? large,
    T Function()? xLarge,
    T Function()? xxLarge,
  }) {
    final List<Map<String, dynamic>> breakpoints = [
      {'minWidth': 1920.0, 'value': xxLarge},
      {'minWidth': 1280.0, 'value': xLarge},
      {'minWidth': 960.0, 'value': large},
      {'minWidth': 600.0, 'value': tablet},
      {'minWidth': 0.0, 'value': phone},
    ];
    final providedValues = [phone, tablet, large, xLarge, xxLarge].where((i) => i != null);
    if (providedValues.isEmpty) {
      throw Exception(
        '(Flexa) At least one size-specific value must be provided using (.when()) expression.',
      );
    }

    for (final breakpoint in breakpoints) {
      if (screenWidth >= breakpoint['minWidth'] && breakpoint['value'] != null) {
        return breakpoint['value']!.call();
      }
    }

    return phone?.call() ?? tablet?.call() ?? large?.call() ?? xLarge?.call() ?? xxLarge!.call();
  }

  /// Scales a height value based on the ratio of screen height to base height,
  /// clamping the scale between 0.5x and 3x
  double heightScale(double size) {
    final scale = _screenSize.height / _baseSize.height;
    return size * scale.clamp(0.5, 3.0);
  }

  /// Scales a height value intelligently based on the device's screen height,
  /// using dynamic reference widths determined by device category breakpoints.
  ///
  /// This method calculates a scaling factor by comparing the current screen height
  /// to a reference height, which is selected based on predefined device categories
  /// The scaling factor is then clamped between a minimum and maximum value
  /// to ensure reasonable bounds. This approach aims to provide responsive height scaling
  /// tailored to different device sizes.
  double smartHeightScale(double size, {double minClamp = 0.5, double maxClamp = 3.0}) {
    final referenceHeight = Flexa.when(
      large: () => _defaultPhoneSize.height, // 360 for screens >= 960px
      xLarge: () => _defaultTabletSize.height, // 600 for screens >= 1280px
      xxLarge: () => _defaultLargeSize.height, // 1024 for screens >= 1920px
    );
    final scaleFactor = _screenSize.height / referenceHeight;
    final clampedScale = scaleFactor.clamp(minClamp, maxClamp); // Clamp between 0.5 and 3.0
    return size * clampedScale;
  }

  /// Scales a width value based on the ratio of screen width to base width,
  /// clamping the scale between 0.5x and 3x
  double widthScale(double size) {
    final scale = _screenSize.width / _baseSize.width;
    return size * scale.clamp(0.5, 3.0);
  }

  /// Scales a width value intelligently based on the device's screen width,
  /// using dynamic reference widths determined by device category breakpoints.
  ///
  /// This method calculates a scaling factor by comparing the current screen width
  /// to a reference width, which is selected based on predefined device categories
  /// The scaling factor is then clamped between a minimum and maximum value
  /// to ensure reasonable bounds. This approach aims to provide responsive width scaling
  /// tailored to different device sizes.
  double smartWidthScale(double size, {double minClamp = 0.5, double maxClamp = 3.0}) {
    final referenceWidth = Flexa.when(
      large: () => _defaultPhoneSize.width, // 360 for screens >= 960px
      xLarge: () => _defaultTabletSize.width, // 600 for screens >= 1280px
      xxLarge: () => _defaultLargeSize.width, // 1024 for screens >= 1920px
    );
    final scaleFactor = _screenSize.width / referenceWidth;
    final clampedScale = scaleFactor.clamp(minClamp, maxClamp); // Clamp between 0.5 and 3.0
    return size * clampedScale;
  }

  /// Provides balanced scaling by interpolating between original size and width-scaled size
  double adaptiveScale(double size) {
    final widthScaled = smartWidthScale(size);
    return size + (widthScaled - size) * _adaptiveFactor;
  }

  /// Scales font sizes, optionally applying system text scale factor
  double fontScale(double size) {
    final scaled = adaptiveScale(size);
    return _systemFontScale ? scaled * _textScaleFactor : scaled;
  }

  /// Converts a size to pixels ensuring identical physical size across devices
  double physical(double size) => (size / _designPpi) * _ppi;

  /// Converts centimeters to pixels based on device PPI
  double cm(double size) => (size * 2.54) * _ppi;

  /// Converts millimeters to pixels based on device PPI
  double mm(double size) => (size * 0.1) * _ppi * 2.54;

  /// Converts inches to pixels based on device PPI
  double inches(double size) => size * _ppi;

  /// Calculates a width as a percentage of screen width
  double widthPercent(double percent) => _screenSize.width * (percent / 100);

  /// Calculates a height as a percentage of screen height
  double heightPercent(double percent) => _screenSize.height * (percent / 100);
}

/// A StatefulWidget that initializes Flexa within the widget tree
class FlexaScope extends StatefulWidget {
  /// Constructs FlexaScope with a builder, optional font scaling, and base size
  const FlexaScope({required this.builder, this.systemFontScale, this.baseSize, super.key});

  /// The builder function that returns the widget tree
  final Widget Function(BuildContext context) builder;

  /// Optional override for system font scaling
  final bool? systemFontScale;

  /// Optional custom base size
  final Size? baseSize;

  @override
  State<FlexaScope> createState() => _FlexaScopeState();
}

/// State class for FlexaScope
class _FlexaScopeState extends State<FlexaScope> {
  /// Updates Flexa configuration when dependencies change
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Flexa.init(context, systemFontScale: widget.systemFontScale, baseSize: widget.baseSize);
  }

  /// Builds the widget tree using the provided builder
  @override
  Widget build(BuildContext context) {
    return widget.builder(context);
  }
}

/// Extension on num to provide convenient access to Flexa scaling methods
extension FlexaUnits on num {
  /// Scales a width value proportionally based on the current screen width relative to the base width.
  /// The scaling ratio is clamped between 0.5x and 3x to ensure reasonable bounds.
  ///
  /// Base widths for different device categories:
  /// - Phone: 360 (e.g., using `360.ws` on a phone will take the full width)
  /// - Tablet: 600 (e.g., using `600.ws` on a tablet will take the full width)
  /// - Large: 960 (e.g., using `960.ws` on a large device will take the full width)
  /// - xLarge: 1280 (e.g., using `1280.ws` on an xLarge device will take the full width)
  /// - xxLarge: 1920 (e.g., using `1920.ws` on an xxLarge device will take the full width)
  ///
  /// Usage: Use this getter to dynamically adjust width values for responsive layouts.
  /// Example: `360.ws` will take the full width on a phone, `600.ws` on a tablet, etc.
  double get ws => Flexa.instance.widthScale(toDouble());

  /// Scales a width value intelligently based on the device's screen width,
  double get wss => Flexa.instance.smartWidthScale(toDouble());

  /// Scales a height value proportionally based on the current screen height relative to the base height.
  /// The scaling ratio is clamped between 0.5x and 3x to ensure reasonable bounds.
  ///
  /// Base heights for different device categories:
  /// - Phone: 640 (e.g., using `640.hs` on a phone will take the full height)
  /// - Tablet: 960 (e.g., using `960.hs` on a tablet will take the full height)
  /// - Large: 768 (e.g., using `768.hs` on a large device will take the full height)
  /// - xLarge: 800 (e.g., using `800.hs` on an xLarge device will take the full height)
  /// - xxLarge: 1080 (e.g., using `1080.hs` on an xxLarge device will take the full height)
  ///
  /// Usage: Use this getter to dynamically adjust height values for responsive layouts.
  /// Example: `640.hs` will take the full height on a phone, `960.hs` on a tablet, etc.
  double get hs => Flexa.instance.heightScale(toDouble());

  /// Scales a width value intelligently based on the device's screen height,
  double get hss => Flexa.instance.smartHeightScale(toDouble());

  /// Adaptive scaling
  double get adaptive => Flexa.instance.adaptiveScale(toDouble());

  /// Font scaling
  double get font => Flexa.instance.fontScale(toDouble());

  /// Width percentage of the screen
  double get w => Flexa.instance.widthPercent(toDouble());

  /// Height percentage of the screen
  double get h => Flexa.instance.heightPercent(toDouble());

  /// Centimeters to pixels
  double get cm => Flexa.instance.cm(toDouble());

  /// Millimeters to pixels
  double get mm => Flexa.instance.mm(toDouble());

  /// Inches to pixels
  double get inch => Flexa.instance.inches(toDouble());

  /// Physical size in pixels
  double get physical => Flexa.instance.physical(toDouble());

  /// Vertical spacer with adaptive height
  SizedBox get verticalSpace => SizedBox(height: adaptive);

  /// Horizontal spacer with adaptive width
  SizedBox get horizontalSpace => SizedBox(width: adaptive);

  /// Square spacer with adaptive width and height
  SizedBox get box => SizedBox(width: adaptive, height: adaptive);

  /// Returns a widget that calculates width based on its parent
  Widget pw(BuildContext context, Widget Function(double width) builder) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double value = constraints.maxWidth * (this / 100);
        return builder(value);
      },
    );
  }

  /// Returns a widget that calculates height based on its parent
  Widget ph(BuildContext context, Widget Function(double height) builder) {
    return LayoutBuilder(
      builder: (context, constraints) {
        double value = constraints.maxHeight * (this / 100);
        return builder(value);
      },
    );
  }
}
