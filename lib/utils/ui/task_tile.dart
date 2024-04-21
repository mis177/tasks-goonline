import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:notes_goonline/models/task_model.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({super.key, required this.task, required this.onTap});

  final Task task;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.red,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  flex: 3,
                  child: Text(
                    task.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold, fontSize: 22),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.yellow),
                  child: Text(task.priority.toString()),
                ),
              ],
            ),
            Text(task.description),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text("Deadline"),
                Text(DateFormat('yyyy-MM-dd')
                    .format(DateTime.fromMillisecondsSinceEpoch(task.deadline))
                    .toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(task.status),
                Text(task.owner),
              ],
            )
          ],
        ),
        // Text(task.owner)
      ),
      onTap: () => onTap!(),
    );
  }
}
