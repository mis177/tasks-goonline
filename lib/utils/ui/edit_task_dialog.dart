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
  taskPriorityTextController.text = isOldTask ? task.priority.toString() : "5";

  TextEditingController taskStatusTextController = TextEditingController();
  taskStatusTextController.text =
      isOldTask ? task.status.toString() : taskStatus[0];

  TextEditingController taskOwnerTextController = TextEditingController();
  taskOwnerTextController.text = isOldTask ? task.owner : "";

  showDialog(
      context: context,
      builder: (_) => BlocProvider.value(
            value: BlocProvider.of<TaskServiceBloc>(context),
            child: AlertDialog(
              backgroundColor: Theme.of(context).colorScheme.background,
              title: Center(
                child: Text(
                  isOldTask ? "Edit task" : "New task",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              icon: Icon(
                Icons.note,
                color: Theme.of(context).colorScheme.primary,
              ),
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      controller: taskNameTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        prefixIcon: const Icon(Icons.title),
                        border: const OutlineInputBorder(
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      controller: taskDescriptionTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        prefixIcon: const Icon(Icons.draw),
                        border: const OutlineInputBorder(
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
                          color: Theme.of(context).colorScheme.secondary,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all()),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Flexible(
                              child: TextField(
                                style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary),
                                controller: taskDeadlineTextController,
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor:
                                        Theme.of(context).colorScheme.secondary,
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
                    ),
                    const SizedBox(height: 12),
                    const Text("Task priority",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 4),
                    DropdownMenu(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            border: const OutlineInputBorder()),
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
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        )),
                    const SizedBox(height: 4),
                    DropdownMenu(
                        textStyle: TextStyle(
                            color: Theme.of(context).colorScheme.primary),
                        inputDecorationTheme: InputDecorationTheme(
                            filled: true,
                            fillColor: Theme.of(context).colorScheme.secondary,
                            border: const OutlineInputBorder()),
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
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.primary),
                      controller: taskOwnerTextController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Theme.of(context).colorScheme.secondary,
                        prefixIcon: const Icon(Icons.person),
                        border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(12))),
                        label: const Text("Owner"),
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
                          child: Text(
                            'CANCEL',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
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
                              int doneDate = 0;
                              if (taskStatusTextController.text ==
                                  taskStatus[2]) {
                                doneDate =
                                    DateTime.now().millisecondsSinceEpoch;
                              }
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
                                            doneDate: doneDate,
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
                          child: Text(
                            'OK',
                            style: TextStyle(
                                color: Theme.of(context).colorScheme.primary),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ));
}
