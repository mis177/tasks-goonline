import 'package:flutter/material.dart';
import 'package:notes_goonline/const/routes.dart';
import 'package:notes_goonline/pages/stats_page.dart';
import 'package:notes_goonline/pages/tasks_page.dart';

import 'package:notes_goonline/theme/theme.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const TasksPage(),
      theme: lightMode,
      routes: {
        tasksListRoute: (context) => const TasksPage(),
        tasksStatsRoute: (context) => const StatsPageProvider()
      },
    );
  }
}
