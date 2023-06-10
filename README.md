# ⋯ Segmented Progress Bar
Create highly customizable progress bars that show progression across multiple stages of a task. It can be also used to show progression of multiple tasks simultaneously.

## Features and Customizations
- Offers two variants of the segmented progress bar with types- Linear and Circular
- Modify the look and feel of the progress bars by changing their thickness, spacing, border radius and colors
- The colors can be a single or custom color for each segment along with an optional background color
- Prefer to use a gradient instead? This has got you covered! Specify common or individual gradients for all the segments as you wish just like with color customizations.
- All the properties are implicitly animated so it can smoothly transition between them. Tailor the feel of the animation by specifying the duration and curve.

## Usage

Use the widget like you would normally use for the vanilla progress indicators.

```dart
SegmentedProgressBar(
    segments: [1, 2, 1],
    progress: [0.6, 0, 0],
    colors: [
        Colors.indigo,
        Colors.amber,
        Colors.green,
    ],
);
```

## Todo

- [ ] Add vertical linear progress bar
- [ ] Make the number of segments animatable
