import 'package:flexa/flexa.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FlexaScope(
      builder: (context) => MaterialApp(
        title: 'Flexa Example',
        theme: ThemeData(primarySwatch: Colors.blue),
        home: const FlexaExample(),
      ),
    );
  }
}

class FlexaExample extends StatelessWidget {
  const FlexaExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flexa Responsive Demo')),
      body: Flexa.when(
        phone: () => const PhoneLayout(),
        tablet: () => const TabletLayout(),
        large: () => const LargeLayout(),
        xLarge: () => const ExtraLargeLayout(),
        xxLarge: () => const ExtraExtraLargeLayout(),
      ),
    );
  }
}

// Layout for phone screens (width < 600)
class PhoneLayout extends StatelessWidget {
  const PhoneLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Phone Layout',
            style: TextStyle(fontSize: 20.font), // Scaled font size
          ),
          20.verticalSpace, // Scaled vertical spacing
          Container(
            width: 100.adaptive,
            height: 100.adaptive,
            color: Colors.blue,
            child: const Center(child: Text('Adaptive Box')),
          ),
          10.verticalSpace,
          Text(
            'Screen Width: ${Flexa.screenWidth.toStringAsFixed(1)}',
            style: TextStyle(fontSize: 16.font),
          ),
          Text(
            'Screen Height: ${Flexa.screenHeight.toStringAsFixed(1)}',
            style: TextStyle(fontSize: 16.font),
          ),
        ],
      ),
    );
  }
}

// Layout for tablet screens (600 ≤ width < 960)
class TabletLayout extends StatelessWidget {
  const TabletLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Tablet Layout', style: TextStyle(fontSize: 24.font)),
          20.horizontalSpace, // Scaled horizontal spacing
          Container(
            width: 40.w,
            height: 30.h,
            color: Colors.green,
            child: const Center(child: Text('Scaled Box')),
          ),
        ],
      ),
    );
  }
}

// Layout for large screens (960 ≤ width < 1280)
class LargeLayout extends StatelessWidget {
  const LargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Large Layout', style: TextStyle(fontSize: 28.font)),
          30.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 30.w,
                height: 20.h,
                color: Colors.orange,
                child: const Center(child: Text('Box 1')),
              ),
              10.horizontalSpace,
              Container(
                width: 30.w,
                height: 20.h,
                color: Colors.red,
                child: const Center(child: Text('Box 2')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Layout for extra-large screens (1280 ≤ width < 1920)
class ExtraLargeLayout extends StatelessWidget {
  const ExtraLargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Extra Large Layout', style: TextStyle(fontSize: 32.font)),
          40.verticalSpace,
          Container(
            width: 60.w,
            height: 40.h,
            color: Colors.purple,
            child: const Center(child: Text('Big Scaled Box')),
          ),
        ],
      ),
    );
  }
}

// Layout for extra-extra-large screens (width ≥ 1920)
class ExtraExtraLargeLayout extends StatelessWidget {
  const ExtraExtraLargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Extra Extra Large Layout', style: TextStyle(fontSize: 36.font)),
          50.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 25.w,
                height: 25.h,
                color: Colors.teal,
                child: const Center(child: Text('Box 1')),
              ),
              20.horizontalSpace,
              Container(
                width: 25.w,
                height: 25.h,
                color: Colors.cyan,
                child: const Center(child: Text('Box 2')),
              ),
              20.horizontalSpace,
              Container(
                width: 25.w,
                height: 25.h,
                color: Colors.indigo,
                child: const Center(child: Text('Box 3')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
