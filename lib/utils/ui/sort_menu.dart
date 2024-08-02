import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:notes_goonline/const/database_const.dart';
import 'package:notes_goonline/services/database/bloc/task_service_bloc.dart';
import 'package:notes_goonline/services/database/bloc/task_service_event.dart';

class SortOption {
  final String columnName;
  bool clicked;
  bool? isAscending;

  SortOption({
    required this.columnName,
    this.clicked = false,
    this.isAscending,
  });
}

class SortMenu extends StatefulWidget {
  const SortMenu({super.key, required this.blocContext});

  final BuildContext blocContext;

  @override
  State<SortMenu> createState() => _SortMenuState();
}

class _SortMenuState extends State<SortMenu> {
  late List<SortOption> sortOptions;

  @override
  void initState() {
    super.initState();
    sortOptions = [
      SortOption(columnName: nameColumn),
      SortOption(columnName: descriptionColumn),
      SortOption(columnName: deadlineColumn),
      SortOption(columnName: priorityColumn),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: BlocProvider.of<TaskServiceBloc>(context),
      child: PopupMenuButton<int>(
        itemBuilder: (context) => _buildSortOptions(context),
        child: const Icon(Icons.sort, size: 28),
      ),
    );
  }

  List<PopupMenuEntry<int>> _buildSortOptions(BuildContext context) {
    return sortOptions.map((option) {
      final sortIcon = option.isAscending == true
          ? const Icon(Icons.arrow_upward, color: Colors.black54)
          : const Icon(Icons.arrow_downward, color: Colors.black54);

      return PopupMenuItem<int>(
        value: sortOptions.indexOf(option),
        child: Container(
          decoration: BoxDecoration(
            color: option.clicked ? Theme.of(context).colorScheme.secondary.withOpacity(0.1) : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            leading: sortIcon,
            title: Text(
              option.columnName,
              style: TextStyle(
                fontWeight: option.clicked ? FontWeight.bold : FontWeight.normal,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            onTap: () {
              _onSortOptionSelected(option);
            },
          ),
        ),
      );
    }).toList();
  }

  void _onSortOptionSelected(SortOption selectedOption) {
    setState(() {
      for (var option in sortOptions) {
        if (option != selectedOption) {
          option.clicked = false;
          option.isAscending = null;
        }
      }
      selectedOption.clicked = true;
      selectedOption.isAscending = selectedOption.isAscending == null || !selectedOption.isAscending!;
    });

    widget.blocContext.read<TaskServiceBloc>().add(
          TaskServiceTaskSortRequested(
            columnName: selectedOption.columnName,
            isAscending: selectedOption.isAscending!,
          ),
        );

    Navigator.of(context).pop();
  }
}
