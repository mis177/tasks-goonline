import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:notes_goonline/const/task_priority.dart';
import 'package:notes_goonline/const/task_status.dart';
import 'package:notes_goonline/models/task_model.dart';
import 'package:notes_goonline/services/database/bloc/task_service_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';
import 'package:notes_goonline/utils/ui/confirmation_dialog.dart';

void showEditNoteDialog({required BuildContext context, Task? task}) {
  bool isOldTask = task != null;
  DateTime? deadlineDate;

  final TextEditingController taskNameController = TextEditingController(
    text: isOldTask ? task.name : "",
  );
  final TextEditingController taskDescriptionController = TextEditingController(
    text: isOldTask ? task.description : "",
  );
  final TextEditingController taskDeadlineController = TextEditingController(
    text: isOldTask ? DateFormat('yyyy-MM-dd').format(DateTime.fromMillisecondsSinceEpoch(task.deadline)) : "",
  );
  final TextEditingController taskPriorityController = TextEditingController(
    text: isOldTask ? task.priority.toString() : "5",
  );
  final TextEditingController taskStatusController = TextEditingController(
    text: isOldTask ? task.status : taskStatus[0],
  );
  final TextEditingController taskOwnerController = TextEditingController(
    text: isOldTask ? task.owner : "",
  );

  showDialog(
    context: context,
    builder: (_) => BlocProvider.value(
      value: BlocProvider.of<TaskServiceBloc>(context),
      child: AlertDialog(
        backgroundColor: Theme.of(context).colorScheme.surface,
        title: Center(
          child: Text(
            isOldTask ? "Edit Task" : "New Task",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTextFormField(
                context,
                controller: taskNameController,
                label: "Task Name",
                icon: Icons.title,
              ),
              _buildTextFormField(
                context,
                controller: taskDescriptionController,
                label: "Task Description",
                icon: Icons.description,
              ),
              _buildDatePicker(
                context,
                controller: taskDeadlineController,
                initialDate: isOldTask ? DateTime.fromMillisecondsSinceEpoch(task.deadline) : DateTime.now(),
                onDateSelected: (date) {
                  deadlineDate = date;
                  taskDeadlineController.text = DateFormat('yyyy-MM-dd').format(date);
                },
              ),
              _buildDropdown(
                context,
                controller: taskPriorityController,
                items: taskPriority,
                hintText: "Select Priority",
              ),
              _buildDropdown(
                context,
                controller: taskStatusController,
                items: taskStatus,
                hintText: "Select Status",
              ),
              _buildTextFormField(
                context,
                controller: taskOwnerController,
                label: "Task Owner",
                icon: Icons.person,
              ),
            ],
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (isOldTask)
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () async {
                      final shouldDelete = await showConfirmationDialog(
                        context: context,
                        title: 'Delete Task',
                        content: 'Are you sure you want to delete this task?',
                      );
                      if (shouldDelete == true && context.mounted) {
                        context.read<TaskServiceBloc>().add(
                              TaskServiceTaskDeleteRequested(task: task),
                            );
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () {
                        if (deadlineDate != null) {
                          final taskPriority = int.tryParse(taskPriorityController.text) ?? 5;
                          final doneDate =
                              taskStatusController.text == taskStatus[2] ? DateTime.now().millisecondsSinceEpoch : 0;

                          if (isOldTask) {
                            final isDeadlineChanged = deadlineDate!.millisecondsSinceEpoch != task.deadline;
                            final isStatusChanged =
                                taskStatusController.text != task.status && task.status == taskStatus[2];

                            context.read<TaskServiceBloc>().add(
                                  TaskServiceTaskUpdateRequested(
                                    task: Task(
                                      id: task.id,
                                      name: taskNameController.text,
                                      description: taskDescriptionController.text,
                                      deadline: deadlineDate!.millisecondsSinceEpoch,
                                      doneDate: doneDate,
                                      priority: taskPriority,
                                      owner: taskOwnerController.text,
                                      status: taskStatusController.text,
                                    ),
                                    isDeadlineChanged: isDeadlineChanged,
                                    isStatusChanged: isStatusChanged,
                                  ),
                                );
                          } else {
                            context.read<TaskServiceBloc>().add(
                                  TaskServiceTaskAddRequested(
                                    task: Task(
                                      id: DateTime.now().millisecondsSinceEpoch,
                                      name: taskNameController.text,
                                      description: taskDescriptionController.text,
                                      deadline: deadlineDate!.millisecondsSinceEpoch,
                                      doneDate: doneDate,
                                      priority: taskPriority,
                                      owner: taskOwnerController.text,
                                      status: taskStatusController.text,
                                    ),
                                  ),
                                );
                          }
                          Navigator.of(context).pop();
                        }
                      },
                      child: Text('OK', style: TextStyle(color: Theme.of(context).colorScheme.primary)),
                    ),
                  ],
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

Widget _buildTextFormField(
  BuildContext context, {
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      style: TextStyle(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

Widget _buildDatePicker(
  BuildContext context, {
  required TextEditingController controller,
  required DateTime initialDate,
  required void Function(DateTime) onDateSelected,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: Row(
      children: [
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              labelText: "Task Deadline",
              prefixIcon: const Icon(Icons.calendar_today),
              filled: true,
              fillColor: Theme.of(context).colorScheme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            enabled: false,
            textAlign: TextAlign.center,
          ),
        ),
        IconButton(
          icon: const Icon(Icons.calendar_today),
          onPressed: () async {
            final selectedDate = await showDatePicker(
              context: context,
              initialDate: initialDate,
              firstDate: DateTime.now(),
              lastDate: DateTime.now().add(const Duration(days: 365)),
            );
            if (selectedDate != null) {
              onDateSelected(selectedDate);
            }
          },
        ),
      ],
    ),
  );
}

Widget _buildDropdown(
  BuildContext context, {
  required TextEditingController controller,
  required List<dynamic> items,
  required String hintText,
}) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12.0),
    child: DropdownButtonFormField<String>(
      value: controller.text.isEmpty ? null : controller.text,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Theme.of(context).colorScheme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
      items: items
          .map((item) => DropdownMenuItem<String>(
                value: item.toString(),
                child: Text(item.toString()),
              ))
          .toList(),
      onChanged: (value) {
        if (value != null) {
          controller.text = value;
        }
      },
    ),
  );
}
