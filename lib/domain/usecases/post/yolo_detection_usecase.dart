import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:yolo_helper/yolo_helper.dart';

class yoloDetectionUseCase {
  List<String>? _labels;
  String label(int index) {
    return _labels![index];
  }

  Interpreter? _interpreter;

  bool get isInit => _interpreter != null && _labels != null;

  Future<void> init() async {
    _interpreter = await Interpreter.fromAsset('assets/yolo/yolov8n.tflite');
    final labelStrings = await rootBundle.loadString('assets/yolo/labels.txt');
    _labels = labelStrings.split('\n');
  }

  bool _isRunning = false;

  List<DetectedObject> runInference(Image image) {
    if (!isInit) {
      throw Exception('The model must be initialized');
    }
    final resizedImage = copyResize(image, width: 640, height: 640);

    final imageNormalized = List.generate(
      640,
      (y) => List.generate(
        640,
        (x) {
          final pixel = resizedImage.getPixel(x, y);
          return [pixel.r / 255.0, pixel.g / 255.0, pixel.b / 255.0];
        },
      ),
    );
    final output = [
      List<List<double>>.filled(84, List<double>.filled(8400, 0.0))
    ];
    _isRunning = true; // 인퍼런스 시작
    try {
      print(
          '인퍼런스 돌리는 중 with input shape: ${imageNormalized.length}x${imageNormalized[0].length}');
      _interpreter!.run(imageNormalized, output);
    } catch (e) {
      print('Failed to run inference: $e');
      throw Exception('Failed to run inference: $e');
    }
    return YoloHelper.parse(output[0], image.width, image.height);
  }

  bool get isRunning => _isRunning;

  void dispose() {
    _interpreter?.close();
    _interpreter = null;
    _labels = null;
    _isRunning = false;
  }
}
