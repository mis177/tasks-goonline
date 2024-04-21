import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/models/task_model.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';
import 'package:notes_goonline/services/database/bloc/task_service_state.dart';
import 'package:notes_goonline/services/database/task_service.dart';
import 'package:notes_goonline/utils/sort_tasks.dart';

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
        emit(TripServiceTripsLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskAddRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          await service.addTask(event.task);
          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TripServiceTripsLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskUpdateRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          await service.updateTask(event.task);
          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TripServiceTripsLoaded(tasks: tasks, exception: exception));
      },
    );

    on<TaskServiceTaskDeleteRequested>(
      (event, emit) async {
        emit(const TaskServiceLoading());
        Exception? exception;
        List<Task> tasks = [];
        try {
          await service.deleteTask(event.task);
          tasks = await service.getTasks();
        } on Exception catch (e) {
          exception = e;
        }
        emit(TripServiceTripsLoaded(tasks: tasks, exception: exception));
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
        emit(TripServiceTripsLoaded(tasks: tasks, exception: exception));
      },
    );
  }
}
