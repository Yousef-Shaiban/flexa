## Flexa: Effortless Responsive Design for Flutter

Flexa is a powerful and intuitive Flutter package designed to simplify the creation of responsive user interfaces across various screen sizes, densities, and orientations. By providing intelligent scaling based on design breakpoints and device metrics, Flexa helps you build beautiful and consistent UIs on phones, tablets, and even desktops.

Stop the boilerplate of manually calculating sizes based on `MediaQuery`. With Flexa, you define your design once, and Flexa handles the scaling for you, ensuring your app looks great on any device. Flexa *requires* you to wrap your application in `FlexaScope` to ensure proper initialization and access to device metrics.

## Features

* **Required Initialization:** Explicitly requires wrapping your app in `FlexaScope` for safe and correct initialization based on `BuildContext`.
* **Breakpoint-Based Scaling:** Define base sizes for different device categories (phone, tablet, large, xLarge, xxLarge) and let Flexa scale your UI elements intelligently using ratios against these base sizes.
* **Smart Scaling:** Provides an intelligent scaling approach that adapts based on predefined device category breakpoints, offering more nuanced control than simple ratio scaling.
* **Adaptive Scaling:** A balanced scaling approach that interpolates between original size and width-scaled size for harmonious layouts, particularly useful for padding and spacing.
* **Font Scaling:** Seamlessly scales font sizes using the adaptive scale while optionally respecting the user's system text scaling preferences.
* **Physical Unit Conversion:** Convert physical units like centimeters, millimeters, and inches to pixels based on device PPI, ensuring consistent physical dimensions across devices.
* **Percentage-Based Sizing:** Easily define widths and heights as a percentage of the screen dimensions.
* **Comprehensive Breakpoint Detection:** Provides getters to check if the current screen width falls within specific exclusive ranges (phone, tablet, large, xLarge) or is larger than a certain breakpoint (phone, tablet, large, xLarge, xxLarge).
* **Orientation Awareness:** Provides getters to check the current screen dimensions' orientation (portrait or landscape). Automatically adjusts the effective base size used for ratio scaling based on this orientation detected during initialization.
* **Convenient Extensions:** Use handy extensions on `num` (e.g., `16.ws`, `10.font`, `50.w`, `20.adaptive`) for concise and readable scaling directly on numerical values.
* **`FlexaScope` Widget:** A dedicated widget to simplify the initialization of Flexa within your widget tree, typically near the root.
* **`when` Method:** A flexible utility for building conditional layouts or providing values based on predefined screen width breakpoints (phone, tablet, large, xLarge, xxLarge).
* **Parent-Based Sizing:** Extensions (`.pw`, `.ph`) to create widgets whose dimensions are calculated as a percentage of their parent's constraints.
* **Spacer Widgets:** Quick getters (`.verticalSpace`, `.horizontalSpace`, `.box`) to create `SizedBox` widgets with dimensions scaled adaptively.

## Installation

Add the following dependency to your `pubspec.yaml` file:

```yaml
dependencies:
  flexa: <latest_version>
```

Then, run `flutter pub get` to install the package.

---

## 🏗️ Usage Example

```dart
SizedBox(height: 20.adaptive);  // Adaptive scaling  
SizedBox(width: 10.w);          // 10% of screen width  
SizedBox(height: 5.h);          // 5% of screen height  
Text('Hello', style: TextStyle(fontSize: 16.font)); // Adaptive text  
```

---

## `FlexaScope`

A convenient StatefulWidget for initializing `Flexa` automatically whenever its dependencies (like screen size or text scale factor from `MediaQuery`) change. Wrap your root app widget (`MaterialApp` or `CupertinoApp`) with `FlexaScope`.

* `FlexaScope({required this.builder, this.systemFontScale, this.baseSize, super.key})`: Constructor requires a `builder` function that returns the widget tree to be wrapped. `systemFontScale` and `baseSize` are optional overrides for `Flexa.init`.

---

## `FlexaUnits` Extension on `num`

Provides convenient getter properties and methods on any number (`int`, `double`) to easily apply Flexa scaling. Available after `FlexaScope` has initialized Flexa.

