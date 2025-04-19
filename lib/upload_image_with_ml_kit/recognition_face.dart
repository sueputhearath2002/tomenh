import 'dart:io';
import 'dart:math';
import 'dart:typed_data';

import 'package:tflite_flutter/tflite_flutter.dart';

import 'image_process.dart';

class FaceRecognitionService {
  late Interpreter _interpreter;

  Future<void> loadModel() async {
    if (_interpreter != null) return; // Prevent reinitialization
    try {
      _interpreter = await Interpreter.fromAsset('assets/model_unquant.tflite');
      print("Model loaded successfully");
    } catch (e) {
      print("Error loading model: $e");
      throw Exception("Failed to load model");
    }
  }

  Future<List<double>> generateEmbeddings(File imageFile) async {
    const int inputSize = 160;
    const int embeddingSize = 128;

    // Preprocess the image
    Uint8List input = ImageProcessor.preprocessImage(imageFile, inputSize);

    // Prepare input and output tensors
    var output = List.filled(embeddingSize, 0.0).reshape([1, embeddingSize]);

    // Run inference
    try {
      _interpreter.run(
          input.buffer.asFloat32List().reshape([1, inputSize, inputSize, 3]),
          output);
      return output[0];
    } catch (e) {
      print("Error during inference: $e");
      rethrow;
    }
  }

  double compareEmbeddings(List<double> emb1, List<double> emb2) {
    if (emb1.length != emb2.length) {
      throw Exception("Embeddings must have the same length");
    }

    double sumSquaredDiffs = 0.0;
    for (int i = 0; i < emb1.length; i++) {
      sumSquaredDiffs += (emb1[i] - emb2[i]) * (emb1[i] - emb2[i]);
    }
    return sqrt(sumSquaredDiffs);
  }
}
