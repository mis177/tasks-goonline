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

  TextEditingController taskNameTextController = TextEditingController();
  taskNameTextController.text = isOldTask ? task.name : "";
  TextEditingController taskDescriptionTextController = TextEditingController();
  taskDescriptionTextController.text = isOldTask ? task.description : "";

  TextEditingController taskDeadlineTextController = TextEditingController();
  taskDeadlineTextController.text = isOldTask
      ? DateFormat('yyyy-MM-dd')
          .format(DateTime.fromMillisecondsSinceEpoch(task.deadline))
          .toString()
      : "";

  TextEditingController taskPriorityTextController = TextEditingController();
  taskPriorityTextController.text = isOldTask ? task.priority.toString() : "";

  TextEditingController taskStatusTextController = TextEditingController();
  taskStatusTextController.text = isOldTask ? task.status.toString() : "";

  TextEditingController taskOwnerTextController = TextEditingController();
  taskOwnerTextController.text = isOldTask ? task.owner : "";

  showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
            value: BlocProvider.of<TaskServiceBloc>(context),
            child: AlertDialog(
              title: Center(
                child: Text(
                  isOldTask ? "Edit task" : "New task",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              icon: const Icon(Icons.note),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Task name",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: taskNameTextController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.title),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        hintText: "Name",
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Task description",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    TextField(
                      controller: taskDescriptionTextController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.draw),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        hintText: "Description",
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Task deadline",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12)),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Flexible(
                            child: TextField(
                              controller: taskDeadlineTextController,
                              decoration: const InputDecoration(
                                  border: InputBorder.none),
                              textAlign: TextAlign.center,
                              enabled: false,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              deadlineDate = await showDatePicker(
                                  context: context,
                                  firstDate: DateTime.now(),
                                  lastDate: DateTime.now()
                                      .add(const Duration(days: 365)));

                              if (context.mounted && deadlineDate != null) {
                                taskDeadlineTextController.text =
                                    DateFormat('yyyy-MM-dd')
                                        .format(deadlineDate!)
                                        .toString();
                              }
                            },
                            icon: const Icon(Icons.calendar_month),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text("Task priority",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownMenu(
                        controller: taskPriorityTextController,
                        hintText: "Priority",
                        initialSelection: taskPriorityTextController.text,
                        dropdownMenuEntries: taskPriority
                            .map((e) => DropdownMenuEntry<int>(
                                value: e, label: e.toString()))
                            .toList()),
                    const SizedBox(height: 12),
                    const Text("Task status",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownMenu(
                        controller: taskStatusTextController,
                        hintText: "Status",
                        initialSelection: taskStatusTextController.text,
                        dropdownMenuEntries: taskStatus
                            .map((e) => DropdownMenuEntry<String>(
                                value: e, label: e.toString()))
                            .toList()),
                    const SizedBox(height: 12),
                    const Text("Task owner",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    TextField(
                      controller: taskOwnerTextController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.person),
                        border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        label: Text("Owner"),
                      ),
                    )
                  ],
                ),
              ),
              actions: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                        onPressed: () async {
                          if (task != null) {
                            bool? shouldDelete = await showConfirmationDialog(
                                context: context,
                                title: 'Delete task',
                                content: 'Do you want to delete this task?');

                            if (shouldDelete == true && context.mounted) {
                              context.read<TaskServiceBloc>().add(
                                  TaskServiceTaskDeleteRequested(task: task));
                              Navigator.of(context).pop();
                            }
                          }
                        },
                        icon: const Icon(Icons.delete)),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('CANCEL'),
                        ),
                        TextButton(
                          onPressed: () {
                            if (deadlineDate == null && isOldTask) {
                              deadlineDate =
                                  DateTime.fromMillisecondsSinceEpoch(
                                      task.deadline);
                            }
                            if (deadlineDate != null) {
                              int? taskPriority =
                                  int.tryParse(taskPriorityTextController.text);
                              taskPriority ??= 5;
                              if (isOldTask) {
                                context.read<TaskServiceBloc>().add(
                                      TaskServiceTaskUpdateRequested(
                                        task: Task(
                                            id: task.id,
                                            name: taskNameTextController.text,
                                            description:
                                                taskDescriptionTextController
                                                    .text,
                                            deadline: deadlineDate!
                                                .millisecondsSinceEpoch,
                                            doneDate: 0,
                                            priority: taskPriority,
                                            owner: taskOwnerTextController.text,
                                            status:
                                                taskStatusTextController.text),
                                      ),
                                    );
                              } else {
                                context.read<TaskServiceBloc>().add(
                                      TaskServiceTaskAddRequested(
                                        task: Task(
                                            id: DateTime.now()
                                                .millisecondsSinceEpoch,
                                            name: taskNameTextController.text,
                                            description:
                                                taskDescriptionTextController
                                                    .text,
                                            deadline: deadlineDate!
                                                .millisecondsSinceEpoch,
                                            doneDate: 0,
                                            priority: taskPriority,
                                            owner: taskOwnerTextController.text,
                                            status:
                                                taskStatusTextController.text),
                                      ),
                                    );
                              }
                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
}
