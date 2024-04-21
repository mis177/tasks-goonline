import 'package:notes_goonline/models/task_model.dart';
import 'package:notes_goonline/services/database/repositories/task_database_repository.dart';

class TaskService {
  late TaskDatabaseRepository _repository;

  static final TaskService _instance = TaskService._internal();
  TaskService._internal();
  factory TaskService({required TaskDatabaseRepository repository}) {
    _instance._repository = repository;
    return _instance;
  }

  // List<Task> _tasks = [];

  // List<Task> get tasks => _tasks;

  Future<List<Task>> getTasks() async {
    List<Task> dbTasks = [];
    try {
      dbTasks = await _repository.getTasks();
    } catch (e) {
      rethrow;
    }

    //  _tasks = dbTasks;
    return dbTasks;
  }

  Future<void> addTask(Task task) async {
    await _repository.addTask(task);

    //   _tasks.add(task);
  }

  Future<void> updateTask(Task task) async {
    await _repository.updateTask(task);

    // int updatedTaskIndex =
    //     _tasks.indexWhere((taskFromList) => taskFromList == task);

    // _tasks[updatedTaskIndex] = task;
  }

  Future<void> deleteTask(Task task) async {
    await _repository.deleteTask(task);

    // _tasks.remove(task);
  }
}
