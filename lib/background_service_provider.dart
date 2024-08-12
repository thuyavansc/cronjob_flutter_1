
import 'package:flutter/cupertino.dart';
import 'package:flutter_background_service/flutter_background_service.dart';

class BackgroundServiceProvider with ChangeNotifier {
  bool _isServiceRunning = false;

  bool get isServiceRunning => _isServiceRunning;

  Future<void> initializeService() async {
    final service = FlutterBackgroundService();
    _isServiceRunning = await service.isRunning();
    if (!_isServiceRunning) {
      await initializeService();
      _isServiceRunning = true;
    }
    notifyListeners();
  }

  Future<void> stopService() async {
    final service = FlutterBackgroundService();
    if (_isServiceRunning) {
      service.invoke('stopService');
      _isServiceRunning = false;
      notifyListeners();
    }
  }
}
