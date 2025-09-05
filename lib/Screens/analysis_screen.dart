import 'dart:io';
import 'package:flutter/material.dart';
import '../utils/pathology_model.dart';
import '../screens/chat_screen.dart';

class AnalysisScreen extends StatefulWidget {
  final String imagePath;

  const AnalysisScreen({super.key, required this.imagePath});

  @override
  _AnalysisScreenState createState() => _AnalysisScreenState();
}

class _AnalysisScreenState extends State<AnalysisScreen>
    with SingleTickerProviderStateMixin {
  final PathologyModel _model = PathologyModel();
  List<double>? _predictions;
  final List<String> _classLabels = [
    'Corrosion',
    'Crack',
    'Normal Structure',
    'Spalling Concrete'
  ];

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
    AnimationController(vsync: this, duration: const Duration(seconds: 2))
      ..repeat(reverse: true);
    _initializeModelAndAnalyze();
  }

  Future<void> _initializeModelAndAnalyze() async {
    try {
      await _model.initialize();
      await _analyzeImage();
    } catch (e) {
      setState(() {
        _predictions = [];
      });
    }
  }

  Future<void> _analyzeImage() async {
    try {
      final predictions = await _model.predict(widget.imagePath);
      setState(() {
        _predictions = predictions;
      });

      final result = _getPredictionResult();
      if (result.isNotEmpty) {
        Future.delayed(const Duration(seconds: 2), () {
          navigateToChat(context, result);
        });
      }
    } catch (e) {
      setState(() {
        _predictions = [];
      });
    }
  }

  String _getPredictionResult() {
    if (_predictions == null || _predictions!.isEmpty) {
      return 'Error analyzing image';
    }
    final highestIndex = _predictions!
        .indexOf(_predictions!.reduce((a, b) => a > b ? a : b));
    return _classLabels[highestIndex];
  }

  @override
  void dispose() {
    _controller.dispose();
    _model.dispose();
    super.dispose();
  }

  void navigateToChat(BuildContext context, String result) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatScreen(result: result),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Analysis Results',
            style: TextStyle(fontFamily: 'Orbitron')),
        backgroundColor: Colors.green.shade800,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: widget.imagePath,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.file(File(widget.imagePath),
                    height: MediaQuery.of(context).size.height * 0.3),
              ),
            ),
            const SizedBox(height: 30),
            _predictions == null
                ? _buildLoading()
                : _buildResultCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildLoading() {
    return Column(
      children: [
        ScaleTransition(
          scale: Tween(begin: 0.9, end: 1.1).animate(_controller),
          child: const Icon(Icons.science,
              color: Colors.amber, size: 60),
        ),
        const SizedBox(height: 16),
        const Text("Analyzing...",
            style: TextStyle(
                color: Colors.amber,
                fontFamily: 'Orbitron',
                fontSize: 16)),
      ],
    );
  }

  Widget _buildResultCard() {
    if (_predictions == null || _predictions!.isEmpty) {
      return const Text('Error analyzing image. Please try again.',
          style: TextStyle(
              color: Colors.red,
              fontFamily: 'Orbitron',
              fontSize: 16));
    }
    final highestIndex = _predictions!
        .indexOf(_predictions!.reduce((a, b) => a > b ? a : b));
    final result = _classLabels[highestIndex];
    final confidence = (_predictions![highestIndex] * 100);

    return AnimatedOpacity(
      opacity: 1,
      duration: const Duration(milliseconds: 800),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 20),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.amber, width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.amber.withOpacity(0.4),
              blurRadius: 12,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Column(
          children: [
            Text('Prediction: $result',
                style: const TextStyle(
                    color: Colors.amber,
                    fontFamily: 'Orbitron',
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            LinearProgressIndicator(
              value: confidence / 100,
              backgroundColor: Colors.grey.shade800,
              valueColor:
              const AlwaysStoppedAnimation<Color>(Colors.amber),
              minHeight: 10,
              borderRadius: BorderRadius.circular(10),
            ),
            const SizedBox(height: 8),
            Text('Confidence: ${confidence.toStringAsFixed(2)}%',
                style: const TextStyle(
                    color: Colors.amber,
                    fontFamily: 'Orbitron',
                    fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
