import 'package:notes_goonline/models/task_model.dart';

List<Task> sortTasks(List<Task> tasks, String columnName, bool isAscending) {
  // Określ funkcję porównującą na podstawie kolumny
  int Function(Task a, Task b) compareFunction;

  switch (columnName) {
    case 'name':
      compareFunction = (a, b) => a.name.compareTo(b.name);
      break;
    case 'description':
      compareFunction = (a, b) => a.description.compareTo(b.description);
      break;
    case 'deadline':
      compareFunction = (a, b) => a.deadline.compareTo(b.deadline);
      break;
    case 'priority':
      compareFunction = (a, b) => a.priority.compareTo(b.priority);
      break;
    default:
      // Obsługuje przypadek, gdy nie podano prawidłowej nazwy kolumny
      return tasks;
  }

  // Sortowanie z uwzględnieniem kierunku
  tasks.sort(isAscending ? compareFunction : (a, b) => compareFunction(b, a));

  return tasks;
}
