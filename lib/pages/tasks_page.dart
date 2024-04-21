import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';
import 'package:notes_goonline/services/database/bloc/task_service_state.dart';
import 'package:notes_goonline/services/database/repositories/task_database_repository.dart';
import 'package:notes_goonline/services/database/task_service.dart';
import 'package:notes_goonline/services/weather_api/bloc/weather_bloc.dart';
import 'package:notes_goonline/services/weather_api/bloc/weather_event.dart';
import 'package:notes_goonline/services/weather_api/bloc/weather_state.dart';
import 'package:notes_goonline/services/weather_api/dio_weather_client.dart';
import 'package:notes_goonline/utils/ui/custom_drawer.dart';
import 'package:notes_goonline/utils/ui/edit_task_dialog.dart';
import 'package:notes_goonline/utils/ui/error_dialog.dart';
import 'package:notes_goonline/utils/ui/sort_menu.dart';
import 'package:notes_goonline/utils/ui/task_tile.dart';
import 'package:notes_goonline/utils/ui/weather_widget.dart';

class TasksPage extends StatelessWidget {
  const TasksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
            create: (context) => TaskServiceBloc(
                TaskService(repository: TaskDatabaseRepository()))),
        BlocProvider(create: (context) => WeatherBloc(DioWeatherClient())),
      ],
      child: const TasksListPage(),
    );
  }
}

class TasksListPage extends StatefulWidget {
  const TasksListPage({super.key});

  @override
  State<TasksListPage> createState() => _TasksListPageState();
}

class _TasksListPageState extends State<TasksListPage> {
  void showSnackBar(String text) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(text),
        duration: const Duration(milliseconds: 400),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        actions: [
          Row(
            children: [
              SortMenu(blocContext: context),
              IconButton(
                  onPressed: () {
                    showEditNoteDialog(context: context);
                  },
                  icon: const Icon(
                    Icons.add,
                    size: 32,
                  ))
            ],
          )
        ],
        title: const Text("TASKS LIST"),
      ),
      drawer: const CustomDrawer(),
      // pull screen to refresh weather
      body: RefreshIndicator(
        onRefresh: () async {
          BlocProvider.of<WeatherBloc>(context).add(const WeatherRequested());
        },
        child: Column(
          children: [
            BlocConsumer<WeatherBloc, WeatherState>(
              listener: (context, state) async {
                if (state.exception != null) {
                  await showErrorDialog(
                      context: context,
                      content:
                          "Weather API Error! \n\nYour request could not be processed!");
                }
              },
              builder: (context, state) {
                if (state is WeatherInitial) {
                  context.read<WeatherBloc>().add(
                        const WeatherRequested(),
                      );
                } else if (state is WeatherLoaded) {
                  return WeatherWidget(weather: state.weather!);
                }

                return const Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("Loaduing weather..."),
                    CircularProgressIndicator(),
                  ],
                );
              },
            ),
            Expanded(
              child: BlocConsumer<TaskServiceBloc, TaskServiceState>(
                listener: (context, state) async {
                  if (state.exception != null) {
                    await showErrorDialog(
                        context: context,
                        content:
                            "Database Error! \n\nYour request could not be processed!");
                  }
                },
                builder: (context, state) {
                  if (state is TaskServiceInitial) {
                    context.read<TaskServiceBloc>().add(
                          TaskServiceLoadTasksRequested(),
                        );
                  } else if (state is TripServiceTripsLoaded) {
                    return Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        children: [
                          Text("SSS"),
                          Expanded(
                            child: GridView.count(
                                crossAxisCount: 2,
                                children:
                                    List.generate(state.tasks.length, (index) {
                                  return TaskTile(
                                      task: state.tasks[index],
                                      onTap: () {
                                        showEditNoteDialog(
                                            context: context,
                                            task: state.tasks[index]);
                                      });
                                })),
                          ),
                        ],
                      ),
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