* `double get ws`: Applies `Flexa.instance.widthScale(toDouble())`.
* `double get wss`: Applies `Flexa.instance.smartWidthScale(toDouble())`.
* `double get hs`: Applies `Flexa.instance.heightScale(toDouble())`.
* `double get hss`: Applies `Flexa.instance.smartHeightScale(toDouble())`.
* `double get adaptive`: Applies `Flexa.instance.adaptiveScale(toDouble())`. Use for padding, margins, gaps, etc.
* `double get font`: Applies `Flexa.instance.fontScale(toDouble())`. Use for font sizes.
* `double get w`: Applies `Flexa.instance.widthPercent(toDouble())`. Use for widths relative to screen width.
* `double get h`: Applies `Flexa.instance.heightPercent(toDouble())`. Use for heights relative to screen height.
* `double get cm`: Applies `Flexa.instance.cm(toDouble())`. Converts cm to pixels.
* `double get mm`: Applies `Flexa.instance.mm(toDouble())`. Converts mm to pixels.
* `double get inch`: Applies `Flexa.instance.inches(toDouble())`. Converts inches to pixels.
* `double get physical`: Applies `Flexa.instance.physical(toDouble())`. Converts a logical size to a physical pixel size.
* `SizedBox get verticalSpace`: Returns a `SizedBox` with `height: this.adaptive`.
* `SizedBox get horizontalSpace`: Returns a `SizedBox` with `width: this.adaptive`.
* `SizedBox get box`: Returns a `SizedBox` with `width: this.adaptive` and `height: this.adaptive`.
* `Widget pw(BuildContext context, Widget Function(double width) builder)`: Returns a `LayoutBuilder` that calculates a width as `this` percentage of the parent's `maxWidth` and passes the calculated width to the `builder` function.
* `Widget ph(BuildContext context, Widget Function(double height) builder)`: Returns a `LayoutBuilder` that calculates a height as `this` percentage of the parent's `maxHeight` and passes the calculated height to the `builder` function.

---

## The Power of `.adaptive` Scaling

While `.ws` and `.hs` provide proportional scaling based on your base design size, and `.wss`/`.hss` offer intelligent scaling based on breakpoints, the `.adaptive` getter provides a balanced approach ideal for padding, spacing, gaps, and small, consistent UI elements.

Adaptive scaling interpolates between the original size and a width-scaled size (specifically, the `smartWidthScale` is used internally for the base of this calculation) using a defined factor (defaulting to 0.5). This means it doesn't scale as aggressively as pure width/height scaling, resulting in more harmonious and less extreme size changes for elements that shouldn't fully stretch or shrink with the screen dimensions.

**Why use `.adaptive`?**

* **Harmonious Spacing:** Ensures padding, margins, and the space between widgets feel visually balanced across different screen sizes without becoming excessively large or tiny.
* **Consistent Element Size:** Suitable for small icons, fixed-size buttons, or other elements where maintaining a somewhat consistent, yet responsive, physical appearance is desired, rather than strictly scaling with width or height ratios.
* **Reduces Extreme Scaling:** By interpolating, it mitigates the chance of sizes becoming disproportionately large on very big screens or too small on very small ones, which can sometimes happen with simple ratio scaling (`.ws`, `.hs`).

**Best Used For:**

* `EdgeInsets` (padding, margin)
* `SizedBox` (creating gaps)
* `Spacer` (in `Row` or `Column`)
* Border widths
* Icon sizes (sometimes, depending on design needs)
* Constraints for smaller widgets

**Example:**

Using `.adaptive` for padding and spacing creates a rhythm that adjusts comfortably across devices:

