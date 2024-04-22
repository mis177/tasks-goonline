import 'package:notes_goonline/models/task_model.dart';
import 'package:timezone/timezone.dart';

TZDateTime computeNotificationTime({
  required Task task,
  required Duration timeBeforeDeadline,
}) {
  TZDateTime nowTZDate = TZDateTime.now(local);

  DateTime nowDate = DateTime.now();

  // local TZDateTime and DateTime difference correction
  Duration difference = nowDate.difference(DateTime(nowTZDate.year,
      nowTZDate.month, nowTZDate.day, nowTZDate.hour, nowTZDate.minute));

  DateTime notificationDateTime =
      DateTime.fromMillisecondsSinceEpoch(task.deadline)
          .subtract(timeBeforeDeadline);

  DateTime correctedNotificationDateTime =
      notificationDateTime.subtract(difference);

  //int notificationId = event.id
  TZDateTime notificationTime = TZDateTime(
    local,
    correctedNotificationDateTime.year,
    correctedNotificationDateTime.month,
    correctedNotificationDateTime.day,
    correctedNotificationDateTime.hour,
    correctedNotificationDateTime.minute,
  );

  return notificationTime;
}
