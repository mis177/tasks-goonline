import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';
import 'package:notes_goonline/services/database/bloc/task_service_state.dart';
import 'package:notes_goonline/services/database/repositories/task_database_repository.dart';
import 'package:notes_goonline/services/database/task_service.dart';
import 'package:notes_goonline/utils/ui/custom_drawer.dart';
import 'package:notes_goonline/utils/ui/error_dialog.dart';
import 'package:notes_goonline/utils/ui/stats_widget.dart';

class StatsPageProvider extends StatelessWidget {
  const StatsPageProvider({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TaskServiceBloc(TaskService(repository: TaskDatabaseRepository())),
      child: const StatsPage(),
    );
  }
}

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        centerTitle: true,
        title: const Text("TASKS STATS"),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      drawer: const CustomDrawer(),
      body: BlocConsumer<TaskServiceBloc, TaskServiceState>(
        listener: (context, state) async {
          if (state.exception != null) {
            await showErrorDialog(
                context: context, content: "Database Error! \n\nYour request could not be processed!");
          }
        },
        builder: (context, state) {
          if (state is TaskServiceInitial) {
            context.read<TaskServiceBloc>().add(
                  TaskServiceLoadTasksRequested(),
                );
          } else if (state is TaskServiceTripsLoaded) {
            context.read<TaskServiceBloc>().add(
                  TaskServiceStatsRequested(tasks: state.tasks),
                );
          } else if (state is TripServiceStatsLoaded) {
            return StatsWidget(stats: state.tasksStats);
          }

          return const Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Loading stats"),
                SizedBox(height: 24),
                CircularProgressIndicator(),
              ],
            ),
          );
        },
      ),
    );
  }
}
