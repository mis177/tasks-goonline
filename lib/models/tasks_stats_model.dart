import 'package:notes_goonline/const/task_status.dart';
import 'package:notes_goonline/models/task_model.dart';

class TasksStats {
  final int allTasksDone;
  final int allTasks;

  // daily stats
  final int tasksDoneToday;
  final int tasksInExecutionToday;
  final int tasksInPlanningToday;

  // weekly stats
  final int tasksDoneWeekly;
  final int tasksInExecutionWeekly;
  final int tasksInPlanningWeekly;

  TasksStats(
      {required this.allTasksDone,
      required this.allTasks,
      required this.tasksDoneToday,
      required this.tasksInExecutionToday,
      required this.tasksInPlanningToday,
      required this.tasksDoneWeekly,
      required this.tasksInExecutionWeekly,
      required this.tasksInPlanningWeekly});

  factory TasksStats.fromTasksList(List<Task> tasks) {
    final DateTime now = DateTime.now();
    final DateTime today = DateTime(now.year, now.month, now.day)
        .subtract(const Duration(seconds: 1));
    final DateTime todayMidnight =
        DateTime(now.year, now.month, now.day, 24, 59);

    final weekAgo = now.add(const Duration(days: 7));

    final int allTasksDone =
        tasks.where((task) => task.status == taskStatus[2]).length;
    final int allTasks = tasks.length;

    // daily stats
    final int tasksDoneToday = tasks
        .where((task) =>
            task.doneDate! > today.millisecondsSinceEpoch &&
            task.status == taskStatus[2])
        .length;

    final int tasksInExecutionToday = tasks
        .where((task) =>
            task.deadline > today.millisecondsSinceEpoch &&
            task.deadline < todayMidnight.millisecondsSinceEpoch &&
            task.status == taskStatus[1])
        .length;

    final int tasksInPlanningToday = tasks
        .where((task) =>
            task.deadline > today.millisecondsSinceEpoch &&
            task.deadline < todayMidnight.millisecondsSinceEpoch &&
            task.status == taskStatus[0])
        .length;

    // weekly stats
    final int tasksDoneWeekly = tasks
        .where((task) =>
            task.doneDate! > weekAgo.millisecondsSinceEpoch &&
            task.status == taskStatus[2])
        .length;
    final int tasksInExecutionWeekly = tasks
        .where((task) =>
            task.deadline > weekAgo.millisecondsSinceEpoch &&
            task.deadline < todayMidnight.millisecondsSinceEpoch &&
            task.status == taskStatus[1])
        .length;
    final int tasksInPlanningWeekly = tasks
        .where((task) =>
            task.deadline > weekAgo.millisecondsSinceEpoch &&
            task.deadline < todayMidnight.millisecondsSinceEpoch &&
            task.status == taskStatus[0])
        .length;

    return TasksStats(
      allTasksDone: allTasksDone,
      allTasks: allTasks,
      tasksDoneToday: tasksDoneToday,
      tasksInExecutionToday: tasksInExecutionToday,
      tasksInPlanningToday: tasksInPlanningToday,
      tasksDoneWeekly: tasksDoneWeekly,
      tasksInExecutionWeekly: tasksInExecutionWeekly,
      tasksInPlanningWeekly: tasksInPlanningWeekly,
    );
  }

  factory TasksStats.empty() {
    return TasksStats(
        allTasksDone: 0,
        allTasks: 0,
        tasksDoneToday: 0,
        tasksInExecutionToday: 0,
        tasksInPlanningToday: 0,
        tasksDoneWeekly: 0,
        tasksInExecutionWeekly: 0,
        tasksInPlanningWeekly: 0);
  }
}
