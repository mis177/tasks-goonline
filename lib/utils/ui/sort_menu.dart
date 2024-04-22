import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/const/database_const.dart';
import 'package:notes_goonline/services/database/bloc/task_service_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';

class ManuOption {
  String columnName;
  bool? clicked;
  bool? isAscending;

  ManuOption(
      {required this.columnName,
      required this.clicked,
      required this.isAscending});
}

class SortMenu extends StatefulWidget {
  const SortMenu({super.key, required this.blocContext});

  final BuildContext blocContext;

  @override
  State<SortMenu> createState() => _SortMenuState();
}

class _SortMenuState extends State<SortMenu> {
  List<ManuOption> sortOptions = [
    ManuOption(columnName: nameColumn, clicked: false, isAscending: null),
    ManuOption(
        columnName: descriptionColumn, clicked: false, isAscending: null),
    ManuOption(columnName: deadlineColumn, clicked: false, isAscending: null),
    ManuOption(columnName: priorityColumn, clicked: false, isAscending: null),
  ];

  // {
  //   nameColumn: false,
  //   descriptionColumn: false,
  //   deadlineColumn: false,
  //   priorityColumn: false
  // };
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
        value: BlocProvider.of<TaskServiceBloc>(context),
        child: PopupMenuButton(
          itemBuilder: (BuildContext context) =>
              getSortingOptions(context, widget.blocContext, sortOptions),
          child: const Icon(Icons.sort),
        ));
  }
}

List<PopupMenuItem<Widget>> getSortingOptions(BuildContext context,
    BuildContext blocContext, List<ManuOption> sortOptions) {
  List<PopupMenuItem<Widget>> optionsList = [];

  for (var option in sortOptions) {
    Icon sortIcon = option.isAscending == true
        ? const Icon(Icons.north)
        : const Icon(Icons.south);

    optionsList.add(PopupMenuItem(
      child: GestureDetector(
        child: Container(
          color: (option.clicked == true
              ? Theme.of(context).colorScheme.secondary
              : Colors.transparent),
          child: Row(
            children: [
              Expanded(
                  flex: 1,
                  child: Row(
                    children: [Text(option.columnName), sortIcon],
                  )),
            ],
          ),
        ),
        onTap: () {
          for (var element in sortOptions) {
            if (option != element) {
              element.clicked = false;
              element.isAscending = null;
            }
          }
          option.clicked = true;
          if (option.isAscending == null || option.isAscending == false) {
            option.isAscending = true;
          } else if (option.isAscending == true) {
            option.isAscending = false;
          }

          blocContext.read<TaskServiceBloc>().add(TaskServiceTaskSortRequested(
                columnName: option.columnName,
                isAscending: option.isAscending!,
                expectedValue: null,
              ));
          Navigator.of(context).pop();
        },
      ),
    ));
  }

  return optionsList;
}
