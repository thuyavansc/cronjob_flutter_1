import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'background_service.dart';
import 'background_service_provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Request the SCHEDULE_EXACT_ALARM permission
  await requestAlarmPermission();

  // Initialize the background service
  await initializeService();

  runApp(
    ChangeNotifierProvider(
      create: (context) => BackgroundServiceProvider(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Cron Job Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BackgroundServiceProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Cron Job Example'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cron jobs running in background service',
              style: TextStyle(fontSize: 20),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: provider.isServiceRunning
                  ? provider.stopService
                  : provider.initializeService,
              child: Text(provider.isServiceRunning ? 'Stop Service' : 'Start Service'),
            ),
          ],
        ),
      ),
    );
  }
}


Future<void> requestAlarmPermission() async {
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
}