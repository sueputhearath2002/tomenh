import 'dart:io';
import 'dart:typed_data';

import 'package:image/image.dart' as img;

class ImageProcessor {
  static Uint8List preprocessImage(File imageFile, int inputSize) {
    // Decode the image file into an image object
    final img.Image? originalImage =
        img.decodeImage(imageFile.readAsBytesSync());
    if (originalImage == null) {
      throw Exception("Failed to decode image");
    }

    // Resize the image to the required input size (e.g., 160x160)
    final img.Image resizedImage =
        img.copyResize(originalImage, width: inputSize, height: inputSize);

    // Normalize pixel values to the range [-1, 1]
    final Float32List normalizedImage = Float32List(inputSize * inputSize * 3);
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        // Get the pixel object
        final pixel = resizedImage.getPixelSafe(x, y);

        // Extract RGB values and normalize
        final red = pixel.r / 255.0 * 2 - 1; // Normalize to [-1, 1]
        final green = pixel.g / 255.0 * 2 - 1;
        final blue = pixel.b / 255.0 * 2 - 1;

        // Calculate index in the normalized image array
        final index = (y * inputSize + x) * 3;
        normalizedImage[index] = red;
        normalizedImage[index + 1] = green;
        normalizedImage[index + 2] = blue;
      }
    }

    return normalizedImage.buffer.asUint8List();
  }
}
