import 'package:flutter/material.dart';
import 'package:segmented_progress_bar/segmented_progress_bar.dart';
import 'package:segmented_progress_bar_example/animation_wrapper.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmented Progress Bar Example'),
      ),
      body: InteractiveViewer(
        maxScale: 5,
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AnimationWrapper(builder: (context, animation) {
              return ListView(
                children: [
                  SegmentedProgressBar(
                    segments: const [1, 1, 1, 1, 1, 1],
                    // segments: const [3, 3, 1, 1, 1, 3],
                    // values: const [0, 0, 0, 0, 0, 0],
                    // values: const [0.5, 0.5, 0.0, 0.9, 0.6, 0.3],
                    values: const [1, 1, 1, 1, 1, 1]
                        .map((e) => e * animation)
                        .toList(),
                    color: Colors.pink,
                    startAngle: 270,
                    // spacing: 12,
                    spacing: 12 + 12 * animation,
                    colors: const [
                      Colors.red,
                      Colors.cyan,
                      Colors.green,
                      Colors.blue,
                      Colors.amber,
                      Colors.purple,
                    ],
                    gradients: const [
                      LinearGradient(
                        colors: [Colors.black, Colors.orange],
                        stops: [0.2, 0.7],
                      ),
                      LinearGradient(colors: [Colors.black, Colors.green]),
                      LinearGradient(colors: [Colors.black, Colors.green]),
                      LinearGradient(colors: [Colors.black, Colors.green]),
                      LinearGradient(colors: [Colors.black, Colors.green]),
                      LinearGradient(colors: [Colors.black, Colors.green]),
                    ],
                    radius: const BorderRadius.only(
                      topLeft: Radius.circular(8),
                      topRight: Radius.circular(8),
                      bottomLeft: Radius.circular(8),
                      bottomRight: Radius.circular(8),
                    ),
                  ),
                  SegmentedProgressBar(
                    type: SegmentedProgressBarType.circular,
                    segments: const [2, 2, 1, 1, 1, 1],
                    // values: const [1, 0.0, 0.07, 0.96, 0.01, 0.04],
                    // values: const [0.03, 0.5, 0.2, 0.9, 0.6, 0.3],
                    // values: const [0, 0, 0, 0, 0, 0],
                    values: const [1, 1, 1, 1, 1, 1]
                        .map((e) => e * animation)
                        .toList(),
                    color: Colors.pink,
                    startAngle: 270,
                    // spacing: 12,
                    spacing: 12 + 12 * animation,
                    colors: const [
                      Colors.red,
                      Colors.cyan,
                      Colors.green,
                      Colors.blue,
                      Colors.amber,
                      Colors.purple,
                    ],
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
