import 'package:notes_goonline/models/task_model.dart';
import 'package:timezone/timezone.dart';

TZDateTime? computeNotificationTime({
  required Task task,
  required Duration timeBeforeDeadline,
}) {
  // Pobierz bieżący czas w lokalnej strefie czasowej
  TZDateTime nowTZDate = TZDateTime.now(local);

  // Oblicz czas powiadomienia na podstawie terminu zadania i czasu przed terminem
  TZDateTime deadlineDateTime = TZDateTime.fromMillisecondsSinceEpoch(local, task.deadline);
  TZDateTime notificationDateTime = deadlineDateTime.subtract(timeBeforeDeadline);

  // Sprawdź, czy czas powiadomienia jest w przyszłości
  if (notificationDateTime.isAfter(nowTZDate)) {
    return notificationDateTime;
  } else {
    return null;
  }
}
