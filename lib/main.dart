import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/const/routes.dart';
import 'package:notes_goonline/pages/stats_page.dart';
import 'package:notes_goonline/pages/tasks_page.dart';
import 'package:notes_goonline/services/database/bloc/task_service_bloc.dart';
import 'package:notes_goonline/services/database/repositories/task_database_repository.dart';
import 'package:notes_goonline/services/database/task_service.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: BlocProvider(
        create: (context) =>
            TaskServiceBloc(TaskService(repository: TaskDatabaseRepository())),
        child: const TasksListPage(),
      ),
      routes: {
        tasksListRoute: (context) => const TasksPage(),
        tasksStatsRoute: (context) => const StatsPage()
      },
    );
  }
}
