import 'package:flython/flython.dart';

class PreProcessor extends Flython {
  Future<dynamic> preprocessData({
    required List<List<double>> accelerometerData,
    required List<List<double>> gyroscopeData,
    required List<List<double>> ouput,
  }) async {
    var command = {
      "cmd": 0,
      "accelerometerData": accelerometerData,
      "gyroscopeData": gyroscopeData,
      "output": ouput,
    };
    return await runCommand(command);
  }
}
