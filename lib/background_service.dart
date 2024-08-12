//
// import 'dart:async';
// import 'dart:isolate';
// import 'dart:ui';
// import 'package:flutter_background_service/flutter_background_service.dart';
// import 'package:flutter_background_service_android/flutter_background_service_android.dart';
// import 'package:cron/cron.dart';
//
// Future<void> initializeService() async {
//   final service = FlutterBackgroundService();
//   await service.configure(
//     androidConfiguration: AndroidConfiguration(
//       onStart: onStart,
//       isForegroundMode: true,
//       autoStart: true,
//     ),
//     iosConfiguration: IosConfiguration(
//       autoStart: true,
//       onForeground: onStart,
//       onBackground: onIosBackground,
//     ),
//   );
//   service.startService();
// }
//
// @pragma('vm:entry-point')
// void onStart(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//
//   final cron = Cron();
//
//   // Example 1: Schedule a task to run every one minute
//   cron.schedule(Schedule.parse('*/1 * * * *'), () async {
//     print('Task 1: Runs every minute');
//   });
//
//   // Example 2: Schedule a task to run between the 8th and 11th minute of every hour
//   cron.schedule(Schedule.parse('8-11 * * * *'), () async {
//     print('Task 2: Runs between the 8th and 11th minute of every hour');
//   });
//
//   // Example 3: Schedule a task to run at 12:25 PM on Tuesdays and Wednesdays
//   cron.schedule(Schedule(hours: 12, minutes: 25, weekdays: [2, 3]), () async {
//     print('Task 3: Runs at 12:25 PM on Tuesdays and Wednesdays');
//   });
//
//   // Example 4: Schedule a task to run at 10:00 AM on the 1st of January
//   cron.schedule(Schedule(hours: 10, minutes: 0, days: 1, months: 1), () async {
//     print('Task 4: Runs at 10:00 AM on the 1st of January');
//   });
//
//   // Example 6: Schedule a task that checks the time and runs if the schedule matches
//   final parsedSchedule = Schedule.parse('*/5 12 * * 1-5');
//   cron.schedule(Schedule.parse('* * * * *'), () async {
//     final now = DateTime.now();
//     final shouldRun = parsedSchedule.shouldRunAt(now);
//     if (shouldRun) {
//       print('Task 5: Running because the current time matches the schedule.');
//     } else {
//       print('Task 5: Skipped, time does not match the schedule.');
//     }
//   });
//
//   // Example 7: Cancelling a scheduled task
//   final scheduledTask = cron.schedule(Schedule.parse('*/10 * * * *'), () async {
//     print('Task 6: Runs every 10 minutes');
//   });
//
//   // Cancel the scheduled task after 1 minute (for demonstration purposes)
//   await Future.delayed(Duration(minutes: 1));
//   await scheduledTask.cancel();
//   print('Task 6: Cancelled after 1 minute');
//
//   service.on('stopService').listen((event) {
//     service.stopSelf();
//   });
//
//   Timer.periodic(const Duration(seconds: 30), (timer) async {
//     // This will keep the service alive and responsive.
//     service.invoke('update', {
//       "current_date": DateTime.now().toIso8601String(),
//     });
//
//     if (service is AndroidServiceInstance) {
//       if (await service.isForegroundService()) {
//         service.setForegroundNotificationInfo(
//           title: "Cron Job Service",
//           content: "Running scheduled tasks in the background",
//         );
//       }
//     }
//     print('Background service is running : ');
//   });
// }
//
// @pragma('vm:entry-point')
// Future<bool> onIosBackground(ServiceInstance service) async {
//   DartPluginRegistrant.ensureInitialized();
//   return true;
// }


import 'dart:async';
import 'dart:ui';

import 'package:flutter_background_service/flutter_background_service.dart';
import 'package:flutter_background_service_android/flutter_background_service_android.dart';

import 'cronjob_manager.dart';

Future<void> initializeService() async {
  final service = FlutterBackgroundService();
  await service.configure(
    androidConfiguration: AndroidConfiguration(
      onStart: onStart,
      isForegroundMode: true,
      autoStart: true,
    ),
    iosConfiguration: IosConfiguration(
      autoStart: true,
      onForeground: onStart,
      onBackground: onIosBackground,
    ),
  );
  service.startService();
}

@pragma('vm:entry-point')
void onStart(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();

  final cronJobManager = CronJobManager();
  cronJobManager.startAllJobs();

  service.on('stopCronJobs').listen((event) {
    cronJobManager.stopAllJobs();
    service.invoke('updateCronJobStatus', {'isRunning': false});
  });

  service.on('startCronJobs').listen((event) {
    cronJobManager.startAllJobs();
    service.invoke('updateCronJobStatus', {'isRunning': true});
  });

  Timer.periodic(const Duration(seconds: 1), (timer) async {
    service.invoke('update', {
      "current_date": DateTime.now().toIso8601String(),
    });

    if (service is AndroidServiceInstance) {
      if (await service.isForegroundService()) {
        service.setForegroundNotificationInfo(
          title: "Cron Job Service",
          content: "Running scheduled tasks in the background",
        );
      }
    }
  });
}

@pragma('vm:entry-point')
Future<bool> onIosBackground(ServiceInstance service) async {
  DartPluginRegistrant.ensureInitialized();
  return true;
}