```dart
import 'package:flutter/material.dart';
import 'package:flexa/flexa.dart';

class AdaptiveExample extends StatelessWidget {
  const AdaptiveExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adaptive Scale Example')),
      body: Center(
        child: Container(
          // Use .adaptive for symmetrical padding
          padding: EdgeInsets.symmetric(vertical: 24.adaptive, horizontal: 16.adaptive),
          decoration: BoxDecoration(
            color: Colors.blue[50],
            borderRadius: BorderRadius.circular(8.adaptive), // Adaptive border radius
            border: Border.all(width: 2.adaptive, color: Colors.blueAccent), // Adaptive border width
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Adaptive Spacing and Padding',
                style: TextStyle(fontSize: 18.font), // Use .font for text
              ),
              // Use .verticalSpace and .horizontalSpace (which use .adaptive internally)
              16.verticalSpace,
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.star, size: 30.adaptive, color: Colors.amber), // Adaptive icon size
                  12.horizontalSpace,
                  Text('Some Content', style: TextStyle(fontSize: 16.font)),
                  12.horizontalSpace,
                  Icon(Icons.settings, size: 30.adaptive, color: Colors.grey[700]), // Adaptive icon size
                ],
              ),
              16.verticalSpace,
              Container(
                width: 150.ws, // Use .ws for content width
                height: 80.hs, // Use .hs for content height
                color: Colors.blueAccent.withOpacity(0.3),
                child: Center(child: Text('Scaled Content', style: TextStyle(fontSize: 14.font))),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## When Expression

Here is an example demonstrating the usage of the `Flexa.when` method to build responsive layouts or provide breakpoint-specific values:

```dart
import 'package:flutter/material.dart';
import 'package:flexa/flexa.dart'; // Assuming your package is named flexa

class ResponsiveTextExample extends StatelessWidget {
  const ResponsiveTextExample({super.key});

