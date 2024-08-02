import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/const/task_status.dart';
import 'package:notes_goonline/models/task_model.dart';
import 'package:notes_goonline/models/tasks_stats_model.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';
import 'package:notes_goonline/services/database/bloc/task_service_state.dart';
import 'package:notes_goonline/services/database/task_service.dart';
import 'package:notes_goonline/services/notifications/notifications_service.dart';
import 'package:notes_goonline/utils/notification_time.dart';
import 'package:notes_goonline/utils/sort_tasks.dart';
import 'package:timezone/timezone.dart';

class TaskServiceBloc extends Bloc<TaskServiceEvent, TaskServiceState> {
  TaskServiceBloc(TaskService service) : super(const TaskServiceInitial()) {
    on<TaskServiceLoadTasksRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TaskServiceTasksLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskAddRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          await service.addTask(event.task);
          // schedule notification to remind user about task 12h before deadline
          // if task has status planned or executing
          if (event.task.status == taskStatus[0] || event.task.status == taskStatus[1]) {
            TZDateTime? notificationTime =
                computeNotificationTime(task: event.task, timeBeforeDeadline: const Duration(hours: 12));

            if (notificationTime != null) {
              NotificationsService.scheduledNotification(
                id: (event.task.id / 1000).floor(),
                title: event.task.name,
                body: '${event.task.owner} - You have 12 hours before deadline!',
                notificationTime: notificationTime,
              );
            }
          }

          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TaskServiceTasksLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskUpdateRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          await service.updateTask(event.task);
          // set new notification with updated deadline
          // if task has status planned or executing
          if (event.isDeadlineChanged && event.task.status == taskStatus[0] || event.task.status == taskStatus[1]) {
            NotificationsService.cancelNotification((event.task.id / 1000).floor());

            TZDateTime? notificationTime =
                computeNotificationTime(task: event.task, timeBeforeDeadline: const Duration(hours: 12));
            if (notificationTime != null) {
              NotificationsService.scheduledNotification(
                id: (event.task.id / 1000).floor(),
                title: event.task.name,
                body: '${event.task.owner} - You have 12 hours before deadline!',
                notificationTime: notificationTime,
              );
            }

            // task status changed to done, cancelNotification
          } else if (event.isStatusChanged && event.task.status == taskStatus[2]) {
            NotificationsService.cancelNotification((event.task.id / 1000).floor());
            // status changed from done, schedule notification
          } else if (event.isStatusChanged && event.task.status != taskStatus[2]) {
            TZDateTime? notificationTime =
                computeNotificationTime(task: event.task, timeBeforeDeadline: const Duration(hours: 12));
            if (notificationTime != null) {
              NotificationsService.scheduledNotification(
                id: (event.task.id / 1000).floor(),
                title: event.task.name,
                body: '${event.task.owner} - You have 12 hours before deadline!',
                notificationTime: notificationTime,
              );
            }
          }
          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TaskServiceTasksLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskDeleteRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];

        try {
          await service.deleteTask(event.task);
          // cancel task notification
          NotificationsService.cancelNotification((event.task.id / 1000).floor());
          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TaskServiceTasksLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskSortRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          tasks = await service.getTasks();
          tasks = sortTasks(tasks, event.columnName, event.isAscending);
        } on Exception catch (e) {
          exception = e;
        }
        emit(TaskServiceTasksLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceStatsRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        TasksStats tasksStats = TasksStats.empty();
        try {
          List<Task> tasks = await service.getTasks();
          tasksStats = TasksStats.fromTasksList(tasks);
        } on Exception catch (e) {
          exception = e;
        }
        emit(TaskServiceStatsLoaded(
          tasksStats: tasksStats,
          exception: exception,
        ));
      },
    );
  }
}
