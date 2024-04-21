import 'package:equatable/equatable.dart';
import 'package:notes_goonline/models/task_model.dart';

sealed class TaskServiceState extends Equatable {
  final Exception? exception;
  const TaskServiceState({this.exception});
  @override
  List<Object?> get props => [];
}

class TaskServiceInitial extends TaskServiceState {
  const TaskServiceInitial();
}

class TaskServiceLoading extends TaskServiceState {
  const TaskServiceLoading();
}

class TripServiceTripsLoaded extends TaskServiceState {
  final List<Task> tasks;

  const TripServiceTripsLoaded({required this.tasks, required super.exception});

  @override
  List<Object?> get props => [tasks];
}
