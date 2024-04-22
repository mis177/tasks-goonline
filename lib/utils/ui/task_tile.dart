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
          color: Theme.of(context).colorScheme.secondary,
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
                        fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.background),
                  child: Text(task.priority.toString()),
                ),
              ],
            ),
            Expanded(
              flex: 2,
              child: Text(
                task.description,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Deadline",
                  style: TextStyle(color: Colors.red),
                ),
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
