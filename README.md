# Flexa - Advanced Responsive Design for Flutter

Flexa is a robust utility for handling responsive UI scaling in Flutter applications. It ensures a consistent user experience across various screen sizes, pixel densities, and orientations by providing dynamic scaling methods, physical unit conversions, and breakpoint-based layouts.

## 🚀 Features

- **📏 Adaptive Scaling**: Dynamically scales UI elements based on screen width, height, and pixel density.
- **🖥️ Multi-Screen Support**: Handles phone, tablet, and large screen layouts with predefined breakpoints.
- **🔍 Physical Unit Conversion**: Convert values to pixels based on actual device PPI (cm, mm, inches).
- **🔠 Font Scaling**: Supports system text scaling while ensuring readability.
- **🛠️ Singleton Access**: Provides a globally accessible instance for easy usage.
- **🧩 Extension Helpers**: Easily scale widgets using `.adaptive`, `.font`, `.w`, `.h`, and more.

---

## 📦 Installation

Add the following to your `pubspec.yaml` file:

```yaml
dependencies:
  flexa: <latest_version>
```

Then, run `flutter pub get` to install the package.

```dart
void main() {
  runApp(FlexaScope(builder: (context) => MyApp()));
}
```

---

## 📌 Initialization

Before using Flexa, initialize it inside your widget tree to capture screen parameters:

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FlexaScope(
      builder: (context) => MaterialApp(
        home: HomePage(),
      ),
    );
  }
}
```

---

## 🎨 Usage

### ✅ Basic Scaling

```dart
double size = 100.adaptive;  // Scales adaptively  
double fontSize = 16.font;    // Scales font based on text scaling  
double tenPercent = 10.w;     // 10% of screen width  
double fivePercentHeight = 5.h; // 5% of screen height  
```

### 📱 Responsive Widget

Use the `Responsive` widget to build layouts based on device width breakpoints:

```dart
Responsive(
  phone: (context) => PhoneWidget(),
  tablet: (context) => TabletWidget(),
  large: (context) => LargeScreenWidget(),
  extraLarge: (context) => ExtraLargeWidget(),
);
```

---

## 📊 Breakpoints

Flexa classifies screen sizes into predefined categories:

| Device Type        | Screen Width (px)   |
|--------------------|--------------------|
| 📱 Phone          | `< 600px`          |
| 📲 Tablet         | `600px - 960px`    |
| 💻 Large Screen   | `960px - 1280px`   |
| 🖥️ Extra Large    | `1280px - 1920px`  |
| 🏢 Extra-Extra Large | `>= 1920px`    |

---

## 📐 Physical Unit Conversions

Flexa supports real-world unit conversions for precise UI scaling:

```dart
double cmSize = 2.cm;    // Convert 2 cm to pixels  
double mmSize = 5.mm;    // Convert 5 mm to pixels  
double inchSize = 1.inch; // Convert 1 inch to pixels  
```

---

## 🏗️ Extension Methods

For convenience, Flexa provides direct scaling methods for `num` types:

```dart
SizedBox(height: 20.adaptive);  // Adaptive scaling  
SizedBox(width: 10.w);          // 10% of screen width  
SizedBox(height: 5.h);          // 5% of screen height  
Text('Hello', style: TextStyle(fontSize: 16.font)); // Adaptive text  
```

---

## 🛠️ Contributing

Contributions are welcome! If you find bugs, improvements, or need new features, feel free to submit an issue or pull request.

---

## 📜 License

This project is licensed under the **MIT License**. Feel free to use and modify it as needed.  

