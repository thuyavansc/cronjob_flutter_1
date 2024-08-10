import 'package:flutter/material.dart';

import 'package:cron/cron.dart';

void main() async {
  runApp(MyApp());

  // Create an instance of Cron
  final cron = Cron();

  // Example 1: Schedule a task to run every three minutes
  cron.schedule(Schedule.parse('*/1 * * * *'), () async {
    print('Task 1: Runs every three minutes');
  });

  // Example 2: Schedule a task to run between the 8th and 11th minute of every hour
  cron.schedule(Schedule.parse('8-11 * * * *'), () async {
    print('Task 2: Runs between the 8th and 11th minute of every hour');
  });

  // Example 3: Schedule a task to run at 12:25 PM on Tuesdays and Wednesdays
  cron.schedule(Schedule(hours: 12, minutes: 25, weekdays: [2, 3]), () async {
    print('Task 3: Runs at 12:25 PM on Tuesdays and Wednesdays');
  });

  // Example 4: Schedule a task to run at 10:00 AM on the 1st of January
  cron.schedule(Schedule(hours: 10, minutes: 0, days: 1, months: 1), () async {
    print('Task 4: Runs at 10:00 AM on the 1st of January');
  });

  // Example 5: Parsing and converting cron expressions
  final parsedSchedule = Schedule.parse('*/5 12 * * 1-5');
  print('Parsed Schedule (minutes): ${parsedSchedule.minutes}'); // Outputs: [0, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50, 55]
  print('Parsed Schedule (hours): ${parsedSchedule.hours}'); // Outputs: [12]
  print('Parsed Schedule (weekdays): ${parsedSchedule.weekdays}'); // Outputs: [1, 2, 3, 4, 5]

  final cronString = Schedule(hours: 9, minutes: 30, weekdays: [1, 5]).toCronString();
  print('Cron String: $cronString'); // Outputs: 30 9 * * 1,5

  // Example 6: Schedule a task that checks the time and runs if the schedule matches
  cron.schedule(Schedule.parse('* * * * *'), () async {
    final now = DateTime.now();
    final shouldRun = parsedSchedule.shouldRunAt(now);
    if (shouldRun) {
      print('Task 5: Running because the current time matches the schedule.');
    } else {
      print('Task 5: Skipped, time does not match the schedule.');
    }
  });

  // Example 7: Cancelling a scheduled task
  final scheduledTask = cron.schedule(Schedule.parse('*/10 * * * *'), () async {
    print('Task 6: Runs every 10 minutes');
  });

  // Cancel the scheduled task after 1 minute (for demonstration purposes)
  await Future.delayed(Duration(minutes: 1));
  await scheduledTask.cancel();
  print('Task 6: Cancelled after 1 minute');

  // Close the cron instance to clean up resources
  //await cron.close();
  //print('Cron instance closed');
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
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter Cron Job Example'),
      ),
      body: Center(
        child: Text(
          'Check console output for cron job execution',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}