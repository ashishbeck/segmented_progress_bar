import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';

import 'package:segmented_progress_bar/segmented_progress_bar.dart';

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
        colorSchemeSeed: Colors.deepPurple,
        useMaterial3: true,
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
  late Timer? timer;
  final deliveryTexts = [
    'Waiting for confirmation from the restaurant 🕙',
    'Preparing your food 🍲',
    'Out for delivery 🛍️',
  ];
  double progressWaiting = 0.0;
  double progressPreparing = 0.0;
  double progressDelivery = 0.0;
  var durationDelivery = const Duration(seconds: 3);

  var dynamicValues = [0.1, 0.5, 0.2, 0.8];
  var dynamicThickness = 12.0;
  var dynamicSpacing = 50.0;
  Color? dynamicBgColor = Colors.red;
  Gradient? dynamicBgGradient =
      const LinearGradient(colors: [Colors.red, Colors.green]);
  Color dynamicColor = Colors.red;
  List<Color>? dynamicColors = [
    Colors.red,
    Colors.green,
    Colors.blue,
    Colors.yellow
  ];
  Gradient? dynamicGradient =
      const LinearGradient(colors: [Colors.red, Colors.green]);
  List<Gradient>? dynamicGradients = [
    const LinearGradient(colors: [Colors.red, Colors.green]),
    const LinearGradient(colors: [Colors.yellow, Colors.blue]),
    const LinearGradient(colors: [Colors.pink, Colors.cyan]),
    const LinearGradient(colors: [Colors.orange, Colors.purple]),
  ];
  var dynamicRadius = BorderRadius.circular(12);

  Future<void> deliveryUpdates() async {
    durationDelivery = const Duration(seconds: 3);
    await Future<void>.delayed(durationDelivery);
    progressWaiting = 1;
    await Future<void>.delayed(durationDelivery);
    progressPreparing = 1;
    await Future<void>.delayed(durationDelivery);
    progressDelivery = 1;
    await Future<void>.delayed(durationDelivery * 2);
    progressWaiting = 0.0;
    progressPreparing = 0.0;
    progressDelivery = 0.0;
    await Future<void>.delayed(durationDelivery);
    deliveryUpdates();
  }

  void randomizeDynamicValues() {
    final rand = Random();
    dynamicValues = List.generate(4, (index) => rand.nextDouble());
    dynamicThickness = rand.nextDouble() * 70;
    dynamicSpacing = rand.nextDouble() * 50;
    final useCustomBg = rand.nextDouble() > 0.5;
    final useCustomGradientBg = rand.nextDouble() > 0.5;
    final useMultipleColors = rand.nextDouble() > 0.5;
    final useGradient = rand.nextDouble() > 0.5;
    final useMultipleGradient = rand.nextDouble() > 0.5;
    dynamicBgColor =
        useCustomBg ? Color((rand.nextDouble() * 0xFFFFFFFF).toInt()) : null;
    dynamicBgGradient = useCustomGradientBg &&
            (useGradient || useMultipleGradient)
        ? LinearGradient(
            colors: List.generate(
                2, (index) => Color((rand.nextDouble() * 0xFFFFFFFF).toInt())))
        : null;
    dynamicColor = Color((rand.nextDouble() * 0xFFFFFFFF).toInt());
    dynamicColors = useMultipleColors
        ? List.generate(
            4, (index) => Color((rand.nextDouble() * 0xFFFFFFFF).toInt()))
        : null;
    dynamicGradient = useGradient
        ? LinearGradient(
            colors: List.generate(
                2, (index) => Color((rand.nextDouble() * 0xFFFFFFFF).toInt())))
        : null;
    dynamicGradients = useMultipleGradient
        ? List.generate(
            4,
            (index) => LinearGradient(
                colors: List.generate(
                    2,
                    (index) =>
                        Color((rand.nextDouble() * 0xFFFFFFFF).toInt()))))
        : null;
    dynamicRadius = BorderRadius.only(
      topLeft: Radius.circular(rand.nextDouble() * 20),
      topRight: Radius.circular(rand.nextDouble() * 20),
      bottomLeft: Radius.circular(rand.nextDouble() * 20),
      bottomRight: Radius.circular(rand.nextDouble() * 20),
    );
  }

  Future<void> updateState() async {
    timer = Timer.periodic(durationDelivery, (timer) {
      setState(() {
        randomizeDynamicValues();
      });
    });
  }

  @override
  void initState() {
    super.initState();
    updateState();
    deliveryUpdates();
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const divider = Divider(height: 32, color: Colors.black12);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Segmented Progress Bar Example'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              SegmentedProgressBar(
                segments: const [1, 2, 2, 3],
                values: const [0.3, 0.6, 0.2, 0.5],
                color: Colors.redAccent,
                radius: BorderRadius.zero,
              ),
              divider,
              SegmentedProgressBar(
                segments: const [1, 2, 1, 3],
                values: const [0.8, 0.2, 0.5, 0.1],
                color: Colors.indigo,
              ),
              divider,
              SegmentedProgressBar(
                segments: const [1, 2, 4, 1, 3],
                values: const [0.3, 0.2, 0.6, 0.7, 0.5],
                color: Colors.black,
                spacing: 0,
                insideRadius: BorderRadius.zero,
              ),
              divider,
              SegmentedProgressBar(
                segments: const [1, 3, 2],
                values: const [0.3, 0.6, 0.4],
                gradient:
                    const LinearGradient(colors: [Colors.blue, Colors.pink]),
                thickness: 32,
                spacing: 16,
                radius:
                    const BorderRadius.horizontal(right: Radius.circular(20)),
              ),
              divider,
              SegmentedProgressBar(
                segments: const [2, 2, 3],
                values: const [0.7, 0.5, 0.4],
                gradients: const [
                  LinearGradient(colors: [Colors.green, Colors.black]),
                  LinearGradient(colors: [Colors.orange, Colors.yellow]),
                  LinearGradient(colors: [Colors.red, Colors.blue]),
                ],
                thickness: 16,
                spacing: 12,
                radius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
              ),
              divider,
              SegmentedProgressBar(
                segments: const [1, 2, 1, 3],
                values: const [0.8, 0.2, 0.5, 0.1],
                color: Colors.purple,
                backgroundColor: Colors.teal,
                thickness: 4,
                spacing: 24,
              ),
              divider,
              SegmentedProgressBar(
                segments: const [1, 2, 1, 3],
                values: const [0.8, 0.2, 0.5, 0.1],
                colors: const [
                  Colors.teal,
                  Colors.deepPurple,
                  Colors.amber,
                  Colors.pink,
                ],
                thickness: 4,
                spacing: 0,
                radius: BorderRadius.zero,
              ),
              divider,
              Container(
                constraints: const BoxConstraints(minHeight: 70),
                alignment: Alignment.center,
                child: SegmentedProgressBar(
                  segments: const [1, 2, 1, 3],
                  values: dynamicValues,
                  backgroundColor: dynamicBgColor,
                  color: dynamicColor,
                  colors: dynamicColors,
                  backgroundGradient: dynamicBgGradient,
                  gradient: dynamicGradient,
                  gradients: dynamicGradients,
                  thickness: dynamicThickness,
                  spacing: dynamicSpacing,
                  radius: dynamicRadius,
                  duration: durationDelivery * 1.25,
                ),
              ),
              divider,
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.purple),
                  color: Colors.purple.withOpacity(0.075),
                ),
                child: Column(
                  children: [
                    Center(
                      child: Text(
                        deliveryTexts[progressPreparing != 1
                            ? 0
                            : progressDelivery != 1
                                ? 1
                                : 2],
                        style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                              color: const Color.fromARGB(255, 37, 37, 37),
                            ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    SegmentedProgressBar(
                      segments: const [1, 3, 3],
                      values: [
                        progressWaiting,
                        progressPreparing,
                        progressDelivery
                      ],
                      duration: durationDelivery,
                      curve: Curves.linear,
                      startAngle: 270,
                      spacing: 4,
                      colors: [
                        Colors.purple.withOpacity(0.6),
                        Colors.purple.withOpacity(0.8),
                        Colors.purple.withOpacity(1),
                      ],
                      radius: const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8),
                        bottomLeft: Radius.circular(8),
                        bottomRight: Radius.circular(8),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SegmentedProgressBar(
                  type: SegmentedProgressBarType.circular,
                  segments: const [2, 2, 1, 1, 1, 1],
                  // values: const [1, 0.0, 0.07, 0.96, 0.01, 0.04],
                  values: const [0.03, 0.5, 0.2, 0.9, 0.6, 0.3],
                  // values: const [0, 0, 0, 0, 0, 0],
                  // values: const [1, 1, 1, 1, 1, 1]
                  //     .map((e) => e * animation)
                  //     .toList(),
                  color: Colors.pink,
                  spacing: 12,
                  colors: const [
                    Colors.red,
                    Colors.cyan,
                    Colors.green,
                    Colors.blue,
                    Colors.amber,
                    Colors.purple,
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
