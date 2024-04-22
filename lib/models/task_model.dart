import 'package:notes_goonline/const/database_const.dart';

class Task {
  final int id;
  final String name;
  final String description;
  final int deadline;
  final int? doneDate;
  final int priority;
  final String owner;
  final String status;

  Task(
      {required this.id,
      required this.name,
      required this.description,
      required this.deadline,
      required this.doneDate,
      required this.priority,
      required this.owner,
      required this.status});

  Task.fromRow(Map<String, Object?> row)
      : id = row[idColumn] as int,
        name = row[nameColumn] as String,
        description = row[descriptionColumn] as String,
        deadline = row[deadlineColumn] as int,
        doneDate = row[doneDateColumn] as int,
        priority = row[priorityColumn] as int,
        owner = row[ownerColumn] as String,
        status = row[statusColumn] as String;

  @override
  bool operator ==(covariant Task other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}
