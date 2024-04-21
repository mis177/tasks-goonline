import 'package:notes_goonline/models/task_model.dart';

List<Task> sortTasks(List<Task> tasks, String columnName, bool isAscending) {
  switch (columnName) {
    case 'name':
      isAscending == true
          ? tasks.sort((a, b) => a.name.compareTo(b.name))
          : tasks.sort((a, b) => b.name.compareTo(a.name));

      return tasks;
    case 'description':
      isAscending == true
          ? tasks.sort((a, b) => a.description.compareTo(b.description))
          : tasks.sort((a, b) => b.description.compareTo(a.description));
      return tasks;
    case 'deadline':
      isAscending == true
          ? tasks.sort((a, b) => a.deadline.compareTo(b.deadline))
          : tasks.sort((a, b) => b.deadline.compareTo(a.deadline));
      return tasks;
    case 'priority':
      isAscending == true
          ? tasks.sort((a, b) => a.priority.compareTo(b.priority))
          : tasks.sort((a, b) => b.priority.compareTo(a.priority));

      return tasks;
  }

  return tasks;
}