  @override
  Widget build(BuildContext context) {
    // Use Flexa.when to return a different Text widget
    // based on the current screen width breakpoints.
    final responsiveWidget = Flexa.when(
      phone: () => Text(
        'Viewing on a Phone',
        style: TextStyle(fontSize: 16.font, color: Colors.blue),
      ),
      tablet: () => Text(
        'Viewing on a Tablet',
        style: TextStyle(fontSize: 20.font, color: Colors.green),
      ),
      large: () => Text(
        'Viewing on a Large Screen',
        style: TextStyle(fontSize: 24.font, color: Colors.orange),
      ),
      xLarge: () => Text(
        'Viewing on an xLarge Screen',
        style: TextStyle(fontSize: 28.font, color: Colors.red),
      ),
      xxLarge: () => Text(
        'Viewing on an xxLarge Screen',
        style: TextStyle(fontSize: 32.font, color: Colors.purple),
      ),
      // Note: You must provide at least one breakpoint handler.
      // Flexa.when falls back to the smallest provided if no specific match.
      // If phone() is provided, it acts as the default for screens below 600.
    );

    // You can also use Flexa.when to return different values, not just widgets.
    // For example, determining the number of columns in a grid.
    final int columns = Flexa.when(
      phone: () => 1,
      tablet: () => 2,
      large: () => 3,
      xLarge: () => 4,
      xxLarge: () => 5,
      // Since all breakpoints are covered, no explicit fallback is strictly needed,
      // but 'phone: () => 1' acts as the default for screens < 600.
    );

     // Example of returning a different size or constant based on breakpoint
    final double containerHeight = Flexa.when(
      phone: () => 50.0.hs, // Scaled height for phone
      tablet: () => 100.0, // Fixed height for tablet
      large: () => 150.0.hs, // Scaled height for large
      // If no specific handler for xLarge/xxLarge, it will fall back to 'large' (150.0.hs)
      // based on the `when` implementation's descending check and fallback logic.
    );


    return Scaffold(
      appBar: AppBar(
        title: const Text('Flexa.when Example'),
      ),
      body: Center(
        child: SingleChildScrollView( // Added for small screens to prevent overflow
          padding: EdgeInsets.symmetric(vertical: 20.adaptive),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Widget based on breakpoint:',
                 style: TextStyle(fontSize: 16.font),
                 textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.adaptive),
              // Display the widget returned by Flexa.when
              responsiveWidget,
              SizedBox(height: 30.adaptive),

              Text(
                'Value based on breakpoint:',
                style: TextStyle(fontSize: 16.font),
                 textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.adaptive),
              Text(
                'Number of columns: $columns',
                style: TextStyle(fontSize: 16.font),
                 textAlign: TextAlign.center,
              ),
               SizedBox(height: 30.adaptive),

               Text(
                'Size based on breakpoint:',
                 style: TextStyle(fontSize: 16.font),
                 textAlign: TextAlign.center,
              ),
              SizedBox(height: 10.adaptive),
               Container(
                 height: containerHeight,
                 width: 200.ws, // Use another Flexa scale for width
                 color: Colors.blueGrey,
                 child: Center(
                   child: Text(
                      'Container with breakpoint-dependent height',
                       style: TextStyle(fontSize: 16.font, color: Colors.white),
                       textAlign: TextAlign.center,
                   ),
                 ),
               )
            ],
          ),
        ),
      ),
    );
  }
}
```

---

## Reference

The core class managing scaling logic and device information. Access its static members. The `instance` getter will throw an exception if `Flexa.init` has not been called (i.e., if `FlexaScope` is not used).

* `static Flexa get instance`: Provides access to the singleton instance of `Flexa`. **Throws an exception if Flexa has not been initialized via `FlexaScope`**.
* `static bool get systemFontScale`: Returns `true` if system font scaling is currently enabled and applied by Flexa.
* `static double get screenHeight`: Returns the current screen height in logical pixels.
* `static double get screenWidth`: Returns the current screen width in logical pixels.
* `static bool get isPhone`: Returns `true` if the screen width is >= 360 AND < 600 logical pixels.
* `static bool get isPhoneOrLarger`: Returns `true` if the screen width is >= 360 logical pixels.
* `static bool get isTablet`: Returns `true` if the screen width is >= 600 AND < 1024 logical pixels.
* `static bool get isTabletOrLarger`: Returns `true` if the screen width is >= 600 logical pixels.
* `static bool get isLarge`: Returns `true` if the screen width is >= 1024 AND < 1280 logical pixels.
* `static bool get isLargeOrLarger`: Returns `true` if the screen width is >= 1024 logical pixels.
* `static bool get isxLarge`: Returns `true` if the screen width is >= 1280 AND < 1920 logical pixels.
* `static bool get isxLargeOrLarger`: Returns `true` if the screen width is >= 1280 logical pixels.
* `static bool get isxxLargeOrLarger`: Returns `true` if the screen width is >= 1920 logical pixels.
* `static bool get isScreenDimensionsPortrait`: Returns `true` if the screen height is >= the screen width.
* `static bool get isScreenDimensionsLandscape`: Returns `true` if the screen width is > the screen height.
* `static void init(BuildContext context, {bool? systemFontScale, Size? baseSize})`: Initializes the `Flexa` instance. Called automatically by `FlexaScope`. `context` is required. `systemFontScale` overrides the default detection. `baseSize` overrides the default breakpoint-based base size.
* `static T when<T>({T Function()? phone, T Function()? tablet, T Function()? large, T Function()? xLarge, T Function()? xxLarge})`: A utility method to return a value based on the current screen width hitting predefined breakpoints. It returns the value for the *smallest* matching breakpoint. At least one size-specific function must be provided.
* `double heightScale(double size)`: Scales a height `size` based on the ratio of current screen height to the base height, clamped between 0.5 and 3.0.
* `double smartHeightScale(double size, {double minClamp = 0.5, double maxClamp = 3.0})`: Scales a height `size` intelligently based on a reference height determined by device breakpoints (`Flexa.when`), clamped between `minClamp` and `maxClamp`.
* `double widthScale(double size)`: Scales a width `size` based on the ratio of current screen width to the base width, clamped between 0.5 and 3.0.
* `double smartWidthScale(double size, {double minClamp = 0.5, double maxClamp = 3.0})`: Scales a width `size` intelligently based on a reference width determined by device breakpoints (`Flexa.when`), clamped between `minClamp` and `maxClamp`.
* `double adaptiveScale(double size)`: Returns a balanced scaled value by interpolating between the original `size` and its smart width scaled value using `_adaptiveFactor`. Good for padding, spacing, and gap sizes.
* `double fontScale(double size)`: Scales a font `size` using the adaptive scale, then applies the system text scale factor if enabled.
* `double physical(double size)`: Converts a logical `size` to pixels to represent the same physical dimension across devices based on PPI. Useful for elements that should have a consistent physical size regardless of screen density.
* `double cm(double size)`: Converts a size in centimeters to pixels using the device's PPI.
* `double mm(double size)`: Converts a size in millimeters to pixels using the device's PPI.
* `double inches(double size)`: Converts a size in inches to pixels using the device's PPI.
* `double widthPercent(double percent)`: Calculates a width that is `percent` of the total screen width.
* `double heightPercent(double percent)`: Calculates a height that is `percent` of the total screen height.

## 🛠️ Contributing

Contributions are welcome! If you find bugs, improvements, or need new features, feel free to submit an issue or pull request.

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to use and modify it as needed.  

