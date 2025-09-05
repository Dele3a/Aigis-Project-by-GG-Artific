import 'dart:io';
import 'package:image/image.dart' as img;
import 'package:tflite_flutter/tflite_flutter.dart';

class PathologyModel {
  late Interpreter _interpreter;
  bool _isModelLoaded = false;

  /// Initialize the model
  Future<void> initialize() async {
    try {
      _interpreter = await Interpreter.fromAsset('model.tflite');
      _isModelLoaded = true;
      print('Model loaded successfully!');
    } catch (e) {
      print('Error loading model: $e');
      rethrow;
    }
  }

  /// Resize the image and preprocess it into the format expected by the model
  List<List<List<List<double>>>> _preprocessImage(String imagePath) {
    final image = img.decodeImage(File(imagePath).readAsBytesSync());
    if (image == null) {
      throw Exception('Failed to decode image.');
    }

    final resizedImage = img.copyResize(image, width: 224, height: 224);

    // Normalize the image and return as 4D array [1, 224, 224, 3]
    return [
      List.generate(224, (y) {
        return List.generate(224, (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [
            (pixel & 0xFF) / 255.0,        // Red channel
            ((pixel >> 8) & 0xFF) / 255.0, // Green channel
            ((pixel >> 16) & 0xFF) / 255.0 // Blue channel
          ];
        });
      })
    ];
  }

  /// Make a prediction using the model
  Future<List<double>> predict(String imagePath) async {
    if (!_isModelLoaded) {
      throw Exception('Model is not initialized. Call initialize() first.');
    }

    try {
      final input = _preprocessImage(imagePath);

      // Prepare output buffer (should match the model's output dimensions)
      var output = List.generate(1, (_) => List.filled(4, 0.0)); // Shape: [1, 4]

      // Run inference
      _interpreter.run(input, output);

      // Flatten the output (from [1, 4] to [4])
      final predictions = output[0];

      // Debug: Log the predictions
      print('Raw predictions: $predictions');
      return predictions;
    } catch (e) {
      print('Error during inference: $e');
      return List.filled(4, 0.0); // Return zero predictions as fallback
    }
  }

  /// Get the label of the highest-scoring prediction
  String getPredictionLabel(List<double> predictions) {
    if (predictions.isEmpty) {
      return "Error: No prediction available.";
    }

    final highestIndex = predictions.indexOf(predictions.reduce((a, b) => a > b ? a : b));
    return mapPredictionToLabel(highestIndex);
  }

  /// Map the prediction index to a human-readable label
  String mapPredictionToLabel(int predictedClass) {
    switch (predictedClass) {
      case 0:
        return "Corrosion";
      case 1:
        return "Crack";
      case 2:
        return "Normal Structure";
      case 3:
        return "Spalling Concrete";
      default:
        return "Unknown";
    }
  }

  /// Dispose of the interpreter when no longer needed
  void dispose() {
    _interpreter.close();
  }
}
