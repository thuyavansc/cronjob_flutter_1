
import 'package:cron/cron.dart';

class CronJobManager {
  final Cron _cron = Cron();
  List<ScheduledTask> _tasks = [];

  void startAllJobs() {
    _tasks = [
      // Example 1: Schedule a task to run every one minute
      _cron.schedule(Schedule.parse('*/1 * * * *'), () async {
        print('Task 1: Runs every minute');
      }),

      // Example 2: Schedule a task to run between the 8th and 11th minute of every hour
      _cron.schedule(Schedule.parse('8-11 * * * *'), () async {
        print('Task 2: Runs between the 8th and 11th minute of every hour');
      }),

      // Example 3: Schedule a task to run at 12:25 PM on Tuesdays and Wednesdays
      _cron.schedule(Schedule(hours: 12, minutes: 25, weekdays: [2, 3]), () async {
        print('Task 3: Runs at 12:25 PM on Tuesdays and Wednesdays');
      }),

      // Example 4: Schedule a task to run at 10:00 AM on the 1st of January
      _cron.schedule(Schedule(hours: 10, minutes: 0, days: 1, months: 1), () async {
        print('Task 4: Runs at 10:00 AM on the 1st of January');
      }),

      // Example 6: Schedule a task that checks the time and runs if the schedule matches
      _cron.schedule(Schedule.parse('* * * * *'), () async {
        final parsedSchedule = Schedule.parse('*/5 12 * * 1-5');
        final now = DateTime.now();
        final shouldRun = parsedSchedule.shouldRunAt(now);
        if (shouldRun) {
          print('Task 5: Running because the current time matches the schedule.');
        } else {
          print('Task 5: Skipped, time does not match the schedule.');
        }
      }),
    ];
  }

  void stopAllJobs() {
    for (var task in _tasks) {
      task.cancel();
    }
    _tasks.clear();
    print('All cron jobs stopped.');
  }

  bool get areJobsRunning => _tasks.isNotEmpty;
}
