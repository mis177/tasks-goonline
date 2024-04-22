import 'package:flutter/material.dart';
import 'package:notes_goonline/models/tasks_stats_model.dart';

class StatsWidget extends StatelessWidget {
  const StatsWidget({super.key, required this.stats});

  final TasksStats stats;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(18.0),
        child: Column(
          children: [
            const SizedBox(height: 30),
            const Text(
              "All time tasks done:",
              style: TextStyle(fontSize: 28),
            ),
            Text(
              '${stats.allTasksDone}/${stats.allTasks}',
              style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            const Text(
              '"Consistency is what transforms average into excellence"',
              style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.w500,
                  fontStyle: FontStyle.italic,
                  fontSize: 18),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    "Daily statistics:",
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  Text("Tasks done: ${stats.tasksDoneToday}",
                      style: const TextStyle(fontSize: 18)),
                  Text(
                      "Tasks executing until today: ${stats.tasksInExecutionToday}",
                      style: const TextStyle(fontSize: 18)),
                  Text(
                      "Tasks planned until today: ${stats.tasksInPlanningToday}",
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  const Text(
                    "Weekly statistics:",
                    style: TextStyle(
                      fontSize: 26,
                    ),
                  ),
                  Text("Tasks done past week: ${stats.tasksDoneToday}",
                      style: const TextStyle(fontSize: 18)),
                  Text(
                      "Tasks executing for this week: ${stats.tasksInExecutionWeekly}",
                      style: const TextStyle(fontSize: 18)),
                  Text(
                      "Tasks planned for this week: ${stats.tasksInPlanningWeekly}",
                      style: const TextStyle(fontSize: 18)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
