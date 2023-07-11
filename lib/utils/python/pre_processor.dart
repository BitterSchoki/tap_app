import 'package:flython/flython.dart';

class PreProcessor extends Flython {
  Future<dynamic> preprocessData({
    required List<List<double>> accelerometerData,
    required List<List<double>> gyroscopeData,
    required List<List<double>> outputFile,
  }) async {
    var command = {
      "cmd": 1,
      "accelerometerData": accelerometerData,
      "gyroscopeData": gyroscopeData,
      "output": outputFile,
    };
    return await runCommand(command);
  }
}
