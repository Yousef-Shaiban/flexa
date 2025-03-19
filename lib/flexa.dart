import 'package:flutter/material.dart';

/// Flexa class provides responsive design utilities for Flutter applications,
/// handling scaling based on screen size, PPI, and orientation
class Flexa {
  /// Singleton factory constructor ensuring only one instance exists
  factory Flexa() => _instance ??= Flexa._();

  /// Private constructor for singleton pattern
  Flexa._();

  /// Singleton instance holder
  static Flexa? _instance;

  /// Design PPI (pixels per inch) used as reference for physical scaling
  static const double _designPpi = 160.0;

  /// Default base sizes for phone and tablet in logical pixels
  static const Size _defaultPhoneSize = Size(360, 640);
  static const Size _defaultTabletSize = Size(600, 960);

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
  static Flexa get instance => _instance ??= Flexa._();

  /// Convenience getter for screen height
  static double get screenHeight => _instance?._screenSize.height ?? 0;

  /// Convenience getter for screen width
  static double get screenWidth => _instance?._screenSize.width ?? 0;

  /// Determines if the device is a tablet based on width >= 600
  static bool get isTablet => (_instance?._screenSize.width ?? 0) >= 600;

  /// Initializes Flexa with context, optional system font scaling, and base size
  static void init(BuildContext context, {bool? systemFontScale, Size? baseSize}) {
    _instance ??= Flexa._();

    final mediaQuery = MediaQuery.of(context);
    final constraints = mediaQuery.size;
    final devicePixelRatio = mediaQuery.devicePixelRatio;

    /// Set the actual screen size
    _instance!._screenSize = Size(constraints.width, constraints.height);

    /// Set base size, defaulting to phone or tablet based on screen width
    _instance!._baseSize = baseSize ?? (isTablet ? _defaultTabletSize : _defaultPhoneSize);

    /// Adjust base size for orientation
    if (_instance!._screenSize.width > _instance!._screenSize.height) {
      /// Landscape: swap base size if designed for portrait
      if (_instance!._baseSize.width < _instance!._baseSize.height) {
        _instance!._baseSize = Size(_instance!._baseSize.height, _instance!._baseSize.width);
      }
    } else {
      /// Portrait: ensure base size is in portrait
      if (_instance!._baseSize.width > _instance!._baseSize.height) {
        _instance!._baseSize = Size(_instance!._baseSize.height, _instance!._baseSize.width);
      }
    }

    /// Set font scaling preferences
    _instance!._systemFontScale = systemFontScale ?? (mediaQuery.textScaler.scale(1) != 1);
    _instance!._textScaleFactor = mediaQuery.textScaler.scale(1);
    _instance!._ppi = devicePixelRatio * _designPpi;
  }

  /// Scales a width value based on the ratio of screen width to base width,
  /// clamping the scale between 0.5x and 3x
  double _widthScale(double size) {
    final scale = _screenSize.width / _baseSize.width;
    return size * scale.clamp(0.5, 3.0);
  }

  /// Provides balanced scaling by interpolating between original size and width-scaled size
  double adaptiveScale(double size) {
    final widthScaled = _widthScale(size);
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

/// A StatelessWidget for responsive layouts based on screen width breakpoints
class Responsive extends StatelessWidget {
  /// Widget builder for phone screens (width < 600)
  final Widget Function(BuildContext context)? phone;

  /// Widget builder for tablet screens (600 ≤ width < 960)
  final Widget Function(BuildContext context)? tablet;

  /// Widget builder for large screens (960 ≤ width < 1280)
  final Widget Function(BuildContext context)? large;

  /// Widget builder for extra-large screens (1280 ≤ width < 1920)
  final Widget Function(BuildContext context)? extraLarge;

  /// Widget builder for extra-extra-large screens (width ≥ 1920)
  final Widget Function(BuildContext context)? extraExtraLarge;

  /// Constructor with optional builders for different screen sizes
  Responsive({super.key, this.phone, this.tablet, this.large, this.extraLarge, this.extraExtraLarge}) {
    /// Assert that at least two size-specific widgets are provided
    final providedWidgets = [phone, tablet, large, extraLarge, extraExtraLarge].where((widget) => widget != null).length;
    assert(providedWidgets >= 2, 'At least two size-specific widgets must be provided.');
  }

  /// Builds the appropriate widget based on screen width
  @override
  Widget build(BuildContext context) {
    final double width = Flexa.screenWidth;

    /// List of breakpoints and their corresponding widget builders
    final List<Map<String, dynamic>> breakpoints = [
      {'minWidth': 1920.0, 'widget': extraExtraLarge},
      {'minWidth': 1280.0, 'widget': extraLarge},
      {'minWidth': 960.0, 'widget': large},
      {'minWidth': 600.0, 'widget': tablet},
      {'minWidth': 0.0, 'widget': phone},
    ];

    /// Select and build the widget for the current screen width
    for (final breakpoint in breakpoints) {
      if (width >= breakpoint['minWidth'] && breakpoint['widget'] != null) {
        return breakpoint['widget'].call(context);
      }
    }

    /// Fallback to an empty widget if no match is found
    return const SizedBox.shrink();
  }
}

/// Extension on num to provide convenient access to Flexa scaling methods
extension FlexaUnits on num {
  /// Adaptive scaling of the number
  double get adaptive => Flexa.instance.adaptiveScale(toDouble());

  /// Font scaling of the number
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
}
