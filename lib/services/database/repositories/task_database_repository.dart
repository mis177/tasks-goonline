import 'package:notes_goonline/models/task_model.dart';
import 'package:notes_goonline/services/database/task_database.dart';
import 'package:notes_goonline/services/database/repositories/task_repository.dart';

class TaskDatabaseRepository implements TaskRepository {
  final TaskDatabase database;

  TaskDatabaseRepository._internal(this.database);
  static TaskDatabaseRepository? _instance;
  // Factory constructor for singleton access
  factory TaskDatabaseRepository(TaskDatabase database) {
    _instance ??= TaskDatabaseRepository._internal(database);
    return _instance!;
  }

  @override
  Future<List<Task>> getTasks() async {
    List<Map<String, Object?>> dbTasks = [];
    try {
      dbTasks = await database.getTasks();
    } catch (e) {
      rethrow;
    }

    List<Task> tasks = [];

    for (var task in dbTasks) {
      tasks.add(Task.fromRow(task));
    }
    return tasks;
  }

  @override
  Future<void> addTask(Task task) async {
    try {
      await database.addTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> updateTask(Task task) async {
    try {
      await database.updateTask(task);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteTask(Task task) async {
    try {
      await database.deleteTask(task);
    } catch (e) {
      rethrow;
    }
  }
}
