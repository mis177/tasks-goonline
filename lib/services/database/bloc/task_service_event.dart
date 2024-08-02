import 'package:equatable/equatable.dart';
import 'package:notes_goonline/models/task_model.dart';

sealed class TaskServiceEvent extends Equatable {
  const TaskServiceEvent();
  @override
  List<Object?> get props => [];
}

class TaskServiceLoadTasksRequested extends TaskServiceEvent {}

class TaskServiceTaskAddRequested extends TaskServiceEvent {
  final Task task;

  const TaskServiceTaskAddRequested({required this.task});
  @override
  List<Object?> get props => [task];
}

class TaskServiceTaskUpdateRequested extends TaskServiceEvent {
  final Task task;
  final bool isDeadlineChanged;
  final bool isStatusChanged;

  const TaskServiceTaskUpdateRequested(
      {required this.task, required this.isDeadlineChanged, required this.isStatusChanged});
  @override
  List<Object?> get props => [task];
}

class TaskServiceTaskDeleteRequested extends TaskServiceEvent {
  final Task task;

  const TaskServiceTaskDeleteRequested({required this.task});
  @override
  List<Object?> get props => [task];
}

class TaskServiceTaskSortRequested extends TaskServiceEvent {
  final String columnName;
  final bool isAscending;

  const TaskServiceTaskSortRequested({
    required this.columnName,
    required this.isAscending,
  });
  @override
  List<Object?> get props => [columnName];
}

class TaskServiceStatsRequested extends TaskServiceEvent {
  final List<Task> tasks;

  const TaskServiceStatsRequested({
    required this.tasks,
  });
  @override
  List<Object?> get props => [tasks];
}
