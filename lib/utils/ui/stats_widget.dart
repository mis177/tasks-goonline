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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),
            const Text(
              "All time tasks done:",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              '${stats.allTasksDone}/${stats.allTasks}',
              style: const TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            const Text(
              '"Consistency is what transforms average into excellence"',
              style: TextStyle(
                fontSize: 18,
                color: Colors.black54,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 30),
            _buildStatsCard(
              context,
              title: "Daily statistics:",
              stats: [
                "Tasks done: ${stats.tasksDoneToday}",
                "Tasks executing until today: ${stats.tasksInExecutionToday}",
                "Tasks planned until today: ${stats.tasksInPlanningToday}",
              ],
            ),
            const SizedBox(height: 30),
            _buildStatsCard(
              context,
              title: "Weekly statistics:",
              stats: [
                "Tasks done past week: ${stats.tasksDoneWeekly}",
                "Tasks executing for this week: ${stats.tasksInExecutionWeekly}",
                "Tasks planned for this week: ${stats.tasksInPlanningWeekly}",
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsCard(BuildContext context, {required String title, required List<String> stats}) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
        boxShadow: const [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 12),
          ...stats.map((stat) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Text(
                  stat,
                  style: const TextStyle(
                    fontSize: 18,
                    color: Colors.black87,
                  ),
                ),
              )),
        ],
      ),
    );
  }
}
